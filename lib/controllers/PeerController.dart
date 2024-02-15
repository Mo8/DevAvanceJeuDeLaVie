import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/models/Config.dart';
import 'package:jeu_de_la_vie/models/Message.dart';
import 'package:peerdart/peerdart.dart';

const String prefix = 'ynov-test-';

class PeerController extends ChangeNotifier {
  Peer? peer;

  DataConnection? connection;
  final String id;

  final history = <String, Message>{};

  Config? config;

  TextEditingController textEditingController = TextEditingController();

  PeerController(String id, BuildContext context) : id = "$prefix$id" {
    peer = Peer(
      id: this.id,
      options: PeerOptions(
        debug: LogLevel.Disabled,
      ),
    );

    peer?.on('open').listen((data) {
      print('peer open');
      notifyListeners();
    });

    peer?.on<DataConnection>('connection').listen((data) {
      print('${data.peer} connection...');
      connection = data;
      listenData();
    });
  }

  void reloadPeer() {
    if (peer?.disconnected == true) {
      peer?.reconnect();
    }
    notifyListeners();
  }

  void listenData() {
    notifyListeners();
    connection?.on("data").listen((data) {
      final message = Message.fromJson(jsonDecode(data));
      history.putIfAbsent(message.id, () => message);
      notifyListeners();
      print('${connection?.peer} > ${message.message} (${message.id})');
    });

    connection?.on("close").listen((data) {
      print('${connection!.peer} is close automatically');
      history.clear();
      connection = null;
      notifyListeners();
    });
  }

  void connect() {
    connection = peer?.connect("$prefix${textEditingController.text}");
    print('connecting to ${connection?.peer}...');
    connection?.on("open").listen((data) {
      print('${connection?.peer} connected !');
    });
    listenData();
  }

  void send(String message) {
    if (message.startsWith("RULES:")) {
      config = Config.parse(message.replaceFirst("RULES:", ""));
    } else if (message.startsWith("OUI TO RULES:")) {
      final id = message.replaceFirst("OUI TO RULES:", "");
      if (history[id] != null && history[id]!.message.startsWith("RULES:")) {
        print("OUI TO RULES: $id");
        history[id]?.message = history[id]!.message.replaceFirst("RULES:", "Accepted - RULES:");
      }
    } else if (message.startsWith("NON TO RULES:")) {
      final id = message.replaceFirst("NON TO RULES:", "");
      if (history[id] != null && history[id]!.message.startsWith("RULES:")) {
        print("NON TO RULES: $id");
        history[id]?.message = history[id]!.message.replaceFirst("RULES:", "Denied - RULES:");
      }
    }
    final Message messageToSend = Message(message: message, sender: id);
    connection?.send(jsonEncode(messageToSend.toJson()));

    history.putIfAbsent(messageToSend.id, () => messageToSend);
    notifyListeners();
    print('me > $message');
  }

  void close() {
    print('manuel close connection');
    connection?.closeRequest();
    history.clear();
    connection = null;
    notifyListeners();
  }
}
