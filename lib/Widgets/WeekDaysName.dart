import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthDaysNameWidget extends StatefulWidget {

  @override
  _MonthDaysNameWidgetState createState() => _MonthDaysNameWidgetState();
}

class _MonthDaysNameWidgetState extends State<MonthDaysNameWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
          margin: EdgeInsets.only(top: 0, bottom: 10, left: 26, right: 10),
          child: new Row(
            children: [
              new Expanded(
                flex: 3,
                child: new Column(
                  children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        new Text(
                          'S',
                          style: TextStyle(fontSize: 13,
                              color: const Color(0xff5b5a5f),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          'M',
                          style: TextStyle(fontSize: 13,
                              color: const Color(0xff5b5a5f),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          'T',
                          style: TextStyle(fontSize: 13,
                              color: const Color(0xff5b5a5f),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          'W',
                          style: TextStyle(fontSize: 13,
                              color: const Color(0xff5b5a5f),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          'T',
                          style: TextStyle(fontSize: 13,
                              color: const Color(0xff5b5a5f),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),

                    new Container(
                      height: 0.5,
                      color: const Color(0xffdcdddf),
                    )
                  ],
                ),
              ),
              new Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        new Text(
                          'F',
                          style: TextStyle(fontSize: 13,
                              color: const Color(0xff5b5a5f),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        new Text(
                          'S',
                          style: TextStyle(fontSize: 13,
                              color: const Color(0xff5b5a5f),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    new Container(
                      height: 0.5,
                      margin: EdgeInsets.only(left: 3),
                      color: const Color(0xFF84bd00),
                    )
                  ],
                ),
              )

            ],
          ),
        ));
  }
}