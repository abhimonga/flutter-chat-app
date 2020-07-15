import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  final GoogleSignInAccount currentUser;
  TextComposer({Key key, this.currentUser, }) : super(key: key);

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer>
    with TickerProviderStateMixin {
  TextEditingController _textEditingController = TextEditingController();
  bool isComposing = false;
  void _handleMessage(String text) {
    _textEditingController.clear();
    setState(() {
      isComposing = false;
      
    });
    _sendMessage(text:text);
  }
  void _sendMessage({String text,String photoUrl}){
    Firestore.instance.collection('chat_messages').document().setData({
       'name':widget.currentUser.displayName,
       'avatarUrl':widget.currentUser.photoUrl,
       'photoUrl':photoUrl,
       'text':text,
       'timestamp':DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color:Colors.white),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: Container(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () async{
                  File imageFile=await ImagePicker.pickImage(
                    source: ImageSource.gallery,
                    maxHeight: 300,
                    maxWidth: 250);
                    String timestamp=DateTime.now().millisecondsSinceEpoch.toString();
                    StorageReference ref=FirebaseStorage.instance.ref().child('image_$timestamp.jpg');
                    StorageUploadTask task=ref.putFile(imageFile);
                    var downloadUrl=await(await task.onComplete).ref.getDownloadURL();
                    _sendMessage(photoUrl:downloadUrl.toString());
                },
              ),
              Flexible(
                child: TextField(
                  onSubmitted: _handleMessage,
                  controller: _textEditingController,
                  onChanged: (String text) {
                    setState(() {
                      isComposing = text.length > 0;
                    });
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Enter your message"),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: isComposing
                    ? () => _handleMessage(_textEditingController.text)
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
