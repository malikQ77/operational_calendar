import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aramco_calendar/Api/DatesApi.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aramco_calendar/Widgets/home.dart' as Home;
import 'package:aramco_calendar/Routes/routesHandler.dart' as RoutesHandler;

class Login extends StatefulWidget {
  final String title;

  Login({Key key, this.title}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  dynamic _device_token;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging _messaging = FirebaseMessaging();
    _messaging.getToken().then((value)  {
      _device_token = value;
    });
    super.initState();
  }
  void _handleLogin() async {
    print(_device_token);
    var data = {
      'username': usernameController.text,
      'password': passwordController.text,
      'device_token': _device_token,
    };
    var res = await CallApi().postData(data, 'api/login');
    var body = json.decode(res.body);
    if (body['success']) {
      await FlutterSession().set("user_id", body['data']['id']);
      await FlutterSession().set("is_login", body['success']);
      Navigator.of(context)
          .push(RoutesHandler.route(Home.HomePage()));
    } else {
      await FlutterSession().set("user_id", 0);
      await FlutterSession().set("is_login", body['success']);
    }
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 4,
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                    alignment: Alignment.center,
                    child: TextField(
                      autofocus: false,
                      controller: usernameController,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.drive_file_rename_outline,
                          color: Color(0xFF00a3e0).withOpacity(0.5),
                        ),
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffdadada), width: 1.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF02a1e2), width: 1.0),
                        ),
                        fillColor: Colors.white,
                        hintText: 'Username',
                        contentPadding: EdgeInsets.zero,
                        hintStyle:
                            TextStyle(fontSize: 18, color: Color(0xffdadada)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    alignment: Alignment.center,
                    child: TextField(
                      autofocus: false,
                      obscureText: true,
                      controller: passwordController,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.drive_file_rename_outline,
                          color: Color(0xFF00a3e0).withOpacity(0.5),
                        ),
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffdadada), width: 1.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF02a1e2), width: 1.0),
                        ),
                        fillColor: Colors.white,
                        hintText: 'Password',
                        contentPadding: EdgeInsets.zero,
                        hintStyle:
                            TextStyle(fontSize: 18, color: Color(0xffdadada)),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () {
                          _handleLogin();
                        },
                        child: Text('Login'),
                      )),
                ],
              )),
        ));
  }
}
