import 'package:chat_app/widgets/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreMessage extends StatelessWidget {
  const FireStoreMessage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('chat_messages').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData) 
           return LinearProgressIndicator();
        return ChatList(snapshots: snapshot.data.documents,);
      },
    )
    ;
  }
}