import 'dart:convert';

import 'package:aramco_calendar/Api/DatesApi.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

import 'package:aramco_calendar/Widgets/home.dart' as Home;
import 'package:aramco_calendar/Routes/routesHandler.dart' as RoutesHandler;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddReminderPanel extends StatefulWidget {
  Function callback_AddReminderPanel;

  AddReminderPanel(this.callback_AddReminderPanel);

  @override
  _AddReminderPanelState createState() => new _AddReminderPanelState();
}

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}

class _AddReminderPanelState extends State<AddReminderPanel>
    with SingleTickerProviderStateMixin {
  bool _isPanelOpen = true; // need it ??
  bool _datePicker = false;
  bool _showAddReminder = false;

  bool _todayClicked = false;
  bool _tomorrowClicked = false;
  bool _nextWeekClicked = false;

  int _stepNumber = 1;
  String _errorMsg = '';

  dynamic today = new DateTime.now();
  dynamic tomorrow = new DateTime.now().add(Duration(days: 1));
  dynamic nextWeek = new DateTime.now().add(Duration(days: 7));

  double _panelMaxHeight = 300;
  dynamic _date = new DateTime.now();
  dynamic _time = DateTime.now().add(Duration(hours: 1));

  TextEditingController titleController = TextEditingController();

  bool _reminderAdded = false;
  bool _isLoading = false;

  @override
  dispose() {
    titleController.dispose(); // you need this
    super.dispose();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: null);
  }

  // Future onSelectNotification(String payload) {
  //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
  //     return NewScreen(
  //       payload: payload,
  //     );
  //   }));
  // }

  Future<void> scheduleNotification() async {
    var date = DateFormat('yyyy-MM-dd').format(_date);
    var hour = DateFormat('H').format(_time);
    var min = DateFormat('m').format(_time);
    var scheduledNotificationDateTime = DateTime.parse(date)
        .add(Duration(hours: int.parse(hour), minutes: int.parse(min)))
        .subtract(Duration(minutes: 15))
        .toLocal();
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Reminder ⏰',
        titleController.text +
            ' At ' +
            DateFormat.jm().format(
                scheduledNotificationDateTime.add(Duration(minutes: 15))),
        scheduledNotificationDateTime,
        platform);
  }

  showNotification() async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Test Notification', 'Reminder ....', platform,
        payload: 'Welcome to the Local Notification demo');
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to discard this reminder?'),
          content: Container(
            height: 0,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    elevation: 0,
                    color: Color(0xFF00a3e0),
                    child: Text('Discard'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _showAddReminder = false;
                      });
                      this.widget.callback_AddReminderPanel(_showAddReminder);
                    },
                  ),
                ),
                RaisedButton(
                  elevation: 0,
                  color: Color(0xffdadada),
                  child: Text('Keep Editing'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void _handleNewReminder() async {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = {
        'user_id': int.parse(prefs.get('user_id')),
        'reminder_name': titleController.text,
        'reminder_date': _date.toString(),
        'reminder_time': _time.toString(),
      };

      var res = await CallApi().postData(data, 'api/reminder');
      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          _reminderAdded = true;
          _showAddReminder = false;
          _isLoading = false;
        });
        scheduleNotification();
        Navigator.of(context).push(RoutesHandler.route(Home.HomePage()));
      }
    }

    return new SlidingUpPanel(
      maxHeight: _panelMaxHeight,
      backdropEnabled: true,
      backdropOpacity: 0.25,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
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
          padding: EdgeInsets.only(left: 15, right: 20, top: 2, bottom: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xffdadada),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 1), // changes position of shadow
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
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        _showMyDialog();
                      } else {
                        setState(() {
                          _showAddReminder = false;
                        });
                        this.widget.callback_AddReminderPanel(_showAddReminder);
                      }
                    }),
              ),
              Container(
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _stepNumber == 1
                          ? Container()
                          : TextButton(
                              onPressed: () {
                                if (_stepNumber == 3 && _datePicker == true) {
                                  setState(() {
                                    _stepNumber--;
                                    _panelMaxHeight = 500;
                                  });
                                } else {
                                  setState(() {
                                    _stepNumber--;
                                    _panelMaxHeight = 300;
                                  });
                                }
                              },
                              child: Text(
                                'Back',
                                style: TextStyle(color: Color(0xFF00a3e0)),
                              )),
                      _stepNumber == 3
                          ? RaisedButton(
                              color: Color(0xFF00a3e0),
                              onPressed: () {
                                _isLoading ? null : _handleNewReminder();
                              },
                              child: _isLoading
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      child: new CircularProgressIndicator(
                                        backgroundColor: Color(0xFF02a1e2),
                                      ),
                                    )
                                  : Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            )
                          : RaisedButton(
                              color: Color(0xFF00a3e0),
                              onPressed: () {
                                if (_stepNumber != 3) {
                                  if (titleController.text.isEmpty) {
                                    setState(() {
                                      _errorMsg = 'Reminder name required';
                                    });
                                  } else if (_stepNumber == 2) {
                                    if (_datePicker == false) {
                                      if (_todayClicked == false &&
                                          _tomorrowClicked == false &&
                                          _nextWeekClicked == false) {
                                        setState(() {
                                          _errorMsg = 'Please pick date';
                                        });
                                      } else {
                                        setState(() {
                                          _errorMsg = '';
                                          _stepNumber++;
                                          _panelMaxHeight = 300;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        _errorMsg = '';
                                        _stepNumber++;
                                        _panelMaxHeight = 300;
                                      });
                                    }
                                  } else if (_stepNumber == 1 &&
                                      _datePicker == true) {
                                    setState(() {
                                      _stepNumber++;
                                      _panelMaxHeight = 500;
                                    });
                                  } else {
                                    setState(() {
                                      _errorMsg = '';
                                      _stepNumber++;
                                      _panelMaxHeight = 300;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  )),
            ],
          )),
      panel: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                _errorMsg,
                style: TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
            if (_stepNumber == 1)
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                alignment: Alignment.center,
                child: TextField(
                  autofocus: false,
                  controller: titleController,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    hintText: 'Reminder name',
                    contentPadding: EdgeInsets.zero,
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xffdadada)),
                  ),
                ),
              ),
            if (_stepNumber == 2 && _datePicker == false)
              Container(
                padding: EdgeInsets.only(left: 0, right: 0, bottom: 7, top: 0),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 22, right: 22, bottom: 0, top: 0),
                      decoration: BoxDecoration(
                        color: _todayClicked ? Color(0xffdadada) : Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xffdadada), width: 0.6),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _date = today;
                            _tomorrowClicked = false;
                            _todayClicked = true;
                            _nextWeekClicked = false;
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(Icons.today,
                                        color:
                                            Color(0xFF00a3e0).withOpacity(0.5)),
                                  ),
                                  Text(
                                    'Today',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      DateFormat('EEEE')
                                          .format(today)
                                          .toString(),
                                      style: TextStyle(color: Colors.black87)),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 22, right: 22, bottom: 0, top: 0),
                      decoration: BoxDecoration(
                        color:
                            _tomorrowClicked ? Color(0xffdadada) : Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xffdadada), width: 0.6),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _date = tomorrow;
                            _tomorrowClicked = true;
                            _todayClicked = false;
                            _nextWeekClicked = false;
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(Icons.date_range_outlined,
                                        color:
                                            Color(0xFF00a3e0).withOpacity(0.5)),
                                  ),
                                  Text(
                                    'Tomorrow',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      DateFormat('EEEE')
                                          .format(tomorrow)
                                          .toString(),
                                      style: TextStyle(color: Colors.black87)),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 22, right: 22, bottom: 0, top: 0),
                      decoration: BoxDecoration(
                        color:
                            _nextWeekClicked ? Color(0xffdadada) : Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xffdadada), width: 0.6),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _date = nextWeek;
                            _tomorrowClicked = false;
                            _todayClicked = false;
                            _nextWeekClicked = true;
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(Icons.next_week_outlined,
                                        color:
                                            Color(0xFF00a3e0).withOpacity(0.5)),
                                  ),
                                  Text(
                                    'Next week',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      DateFormat('MMMEd')
                                          .format(nextWeek)
                                          .toString(),
                                      style: TextStyle(color: Colors.black87)),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 22, right: 22, bottom: 0, top: 0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xffdadada), width: 0.6),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _datePicker = true;
                            _panelMaxHeight = 460;
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(Icons.today_outlined,
                                        color:
                                            Color(0xFF00a3e0).withOpacity(0.5)),
                                  ),
                                  Text(
                                    'Pick date',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(),
                                ],
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            if (_stepNumber == 2 && _datePicker == true)
              Container(
                child: Theme(
                    data: ThemeData.from(
                        colorScheme:
                            ColorScheme.light(primary: Color(0xFF00a3e0))),
                    child: CalendarDatePicker(
                      initialCalendarMode: DatePickerMode.day,
                      initialDate: _date,
                      firstDate: DateTime.now(),
                      // current year
                      lastDate: DateTime(getCurrentYear(), 12, 31),
                      // current year + 2
                      currentDate: DateTime.now(),
                      onDateChanged: (DateTime newDateTime) {
                        setState(() {
                          _date = newDateTime;
                        });
                      },
                    )),
              ),
            if (_stepNumber == 3)
              Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 22, right: 22, bottom: 0, top: 0),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Icon(Icons.access_time_outlined,
                              color: Color(0xFF00a3e0).withOpacity(0.5)),
                        ),
                        Text(
                          'Reminder Time:',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      height: 150,
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime:
                              DateTime(0, 0, 0, DateTime.now().hour, 5),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              _time = newDateTime;
                            });
                          },
                          use24hFormat: false,
                          minuteInterval: 5,
                        ),
                      ))
                ],
              )
          ],
        ),
      ),
    );
  }
}
