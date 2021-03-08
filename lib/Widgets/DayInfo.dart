import 'package:aramco_calendar/Models/Event.dart';
import 'package:aramco_calendar/Models/Reminder.dart';
import 'package:aramco_calendar/Models/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart';

class DayInfo extends StatefulWidget {
  final dynamic day;
  final int monthNumber;

  DayInfo(this.day, this.monthNumber);

  @override
  _DayInfoState createState() => _DayInfoState();
}

class _DayInfoState extends State<DayInfo> with SingleTickerProviderStateMixin {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[const Color(0xFF84bd00), const Color(0xFF00a3e0)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 80.0, 70.0));
  bool _done = false;

  // merge 3 array
  // sorting by timestamp
  // display /:

  // 1- add event start date and end date, also is start or end
  // 2- make all of theme same name time , date => x taskTime
  // 3- marge 3 array
  // 4- sort by time
  // 5- format time
  // 6- display

  @override
  Widget build(BuildContext context) {
    List<dynamic> sortedRemindersAndTasks = new List();
    sortedRemindersAndTasks..insertAll(0, widget.day.reminders);
    sortedRemindersAndTasks..insertAll(0, widget.day.tasks);
    sortedRemindersAndTasks.shuffle();
    sortedRemindersAndTasks.sort((a, b) {
      var adate = DateTime.parse(a.time);
      var bdate = DateTime.parse(b.time);
      return adate.compareTo(bdate);
    });
    sortedRemindersAndTasks..insertAll(0, widget.day.events);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            widget.day.dayName,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          flexibleSpace: Container(
              decoration: new BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF84bd00), Color(0xFF00a3e0)]))),
        ),
        body: Stack(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 15, left: 25, right: 25, bottom: 70),
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF84bd00), Color(0xFF00a3e0)])),
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.day.type == 'Normal' ||  widget.day.type == 'WeekEndDay'
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 30,
                                margin: EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: Color(widget.day.bgColor),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: 1,
                                      blurRadius: 0,
                                      offset: Offset(1, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                widget.day.type == 'RescheduledDaysOff'
                                    ? 'Rescheduled Day Off'
                                    : widget.day.type == 'Holidays'
                                        ? 'Holiday'
                                        : widget.day.type == 'NationalDay'
                                            ? 'National Day'
                                            : widget.day.type == 'RamadanDay'
                                                ? 'Ramadan Day'
                                                : '',
                              )
                            ],
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('yMMMMd')
                            .format(new DateTime(getCurrentYear(),
                                widget.monthNumber, widget.day.date))
                            .toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.day.full_dateHijri[widget.day.date - 1]
                            .toFormat('dd MMMM, yyyy'),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ],
              )),
            ),
            Container(
              margin: EdgeInsets.only(top: 90, left: 10, right: 10),
              padding: EdgeInsets.only(top: 0, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Timeline.tileBuilder(
                theme: TimelineTheme.of(context).copyWith(
                  nodePosition: 0,
                  connectorTheme: TimelineTheme.of(context)
                      .connectorTheme
                      .copyWith(thickness: 1.0, color: Color(0xffdadada)),
                  indicatorTheme: TimelineTheme.of(context)
                      .indicatorTheme
                      .copyWith(
                          size: 25.0, position: 0.5, color: Color(0xffdadada)),
                ),
                builder: TimelineTileBuilder.fromStyle(
                  indicatorStyle: IndicatorStyle.outlined,
                  contentsBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                        top: 24, left: 15, right: 10, bottom: 24),
                    child: sortedRemindersAndTasks[index].runtimeType == Event
                        ? Container(
                            margin: EdgeInsets.only(left: 0, right: 0),
                            padding: EdgeInsets.only(
                                left: 8, right: 0, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 3.0,
                                    color: Color(sortedRemindersAndTasks[index]
                                        .eventColor)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Event: ' +
                                          sortedRemindersAndTasks[index]
                                              .eventName,
                                      style: _done
                                          ? TextStyle(
                                              color: Colors.black87,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: Colors.red)
                                          : TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : sortedRemindersAndTasks[index].runtimeType == Task
                            ? Container(
                                margin: EdgeInsets.only(left: 0, right: 0),
                                padding: EdgeInsets.only(
                                    left: 8, right: 0, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                        width: 3.0,
                                        color: Color(
                                            sortedRemindersAndTasks[index]
                                                .taskColor)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(DateFormat.jm().format(
                                            DateTime.parse(
                                                sortedRemindersAndTasks[index]
                                                    .time))),
                                        Text(
                                          'Task: ' +
                                              sortedRemindersAndTasks[index]
                                                  .taskName,
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : sortedRemindersAndTasks[index].runtimeType ==
                                    Reminder
                                ? Container(
                                    margin: EdgeInsets.only(left: 0, right: 0),
                                    padding: EdgeInsets.only(
                                        left: 8, right: 0, top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            width: 3.0,
                                            color: Color(
                                                sortedRemindersAndTasks[index]
                                                    .reminderColor)),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(DateFormat.jm().format(
                                                DateTime.parse(
                                                    sortedRemindersAndTasks[
                                                            index]
                                                        .time))),
                                            Text(
                                              'Reminder: ' +
                                                  sortedRemindersAndTasks[index]
                                                      .reminderName,
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                  ),
                  itemCount: sortedRemindersAndTasks.length,
                ),
              ),
            )
          ],
        ));
  }
}
