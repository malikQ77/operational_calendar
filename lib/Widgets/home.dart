import 'dart:convert';

import 'package:aramco_calendar/Api/DatesApi.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart';
import 'package:aramco_calendar/main.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:aramco_calendar/Widgets/AppBar.dart' as AppBar;
import 'package:aramco_calendar/Widgets/Drawer.dart' as Drawer;
import 'package:aramco_calendar/Widgets/Month.dart' as MonthWidget;
import 'package:aramco_calendar/Widgets/Login.dart' as Login;

import 'package:aramco_calendar/Models/Month.dart' as MonthModel;
import 'package:aramco_calendar/Models/Week.dart' as WeekModel;
import 'package:aramco_calendar/Models/Day.dart' as DayModel;

import 'package:aramco_calendar/Routes/routesHandler.dart' as RoutesHandler;

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  bool _isBubbleClicked = false;
  bool _showAddTask = false;
  bool _isLogin = true;
  bool _isPanelOpen = true;
  bool _datePicker = false;
  bool _timePicker = false;
  bool _colorPicker = false;

  dynamic _date = new DateTime.now();
  dynamic _time =
      DateFormat.jm().format(new DateTime.now().add(Duration(minutes: 30)));
  dynamic _color = Colors.lightGreenAccent;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.slowMiddle, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  final _getDates = AsyncMemoizer();

  Future getDates() => _getDates.runOnce(() async {
        var res = await CallApi().getData('getDates');
        var body = json.decode(res.body);

        List<MonthModel.Month> year = new List<MonthModel.Month>();

        final currentYear = getCurrentYear();
        final firstHijryYear =
            getFirstHijryYear(getFirstDayOfYear(getCurrentYear())).toString();
        final secondHijryYear =
            getSecondHijryYear(getLastDayOfYear(getCurrentYear())).toString();
        final monthsLength = 12;
        List<String> monthNames = monthsName();

        var dayColor = true;

        for (int i = 1; i <= monthsLength; i++) {
          var date = listOfMonthDate(currentYear, i);
          var date_H = listOfHijriDatesOfMonth(currentYear, i);
          var weeks = eachDayWeekNumber(currentYear, i);
          List<int> WeekNumbers = weeks.toSet().toList();
          var first_H_month = getFirstHijriNameOfMonth(currentYear, i);
          var second_H_month = getLastHijriNameOfMonth(currentYear, i);

          List<WeekModel.Week> monthWeeks = [];
          for (int j = 0; j < WeekNumbers.length; j++) {
            List<DayModel.Day> weekDays = [];
            for (int z = 0; z < date_H.length; z++) {
              if (weeks[z] == WeekNumbers[j]) {
                if (date_H[z].hDay == 1) {
                  dayColor = !dayColor;
                }
                List<dynamic> tempDates = [];
                var tempDate = new DateFormat('yyyy-MM-dd')
                    .format(new DateTime(currentYear, i, date[z]));
                for (int kj = 0; kj < body.length; kj++) {
                  if (tempDate.toString() == body[kj]['date'].toString()) {
                    if (body[kj]['type'] == 'Holidays') {
                      weekDays.add(new DayModel.Day(
                          date[z],
                          date_H[z].hDay,
                          date_H[z].dayWeName,
                          date_H[z],
                          false,
                          true,
                          false,
                          dayColor));
                      tempDates.add(body[kj]['date']);
                    } else if (body[kj]['type'] == 'Rescheduled days off') {
                      weekDays.add(new DayModel.Day(
                          date[z],
                          date_H[z].hDay,
                          date_H[z].dayWeName,
                          date_H[z],
                          false,
                          false,
                          true,
                          dayColor));
                      tempDates.add(body[kj]['date']);
                    }
                  }
                }
                if (i == 9 && z == 22) {
                  weekDays.add(new DayModel.Day(
                      date[z],
                      date_H[z].hDay,
                      date_H[z].dayWeName,
                      date_H[z],
                      true,
                      false,
                      false,
                      dayColor));
                } else {
                  var tempDate = new DateFormat('yyyy-MM-dd')
                      .format(new DateTime(currentYear, i, date[z]));
                  if (!tempDates.contains(tempDate)) {
                    weekDays.add(new DayModel.Day(
                        date[z],
                        date_H[z].hDay,
                        date_H[z].dayWeName,
                        date_H[z],
                        false,
                        false,
                        false,
                        dayColor));
                  }
                }
              }
            }
            if (weekDays[0].dayName == 'Monday' && weekDays.length < 7) {
              for (int r = 0; r < 1; r++) {
                if (weekDays.length != 7) {
                  weekDays.insert(
                      0,
                      new DayModel.Day(
                          null, null, null, null, false, false, false, null));
                }
              }
            } else if (weekDays[0].dayName == 'Tuesday' &&
                weekDays.length < 7) {
              for (int r = 0; r < 2; r++) {
                if (weekDays.length != 7) {
                  weekDays.insert(
                      0,
                      new DayModel.Day(
                          null, null, null, null, false, false, false, null));
                }
              }
            } else if (weekDays[0].dayName == 'Wednesday' &&
                weekDays.length < 7) {
              for (int r = 0; r < 3; r++) {
                if (weekDays.length != 7) {
                  weekDays.insert(
                      0,
                      new DayModel.Day(
                          null, null, null, null, false, false, false, null));
                }
              }
            } else if (weekDays[0].dayName == 'Thursday' &&
                weekDays.length < 7) {
              for (int r = 0; r < 4; r++) {
                if (weekDays.length != 7) {
                  weekDays.insert(
                      0,
                      new DayModel.Day(
                          null, null, null, null, false, false, false, null));
                }
              }
            } else if (weekDays[0].dayName == 'Friday' && weekDays.length < 7) {
              for (int r = 0; r < 5; r++) {
                if (weekDays.length != 7) {
                  weekDays.insert(
                      0,
                      new DayModel.Day(
                          null, null, null, null, false, false, false, null));
                }
              }
            } else if (weekDays[0].dayName == 'Saturday' &&
                weekDays.length < 7) {
              for (int r = 0; r < 6; r++) {
                if (weekDays.length != 7) {
                  weekDays.insert(
                      0,
                      new DayModel.Day(
                          null, null, null, null, false, false, false, null));
                }
              }
            } else if (weekDays.length < 7) {
              for (int r = 0; r < 6; r++) {
                if (weekDays.length != 7) {
                  weekDays.insert(
                      weekDays.length,
                      new DayModel.Day(
                          null, null, null, null, false, false, false, null));
                }
              }
            }
            monthWeeks.add(new WeekModel.Week(WeekNumbers[j], weekDays));
          }

          year.add(new MonthModel.Month(monthNames[i - 1], i, first_H_month,
              second_H_month, monthWeeks, firstHijryYear, secondHijryYear));
        }

        return year;
      });

  bool colors(int number) {
    if (number.isEven) {
      return true;
    } else if (number.isOdd) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                AppBar.build(context),
                FutureBuilder(
                  future: getDates(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            margin: EdgeInsets.only(top: 150),
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Icon(Icons.error_outlined,
                                    size: 100,
                                    color: const Color(0xFF84bd00)
                                        .withOpacity(0.4)),
                                new SizedBox(
                                  height: 10,
                                ),
                                new Text(
                                  'Something went wrong. Please try again later.\n\n Need help? contact us ( hello@aramco.com ) ',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ));
                    }
                    if (snapshot.data == null) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            child: new CircularProgressIndicator(
                              backgroundColor: const Color(0xFF84bd00),
                            )),
                      );
                    } else {
                      return SliverGrid.count(
                          crossAxisCount: 1,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio: 0.9,
                          children: <Widget>[
                            for (int i = 0; i < snapshot.data.length; i++)
                              new Container(
                                height: MediaQuery.of(context).size.height,
                                margin: EdgeInsets.only(
                                    top: 10, right: 15, left: 15),
                                alignment: Alignment.center,
                                child: new MonthWidget.MonthWidget(
                                    snapshot.data[i],
                                    eachDayWeekNumber(getCurrentYear(), i + 1),
                                    colors(i)),
                              )
                          ]);
                    }
                  },
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                )
              ],
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.center,
                child: _showAddTask
                    ? SlidingUpPanel(
                        minHeight: MediaQuery.of(context).size.height / 2,
                        maxHeight: MediaQuery.of(context).size.height,
                        backdropEnabled: true,
                        backdropOpacity: 0,
                        defaultPanelState: PanelState.OPEN,
                        backdropTapClosesPanel: true,
                        onPanelClosed: () {
                          setState(() {
                            _isPanelOpen = false;
                          });
                        },
                        onPanelOpened: () {
                          setState(() {
                            _isPanelOpen = true;
                          });
                        },
                        header: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                left: 5, right: 15, top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffdadada),
                                  spreadRadius: 0,
                                  blurRadius: 0,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 25,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 25,
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      onPressed: () {
                                        setState(() {
                                          _showAddTask = false;
                                        });
                                      }),
                                ),
                                Container(
                                  width: 70,
                                  child: RaisedButton(
                                    color: Color(0xffc6007e),
                                    onPressed: () {},
                                    child: Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        panel: Container(
                          padding: EdgeInsets.only(top: 80),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffdadada), width: 1.0),
                                  ),
                                ),
                                child: TextField(
                                  autofocus: true,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.drive_file_rename_outline,
                                      color: Color(0xffdadada),
                                    ),
                                    filled: true,
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    hintText: 'Task title',
                                    hintStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffdadada), width: 1.0),
                                  ),
                                ),
                                child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.description_outlined,
                                      color: Color(0xffdadada),
                                    ),
                                    filled: true,
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    hintText: 'Task description',
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.only(
                                    left: 22, right: 22, bottom: 15, top: 7),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffdadada), width: 1.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_today_outlined,
                                            color: Color(0xffdadada)),
                                        Text(
                                            DateFormat.yMMMMd()
                                                .format(_date)
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _datePicker = !_datePicker;
                                                _timePicker = false;
                                                _colorPicker = false;
                                              });
                                            },
                                            child: Text(
                                              _datePicker ? 'Done' : 'Change',
                                              style: TextStyle(
                                                  color: Color(0xffc6007e)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _datePicker
                                        ? Theme(
                                            data: ThemeData.from(
                                                colorScheme: ColorScheme.light(
                                                    primary:
                                                        Color(0xffc6007e))),
                                            child: CalendarDatePicker(
                                              initialCalendarMode:
                                                  DatePickerMode.day,
                                              initialDate: _date,
                                              firstDate: DateTime(2021, 1, 1),
                                              // current year
                                              lastDate: DateTime(2021, 12, 31),
                                              // current year + 2
                                              currentDate: DateTime.now(),
                                              onDateChanged:
                                                  (DateTime newDateTime) {
                                                setState(() {
                                                  _date = newDateTime;
                                                });
                                              },
                                            ))
                                        : Container(),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.only(
                                    left: 22, right: 22, bottom: 15, top: 7),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffdadada), width: 1.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.access_time_outlined,
                                            color: Color(0xffdadada)),
                                        Text(_time.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _datePicker = false;
                                                _colorPicker = false;
                                                _timePicker = !_timePicker;
                                              });
                                            },
                                            child: Text(
                                              _timePicker ? 'Done' : 'Change',
                                              style: TextStyle(
                                                  color: Color(0xffc6007e)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _timePicker
                                        ? Container(
                                            height: 150,
                                            margin: EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            child: CupertinoTheme(
                                              data: CupertinoThemeData(
                                                textTheme:
                                                    CupertinoTextThemeData(
                                                  dateTimePickerTextStyle:
                                                      TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: DateTime.now(),
                                                onDateTimeChanged:
                                                    (DateTime newDateTime) {
                                                  setState(() {
                                                    _time = DateFormat.jm()
                                                        .format(newDateTime);
                                                  });
                                                },
                                                use24hFormat: false,
                                                minuteInterval: 1,
                                              ),
                                            ))
                                        : Container(),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.only(
                                    left: 22, right: 22, bottom: 15, top: 7),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffdadada), width: 1.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.color_lens_outlined,
                                            color: Color(0xffdadada)),
                                        Container(
                                          color: _color,
                                          width: 60,
                                          height: 30,
                                        ),
                                        Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _datePicker = false;
                                                _timePicker = false;
                                                _colorPicker = !_colorPicker;
                                              });
                                            },
                                            child: Text(
                                              _colorPicker ? 'Done' : 'Change',
                                              style: TextStyle(
                                                  color: Color(0xffc6007e)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    _colorPicker
                                        ? Container(
                                            height: 140,
                                            margin: EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            child: MaterialColorPicker(
                                              onMainColorChange: (color) {
                                                setState(() {
                                                  _color = color;
                                                });
                                              },
                                              selectedColor: _color,
                                              allowShades: false,
                                              circleSize: 50,
                                              elevation: 0,
                                              colors: [
                                                Colors.deepOrange,
                                                Colors.yellow,
                                                Colors.lightGreen,
                                                Colors.redAccent,
                                                Colors.pink,
                                                Colors.brown,
                                                Colors.blueGrey,
                                                Colors.tealAccent,
                                                Colors.lime,
                                                Colors.purple
                                              ],
                                            ))
                                        : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ),
            )
          ],
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: Drawer.build(context),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        //move it to new file
        floatingActionButton: _showAddTask
            ? Container()
            : FloatingActionBubble(
                // Menu items
                isBubbleClicked: _isBubbleClicked,
                items: <Bubble>[
                  Bubble(
                    title: "Reminder",
                    iconColor: Colors.white,
                    bubbleColor: Color(0xffc6007e),
                    icon: Icons.timer_rounded,
                    titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                    onPress: () {
                      setState(() {
                        _isBubbleClicked = !_isBubbleClicked;
                      });
                      _animationController.reverse();
                      _isLogin
                          ? null
                          : Navigator.of(context)
                              .push(RoutesHandler.route(Login.Login()));
                    },
                  ),
                  Bubble(
                    title: "Task",
                    iconColor: Colors.white,
                    bubbleColor: Color(0xffc6007e),
                    icon: Icons.assignment_turned_in_outlined,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    onPress: () {
                      _animationController.reverse();
                      _isLogin
                          ? setState(() {
                              _isBubbleClicked = !_isBubbleClicked;
                              _showAddTask = true;
                            })
                          : Navigator.of(context)
                              .push(RoutesHandler.route(Login.Login()));
                    },
                  ),
                  Bubble(
                    title: "Event",
                    iconColor: Colors.white,
                    bubbleColor: Color(0xffc6007e),
                    icon: Icons.event_outlined,
                    titleStyle: TextStyle(fontSize: 12, color: Colors.white),
                    onPress: () {
                      setState(() {
                        _animationController.reverse();
                        _isLogin
                            ? null
                            : Navigator.of(context)
                                .push(RoutesHandler.route(Login.Login()));
                        _isBubbleClicked = !_isBubbleClicked;
                      });
                    },
                  ),
                ],

                animation: _animation,

                onPress: () {
                  _animationController.isCompleted
                      ? _animationController.reverse()
                      : _animationController.forward();

                  setState(() {
                    _showAddTask = false;
                    _isBubbleClicked = !_isBubbleClicked;
                  });
                },

                iconColor: Colors.white,

                iconData: _isBubbleClicked ? Icons.close : Icons.add,
                backGroundColor:
                    _isBubbleClicked ? Color(0xFF84bd00) : Color(0xffc6007e),
              ));
  }
}
