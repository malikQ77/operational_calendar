import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayWidget extends StatefulWidget {
  final dynamic day;

  DayWidget(this.day);

  @override
  _DayWidgetState createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  @override

  Widget build(BuildContext context) {

    var textColor;
    if(widget.day.dayColor == true){
      textColor = const Color(0xFF02a1e2);
    }else{
      textColor = const Color(0xFF84bd00);
    }
    var dayWidget;
    if(widget.day.date == null){
      dayWidget = SizedBox(
        height: 35,
        width: 35,
      );
    }
    else if(widget.day.isDayoff == true){
      dayWidget = new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          color: Colors.orangeAccent,
        ),
        width: 40,
        height: 35,
        padding: EdgeInsets.only(left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.day.date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),),
            Text(widget.day.H_date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 11, color: Colors.white),),
          ],
        ),
      );
    }
    else if(widget.day.isHoliday == true){
      dayWidget = new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          color: Colors.blue,
        ),
        width: 40,
        height: 35,
        padding: EdgeInsets.only(left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.day.date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),),
            Text(widget.day.H_date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 11, color: Colors.white),),
          ],
        ),
      );
    }
    else if(widget.day.isNationalDay == true){
      dayWidget = new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          color: const Color(0xff643883),
        ),
        width: 40,
        height: 35,
        padding: EdgeInsets.only(left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.day.date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),),
            Text(widget.day.H_date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 11, color: Colors.white),),
          ],
        ),
      );
    }
    else if(widget.day.full_dateHijri.hMonth == 9){
      dayWidget = new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          color: const Color(0xFF84bd00),
        ),
        width: 40,
        height: 35,
        padding: EdgeInsets.only(left: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.day.date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),),
            Text(widget.day.H_date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 11, color: Colors.white),),
          ],
        ),
      );
    }
    else if(widget.day.dayName == "Friday" || widget.day.dayName == "Saturday" ){
      if(widget.day.isHoliday == false){
        dayWidget = new Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
            color: const Color(0xffdcdddf),
          ),
          width: 40,
          height: 35,
          padding: EdgeInsets.only(left: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.day.date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
              Text(widget.day.H_date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 11 , color: textColor),),
            ],
          ),
        );
      }
    }

    else{
      dayWidget = new Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
              ),
              color : const Color(0xffdcdddf)
          ),
          padding: EdgeInsets.only(left: 1.3, top: 1.3),
          width: 40,
          height: 35,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0),
              ),


              color: Colors.white,
            ),
            padding: EdgeInsets.only(left: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.day.date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                Text(widget.day.H_date.toString().padLeft(2, '0'),style: TextStyle(fontSize: 11 , color: textColor),),
              ],
            ),
          )
      );

    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: dayWidget
    );
  }
}
