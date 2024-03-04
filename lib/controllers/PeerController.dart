import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jeu_de_la_vie/constants.dart';
import 'package:jeu_de_la_vie/models/Config.dart';
import 'package:jeu_de_la_vie/models/Message.dart';
import 'package:peerdart/peerdart.dart';



class PeerController extends ChangeNotifier {
  Peer? peer;

  DataConnection? connection;
  final String id;

  final history = <String, Message>{};

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
      notifyListeners();
    }
  }

  void listenData() {
    notifyListeners();
    connection?.on("data").listen((data) {
      final incomingMmessage = Message.fromJson(jsonDecode(data));
      history.putIfAbsent(incomingMmessage.id, () => incomingMmessage);
      final message = incomingMmessage.message;
      if (message.startsWith(OuiToRules)) {
        final id = message.replaceFirst(OuiToRules, "");
        if (history[id] != null && history[id]!.message.startsWith(Rules)) {
          print("$OuiToRules $id");
          history[id]?.message = history[id]!.message.replaceFirst(Rules, AcceptedRules);
        }
      } else if (message.startsWith(NonToRules)) {
        final id = message.replaceFirst(NonToRules, "");
        if (history[id] != null && history[id]!.message.startsWith(Rules)) {
          print("$NonToRules $id");
          history[id]?.message = history[id]!.message.replaceFirst(Rules, DeniedRules);
        }
      }
      else if(message.startsWith(SimulationDone)){
        final id = message.replaceFirst(SimulationDone, "");
        if (history[id] != null && history[id]!.message.startsWith(AcceptedRules)){
          print("$SimulationDone $id");
          history[id]?.message = history[id]!.message.replaceFirst(AcceptedRules, TerminatedRules);
        }
      }
      notifyListeners();
      print('${connection?.peer} > ${incomingMmessage.message} (${incomingMmessage.id})');
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
    if (message.startsWith(Rules)) {
      if(!Config.isValid(message.replaceFirst(Rules, ""))){
        message = "Rules are not valid: ${message.replaceFirst(Rules, "")}";
      }
    } else if (message.startsWith(OuiToRules)) {
      final id = message.replaceFirst(OuiToRules, "");
      if (history[id] != null && history[id]!.message.startsWith(Rules)) {
        print("$OuiToRules $id");
        history[id]?.message = history[id]!.message.replaceFirst(Rules, AcceptedRules);
      }
    } else if (message.startsWith(NonToRules)) {
      final id = message.replaceFirst(NonToRules, "");
      if (history[id] != null && history[id]!.message.startsWith(Rules)) {
        print("$NonToRules $id");
        history[id]?.message = history[id]!.message.replaceFirst(Rules, DeniedRules);
      }
    }
    else if(message.startsWith(SimulationDone)){
      final id = message.replaceFirst(SimulationDone, "");
      if (history[id] != null && history[id]!.message.startsWith(AcceptedRules)){
        print("$SimulationDone $id");
        history[id]?.message = history[id]!.message.replaceFirst(AcceptedRules, TerminatedRules);
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
