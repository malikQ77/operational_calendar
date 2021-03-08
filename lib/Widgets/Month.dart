import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:aramco_calendar/Models/Month.dart';
import 'package:aramco_calendar/Widgets/MonthTitle.dart' as MonthTitle;
import 'package:aramco_calendar/Widgets/WeekNumbers.dart' as WeeksNumbersWidget;
import 'package:aramco_calendar/Widgets/Day.dart' as DayWidget;
import 'package:aramco_calendar/Widgets/WeekDaysName.dart' as DaysNames;

import 'package:aramco_calendar/Routes/routesHandler.dart' as RoutesHandler;

import 'package:aramco_calendar/Widgets/Login.dart' as Login;
import 'package:aramco_calendar/Widgets/DayInfo.dart' as DayInfo;

class MonthWidget extends StatefulWidget {
  final dynamic month;

  final bool MonthTitleColor;
  final List<int> monthWeeksNumbers;

  MonthWidget(this.month, this.monthWeeksNumbers, this.MonthTitleColor);

  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
          child: Column(
            children: [
              Container(
                child: new MonthTitle.MonthTitleWidget(
                    widget.month.name,
                    widget.month.first_H.longMonthName,
                    widget.month.second_H.longMonthName,
                    widget.month.first_H.hMonth.toString(),
                    widget.month.second_H.hMonth.toString(),
                    widget.month.firstHijryYear,
                    widget.month.secondHijryYear,
                    widget.month.number,
                    widget.MonthTitleColor),
                height: 50,
              ),
              new Container(
                height: 30,
                child: new DaysNames.MonthDaysNameWidget(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    width: 25,
                    height: 280,
                    child: new WeeksNumbersWidget.MonthWeeksNumbersWidget(
                        widget.monthWeeksNumbers),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 280,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: widget.month.weeks
                              .map<Widget>((week) => new Container(
                                      child: new Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        for (int i = 0;
                                            i < week.days.length;
                                            i++)
                                          new GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  RoutesHandler.route(
                                                      DayInfo.DayInfo(week.days[i] , widget.month.number)));
                                            },
                                            child: week.days[i].date == null ? SizedBox(width: 40, height: 35,) : week.days[i].type == 'Normal' ? Container(
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
                                                  color: Color(week.days[i].bgColor),
                                                ),
                                                padding: EdgeInsets.only(left: 5, right: 6.5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          week.days[i].date.toString().padLeft(2, '0'),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              color: week.days[i].type == 'RescheduledDaysOff' ||
                                                                  week.days[i].type == 'Holidays' ||
                                                                  week.days[i].type == 'NationalDay' ||
                                                                  week.days[i].type == 'RamadanDay'
                                                                  ? Colors.white
                                                                  : Colors.black87),
                                                        ),
                                                        Text(
                                                          week.days[i].H_date.toString().padLeft(2, '0'),
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: week.days[i].type == 'RescheduledDaysOff' ||
                                                                  week.days[i].type == 'Holidays' ||
                                                                  week.days[i].type == 'NationalDay' ||
                                                                  week.days[i].type == 'RamadanDay'
                                                                  ? Colors.white
                                                                  : Color(week.days[i].txColor)),
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
                                                        color: week.days[i].reminders.isEmpty &&
                                                            week.days[i].tasks.isEmpty &&
                                                            week.days[i].events.isEmpty
                                                            ? Color(week.days[i].bgColor)
                                                            : week.days[i].events.isNotEmpty
                                                            ? Color(week.days[i].events[0].eventColor)
                                                            : week.days[i].tasks.isNotEmpty
                                                            ? Color(week.days[i].tasks[0].taskColor)
                                                            : week.days[i].reminders.isNotEmpty
                                                            ? Color(
                                                            week.days[i].reminders[0].reminderColor)
                                                            : Color(week.days[i].bgColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ) : Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  topRight: Radius.circular(8.0),
                                                  bottomRight: Radius.circular(8.0),
                                                ),
                                                color: Color(week.days[i].bgColor),
                                              ),
                                              width: 40,
                                              height: 35,
                                              padding: EdgeInsets.only(left: 5, right: 6.5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        week.days[i].date.toString().padLeft(2, '0'),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: week.days[i].type == 'RescheduledDaysOff' ||
                                                                week.days[i].type == 'Holidays' ||
                                                                week.days[i].type == 'NationalDay' ||
                                                                week.days[i].type == 'RamadanDay'
                                                                ? Colors.white
                                                                : Colors.black87),
                                                      ),
                                                      Text(
                                                        week.days[i].H_date.toString().padLeft(2, '0'),
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: week.days[i].type == 'RescheduledDaysOff' ||
                                                                week.days[i].type == 'Holidays' ||
                                                                week.days[i].type == 'NationalDay' ||
                                                                week.days[i].type == 'RamadanDay'
                                                                ? Colors.white
                                                                : Color(week.days[i].txColor)),
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
                                                      color: week.days[i].reminders.isEmpty &&
                                                          week.days[i].tasks.isEmpty &&
                                                          week.days[i].events.isEmpty
                                                          ? Color(week.days[i].bgColor)
                                                          : week.days[i].events.isNotEmpty
                                                          ? Color(week.days[i].events[0].eventColor)
                                                          : week.days[i].tasks.isNotEmpty
                                                          ? Color(week.days[i].tasks[0].taskColor)
                                                          : week.days[i].reminders.isNotEmpty
                                                          ? Color(
                                                          week.days[i].reminders[0].reminderColor)
                                                          : Color(week.days[i].bgColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )))
                              .toList()),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
