import 'package:flutter/material.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart' as DatesFunctions;


final Shader linearGradient = LinearGradient(
  colors: <Color>[const Color(0xFF84bd00), const Color(0xFF00a3e0)],
).createShader(Rect.fromLTWH(0.0, 0.0, 80.0, 70.0));

Widget build(context){

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 140,
          color: Colors.white,
          child: DrawerHeader(
              duration: Duration(milliseconds: 500),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            DatesFunctions.getCurrentYear().toString(),
                            style: TextStyle(
                                fontSize: 33,
                                foreground: Paint()
                                  ..shader = linearGradient),
                          ),
                          margin: EdgeInsets.only(top: 5, left: 0),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Stack(
                            children: [
                              Container(
                                child: Text(
                                  'operational calendar',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Aramco',
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff5b5a5f)),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 17,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        DatesFunctions
                                            .getFirstHijryYear(
                                            DatesFunctions.getFirstDayOfYear(DatesFunctions
                                                .getCurrentYear()))
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Aramco',
                                            fontSize: 12,
                                            color: const Color(
                                                0xFF00a3e0)),
                                      ),
                                      Text(
                                        '-' +
                                            DatesFunctions
                                                .getSecondHijryYear(DatesFunctions
                                                .getLastDayOfYear(DatesFunctions
                                                .getCurrentYear()))
                                                .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Aramco',
                                            fontSize: 12,
                                            color: const Color(
                                                0xFF84bd00)),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ),
        ListTile(
          title: Row(
            children: [
              Container(
                child: Icon(
                  Icons.arrow_right_sharp,
                  size: 15,
                  color: const Color(0xFF00a3e0),
                ),
                margin: EdgeInsets.only(right: 8),
              ),
              Text('Login'),
            ],
          ),
          onTap: () {
            Navigator.pop(context);

          },
        ),
        ListTile(
          title: Row(
            children: [
              Container(
                child: Icon(
                  Icons.arrow_right_sharp,
                  size: 15,
                  color: const Color(0xFF00a3e0),
                ),
                margin: EdgeInsets.only(right: 8),
              ),
              Text('Add New Event'),
            ],
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Row(
            children: [
              Container(
                child: Icon(
                  Icons.arrow_right_sharp,
                  size: 15,
                  color: const Color(0xFF00a3e0),
                ),
                margin: EdgeInsets.only(right: 8),
              ),
              Text('Privacy Policy'),
            ],
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );


}
