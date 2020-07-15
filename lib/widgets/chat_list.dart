import 'package:chat_app/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  final List<DocumentSnapshot> snapshots;
  const ChatList({Key key, this.snapshots}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
          child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: snapshots.length,
        reverse: true,
        itemBuilder: (_, index) => ChatMessage(
          snapShot: snapshots[index],
        ),
      ),
    );
  }
}
