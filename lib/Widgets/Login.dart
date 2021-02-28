import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final String title;

  Login({Key key, this.title}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 4,
          title: Text(
            'Login',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          centerTitle: true,
        ),
        body: Center(child: Text('You need to login'),));
  }
}
