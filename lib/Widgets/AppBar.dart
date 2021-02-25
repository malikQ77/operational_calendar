import 'package:flutter/material.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart' as DatesFunctions;
final Shader linearGradient = LinearGradient(
  colors: <Color>[const Color(0xFF84bd00), const Color(0xFF02a1e2)],
).createShader(Rect.fromLTWH(0.0, 0.0, 80.0, 70.0));

Widget build(context){
  return SliverAppBar(
      backgroundColor: Colors.white,
      forceElevated: false,
      elevation: 1.5,
      expandedHeight: 100.0,
      floating: true,
      snap: true,
      pinned: false,
      collapsedHeight: 70,
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          centerTitle: true,
          titlePadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  DatesFunctions.getCurrentYear().toString(),
                  style: TextStyle(
                      fontSize: 27,
                      foreground: Paint()..shader = linearGradient),
                ),
                margin: EdgeInsets.only(top: 25, left: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Stack(
                  children: [
                    Container(
                      child: Text(
                        'operational calendar',
                        style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Aramco',
                            color: const Color(0xff5b5a5f)),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: 13,
                        ),
                        child: Row(
                          children: [
                            Text(
                              DatesFunctions
                                  .getFirstHijryYear(
                                  DatesFunctions.getFirstDayOfYear(
                                      DatesFunctions.getCurrentYear()))
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Aramco',
                                  fontSize: 11,
                                  color: const Color(0xFF02a1e2)),
                            ),
                            Text(
                              '-' +
                                  DatesFunctions
                                      .getSecondHijryYear(
                                      DatesFunctions.getLastDayOfYear(
                                          DatesFunctions.getCurrentYear()))
                                      .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Aramco',
                                  fontSize: 11,
                                  color: const Color(0xFF84bd00)),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          )),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 15),
          child: Image.asset(
            'assets/saudi-aramco-logo.png',
            width: 110,
          ),
        ),
      ]);
}