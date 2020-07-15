import 'package:chat_app/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';

class FireStoreListAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FirestoreAnimatedList(
        query: Firestore.instance.collection('chat_messages').orderBy('timestamp',descending: true),
        reverse: true,
        itemBuilder: (BuildContext context, DocumentSnapshot snapshot,
            Animation<double> animation, int index) {
          return SizeTransition(
            child: ChatMessage(
              snapShot: snapshot,
            ),
            sizeFactor: CurvedAnimation(curve: Curves.easeOut,parent: animation),
          );
        },
      ),
    );
  }
}
