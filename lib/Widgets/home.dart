import 'dart:convert';

import 'package:aramco_calendar/Api/DatesApi.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';

import 'package:aramco_calendar/Widgets/AppBar.dart' as AppBar;
import 'package:aramco_calendar/Widgets/Drawer.dart' as Drawer;
import 'package:aramco_calendar/Widgets/Month.dart' as MonthWidget;

import 'package:aramco_calendar/Models/Month.dart' as MonthModel;
import 'package:aramco_calendar/Models/Week.dart' as WeekModel;
import 'package:aramco_calendar/Models/Day.dart' as DayModel;

import 'package:aramco_calendar/Widgets/FloatingActionButton.dart'
    as FloatingActionButton;
import 'package:aramco_calendar/Widgets/AddTaskPanel.dart' as AddTaskPanel;
import 'package:aramco_calendar/Widgets/AddEventPanel.dart' as AddEventPanel;
import 'package:aramco_calendar/Widgets/AddReminderPanel.dart' as AddReminderPanel;

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  bool _showAddTask = false;
  bool _showAddEvent = false;
  bool _showAddReminder = false;
  bool _isLogin = true;

  dynamic FloatingActionButtonAndBubbles;
  dynamic AddTaskPanelWidget;
  dynamic AddEventPanelWidget;
  dynamic AddReminderPanelWidget;

  void callback_FloatingActionButton(bool isLogin, showAddTask , showAddEvent , showAddReminder) {
    setState(() {
      this._isLogin = isLogin;
      this._showAddTask = showAddTask;
      this._showAddEvent = showAddEvent;
      this._showAddReminder = showAddReminder;
    });
  }

  void callback_AddTaskPanel(bool showAddTask) {
    setState(() {
      this._showAddTask = showAddTask;
    });
  }
  void callback_AddEventPanel(bool showAddEvent) {
    setState(() {
      this._showAddEvent = showAddEvent;
    });
  }
  void callback_AddReminderPanel(bool showAddReminder) {
    setState(() {
      this._showAddReminder = showAddReminder;
    });
  }

  @override
  void initState() {
    FloatingActionButtonAndBubbles = FloatingActionButton.FloatingActionButton(
        this.callback_FloatingActionButton);
    AddTaskPanelWidget = AddTaskPanel.AddTaskPanel(this.callback_AddTaskPanel);
    AddEventPanelWidget = AddEventPanel.AddEventPanel(this.callback_AddEventPanel);
    AddReminderPanelWidget = AddReminderPanel.AddReminderPanel(this.callback_AddReminderPanel);
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
                                  color:
                                      const Color(0xFF00a3e0).withOpacity(0.7)),
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
                            backgroundColor: const Color(0xFF00a3e0),
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
                              margin:
                                  EdgeInsets.only(top: 10, right: 15, left: 15),
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
          Align(
            alignment: Alignment.center,
            child:
            _showAddEvent ? AddEventPanelWidget : _showAddTask ? AddTaskPanelWidget : _showAddReminder ? AddReminderPanelWidget : Container(),
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: Drawer.build(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          _showAddTask || _showAddEvent || _showAddReminder ? Container() : FloatingActionButtonAndBubbles,

    );
  }
}
