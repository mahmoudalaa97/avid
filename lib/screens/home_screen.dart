
import 'package:avid/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  const HomeScreen({this.auth,this.onSignedOut}) ;

  void _signOut()async{
   try{
     await auth.signOut();
     onSignedOut();
   }catch(e){

   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Info"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(""),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed:_signOut,
            )
          ],
        ),
      ),
    );
  }
}