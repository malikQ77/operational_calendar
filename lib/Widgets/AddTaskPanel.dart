import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
class AddTaskPanel extends StatefulWidget {

  Function callback_AddTaskPanel;

  AddTaskPanel(callback_AddTaskPanel);

  @override
  _AddTaskPanelState createState() => new _AddTaskPanelState();
}
class _AddTaskPanelState extends State<AddTaskPanel>  with SingleTickerProviderStateMixin {

  bool _isPanelOpen = true;
  bool _datePicker = false;
  bool _timePicker = false;
  bool _colorPicker = false;
  bool _showAddTask = false;

  dynamic _date = new DateTime.now();
  dynamic _time =
  DateFormat.jm().format(new DateTime.now().add(Duration(minutes: 30)));
  dynamic _color = Colors.lightGreenAccent;

  @override
  Widget build(BuildContext context) {
    return new SlidingUpPanel(
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
                      this.widget.callback_AddTaskPanel(_showAddTask);
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
    );
  }
}