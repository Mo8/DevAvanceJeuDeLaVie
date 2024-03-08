import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:crypto/crypto.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:args/args.dart';

Future<void> main(List<String> args) async {
  print(args);
  final parser = ArgParser()
    ..addOption("port", abbr: "p", defaultsTo: "8082")
    ..addOption("mongoDB", abbr: "m",mandatory: true);

  final parse = parser.parse(args);

  final mongoDB = parse["mongoDB"];
  if (mongoDB == null) throw ArgumentError("Missing mongoDB");
  final port = int.parse(parse["port"]);

  print(mongoDB);

  final db = await mongo.Db.create(mongoDB);
  await db.open();
  final users = db.collection("users");
  if (await users.count() == 0) {
    await users.insertAll([
      {"username": "admin", "password": sha256.convert(utf8.encode("admin")).toString(), "config": "23A13D"},
      {"username": "user", "password": sha256.convert(utf8.encode("user")).toString(), "config": "23456A34D"},
    ]);
    print("Inserted");
  }
  Future<Response> echoRequest(Request request) async {
    print(request.url.path);
    switch (request.url.path) {
      case "login":
        if (request.method == "POST") {
          if (request.headers["content-type"] == null || !request.headers["content-type"]!.startsWith("application/json")) {
            return Response(400, body: "Content-Type must be application/json");
          }
          final body = jsonDecode(await request.readAsString());
          if (body["username"] == null || body["password"] == null) {
            return Response(400, body: "Missing login or password");
          }
          final result = await users.findOne(mongo.where.eq("username", body["username"]));
          if (result != null) {
            if (result["password"] == sha256.convert(utf8.encode(body["password"])).toString()) {
              return Response.ok(jsonEncode({"username": result["username"], "config": result["config"]}));
            }
            return Response.forbidden('Invalid username or password');
          } else {
            return Response.notFound('User not found');
          }
        }
        return Response.notFound('Request get for "${request.url}"');
      default:
        return Response.notFound('Request for "${request.url}"');
    }
  }

  var handler = const Pipeline().addMiddleware(logRequests()).addHandler(echoRequest);
  var server = await shelf_io.serve(handler, 'localhost', port);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
