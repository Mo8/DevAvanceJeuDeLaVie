import 'package:uuid/uuid.dart';

class Message{

  String id;

  String sender;
  String message;

  Message({required this.sender, required this.message,String? id }) : id = id ?? const Uuid().v4();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
    };
  }
}