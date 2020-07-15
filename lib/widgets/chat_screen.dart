import 'package:chat_app/widgets/firestore_list.dart';
import 'package:chat_app/widgets/firestore_messages.dart';
import 'package:chat_app/widgets/text_composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
enum MenuItem{signOut}
class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentUser;
  final _firebaseAuth=FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        _firebaseAuth.currentUser().then((firebaseUser){
                if(_firebaseUser==null){
                  _getFirebaseUser().then((firebaseUser){
                            setState(() {
                              _firebaseUser=firebaseUser;
                            });
                  });
                }
                else{
                  _firebaseUser=firebaseUser;
                }
        });
      });
    });
    _googleSignIn.signInSilently();
  }
   Future<FirebaseUser> _getFirebaseUser() async{
     final GoogleSignInAuthentication googleSignInAuthentication=await _googleSignIn.currentUser.authentication;
     final AuthCredential authCredential=GoogleAuthProvider.getCredential(idToken:googleSignInAuthentication.idToken , accessToken: googleSignInAuthentication.accessToken);
     return (await _firebaseAuth.signInWithCredential(authCredential)).user;
   }
  Future<Null> _handleSignIn() async {
    var user = _googleSignIn.currentUser;
    if (user == null) {
      await _googleSignIn.signInSilently();
    }
    if (user == null) {
      _googleSignIn.signIn();
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  

  @override
  Widget build(BuildContext context) {
    if (_firebaseUser == null) {
      return Scaffold(
        backgroundColor: Colors.blue[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SignInButton(
                Buttons.Google,
                onPressed: () => _handleSignIn(),
              )
            ],
          ),
        ),
      );
    } else
      return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text('Chat App'),
          actions: <Widget>[
             PopupMenuButton<MenuItem>(
               onSelected: (MenuItem menuItem){
                 setState(() {
                   _handleSignOut();
                 });
               },
               itemBuilder: (BuildContext context)=>
               <PopupMenuEntry<MenuItem>>[
                 PopupMenuItem<MenuItem>(
                   value: MenuItem.signOut,
                   child: Text('Google Signout'),
                 )
               ],
             )
          ],
        ),
        body: Column(
          children: <Widget>[
            FireStoreListAnimation(),
            Divider(
              height: 1.0,
            ),
            TextComposer(
            currentUser: _currentUser,
            )
          ],
        ),
      );
  }
}
