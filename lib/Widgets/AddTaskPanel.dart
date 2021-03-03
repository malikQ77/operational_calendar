import 'dart:convert';

import 'package:aramco_calendar/Api/DatesApi.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

import 'package:aramco_calendar/Widgets/home.dart' as Home;
import 'package:aramco_calendar/Routes/routesHandler.dart' as RoutesHandler;


class AddTaskPanel extends StatefulWidget {
  Function callback_AddTaskPanel;

  AddTaskPanel(this.callback_AddTaskPanel);

  @override
  _AddTaskPanelState createState() => new _AddTaskPanelState();
}

class _AddTaskPanelState extends State<AddTaskPanel>
    with SingleTickerProviderStateMixin {
  bool _isPanelOpen = true; // need it ??
  bool _datePicker = false;
  bool _showAddTask = false;

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
  dynamic _color = Colors.lightGreenAccent;

  TextEditingController titleController = TextEditingController();

  bool _taskAdded = false;
  bool _isLoading = false;



  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to discard this task?'),
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
                        _showAddTask = false;
                      });
                      this.widget.callback_AddTaskPanel(_showAddTask);
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

    void _handleNewTask() async {
      setState(() {
        _isLoading = true;
      });

      var data = {
        'user_id': 1,
        'task_name': titleController.text,
        'task_color': _color.value,
        'task_date': _date.toString(),
        'task_time': _time.toString(),
      };

      var res = await CallApi().postData(data, 'api/task');
      var body = json.decode(res.body);
      if (body['success']) {
        setState(() {
          _taskAdded = true;
          _showAddTask = false;
          _isLoading = false;
        });
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
                          _showAddTask = false;
                        });
                        this.widget.callback_AddTaskPanel(_showAddTask);
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
                      _stepNumber == 3 ? RaisedButton(
                        color: Color(0xFF00a3e0),
                        onPressed: () {
                          _isLoading ? null : _handleNewTask();
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
                      ): RaisedButton(
                        color: Color(0xFF00a3e0),
                        onPressed: () {
                          if (_stepNumber != 3) {
                            if (titleController.text.isEmpty) {
                              setState(() {
                                _errorMsg = 'Task name required';
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
            Text(
              _errorMsg,
              style: TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
            if (_stepNumber == 1)
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                    hintText: 'Task name',
                    contentPadding: EdgeInsets.zero,
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xffdadada)),
                  ),
                ),
              ),
            if (_stepNumber == 1)
              Container(
                margin: EdgeInsets.only(top: 5),
                padding:
                    EdgeInsets.only(left: 22, right: 22, bottom: 15, top: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: MaterialColorPicker(
                          onMainColorChange: (color) {
                            setState(() {
                              _color = color;
                            });
                          },
                          selectedColor: _color,
                          allowShades: false,
                          circleSize: 30,
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
                            Colors.purple,
                            Colors.lightGreenAccent,
                            Colors.grey,
                            Colors.green,
                            Colors.blue
                          ],
                        ))
                  ],
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
                      lastDate: DateTime(getCurrentYear(), 12, 31),
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
                          'Task Time:',
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
                          initialDateTime: _time,
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              _time = newDateTime;
                            });
                          },
                          use24hFormat: false,
                          minuteInterval: 1,
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
