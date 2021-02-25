import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthWeeksNumbersWidget extends StatefulWidget {
  final List<int> weeksNumbers;

  MonthWeeksNumbersWidget(this.weeksNumbers);

  @override
  _MonthWeeksNumbersWidgetState createState() =>
      _MonthWeeksNumbersWidgetState();
}

class _MonthWeeksNumbersWidgetState extends State<MonthWeeksNumbersWidget> {
  @override
  Widget build(BuildContext context) {
    List<int> WeekNumbers = widget.weeksNumbers;
    List<int> numbers = WeekNumbers.toSet().toList();
    return Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < numbers.length; i++)
                  new Container(
                    alignment: Alignment.center,
                    height:35,
                    child: Text(
                      numbers[i].toString(),
                      style: TextStyle(fontSize: 11,
                          color: const Color(0xff5b5a5f)),
                    ),
                  )
              ],
            )));
  }
}
