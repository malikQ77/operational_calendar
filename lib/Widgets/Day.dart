import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aramco_calendar/Widgets/DayInfo.dart' as DayInfo;
import 'package:aramco_calendar/Routes/routesHandler.dart' as RoutesHandler;

import 'package:aramco_calendar/Widgets/Login.dart' as Login;
class DayWidget extends StatefulWidget {
  final dynamic day;

  DayWidget(this.day);

  @override
  _DayWidgetState createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {

  @override
  Widget build(BuildContext context) {

    var dayWidget;
    if (widget.day.date == null) {
      dayWidget = SizedBox(
        height: 35,
        width: 35,
      );
    } else if (widget.day.type == 'Normal') {
      dayWidget =  new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                ),
                color: Color(0xffdadada)),
            padding: EdgeInsets.only(left: 1, top: 1),
            width: 40,
            height: 35,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    bottomLeft: Radius.circular(0),
                  ),
                  color: Color(widget.day.bgColor),
                ),
                padding: EdgeInsets.only(left: 5, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.day.date.toString().padLeft(2, '0'),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: widget.day.type == 'RescheduledDaysOff' ||
                                  widget.day.type == 'Holidays' ||
                                  widget.day.type == 'NationalDay' ||
                                  widget.day.type == 'RamadanDay'
                                  ? Colors.white
                                  : Colors.black87),
                        ),
                        Text(
                          widget.day.H_date.toString().padLeft(2, '0'),
                          style: TextStyle(
                              fontSize: 11,
                              color: widget.day.type == 'RescheduledDaysOff' ||
                                  widget.day.type == 'Holidays' ||
                                  widget.day.type == 'NationalDay' ||
                                  widget.day.type == 'RamadanDay'
                                  ? Colors.white
                                  : Color(widget.day.txColor)),
                        ),
                      ],
                    ),
                    Container(
                      height: 25,
                      width: 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.0),
                          topRight: Radius.circular(2.0),
                          bottomRight: Radius.circular(2.0),
                          bottomLeft: Radius.circular(2.0),
                        ),
                        color: widget.day.reminders.isEmpty &&
                            widget.day.tasks.isEmpty &&
                            widget.day.events.isEmpty
                            ? Color(widget.day.bgColor)
                            : widget.day.events.isNotEmpty
                            ? Color(widget.day.events[0].eventColor)
                            : widget.day.tasks.isNotEmpty
                            ? Color(widget.day.tasks[0].taskColor)
                            : widget.day.reminders.isNotEmpty
                            ? Color(
                            widget.day.reminders[0].reminderColor)
                            : Color(widget.day.bgColor),
                      ),
                    ),
                  ],
                )),

      );
    } else {
      dayWidget =  new Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              color: Color(widget.day.bgColor),
            ),
            width: 40,
            height: 35,
            padding: EdgeInsets.only(left: 5, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.day.date.toString().padLeft(2, '0'),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: widget.day.type == 'RescheduledDaysOff' ||
                              widget.day.type == 'Holidays' ||
                              widget.day.type == 'NationalDay' ||
                              widget.day.type == 'RamadanDay'
                              ? Colors.white
                              : Colors.black87),
                    ),
                    Text(
                      widget.day.H_date.toString().padLeft(2, '0'),
                      style: TextStyle(
                          fontSize: 11,
                          color: widget.day.type == 'RescheduledDaysOff' ||
                              widget.day.type == 'Holidays' ||
                              widget.day.type == 'NationalDay' ||
                              widget.day.type == 'RamadanDay'
                              ? Colors.white
                              : Color(widget.day.txColor)),
                    ),
                  ],
                ),
                Container(
                  height: 25,
                  width: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.0),
                      topRight: Radius.circular(2.0),
                      bottomRight: Radius.circular(2.0),
                      bottomLeft: Radius.circular(2.0),
                    ),
                    color: widget.day.reminders.isEmpty &&
                        widget.day.tasks.isEmpty &&
                        widget.day.events.isEmpty
                        ? Color(widget.day.bgColor)
                        : widget.day.events.isNotEmpty
                        ? Color(widget.day.events[0].eventColor)
                        : widget.day.tasks.isNotEmpty
                        ? Color(widget.day.tasks[0].taskColor)
                        : widget.day.reminders.isNotEmpty
                        ? Color(
                        widget.day.reminders[0].reminderColor)
                        : Color(widget.day.bgColor),
                  ),
                ),
              ],
            ),
      );
    }
    return Scaffold(backgroundColor: Colors.white, body: dayWidget);
  }
}
