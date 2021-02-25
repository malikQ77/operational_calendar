import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:aramco_calendar/Models/Month.dart' ;
import 'package:aramco_calendar/Widgets/MonthTitle.dart' as MonthTitle;
import 'package:aramco_calendar/Widgets/WeekNumbers.dart' as WeeksNumbersWidget;
import 'package:aramco_calendar/Widgets/Day.dart' as DayWidget;
import 'package:aramco_calendar/Widgets/WeekDaysName.dart' as DaysNames;
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
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
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
                child: new DaysNames.MonthDaysNameWidget(),),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children:[
                                    for(int i = 0; i < week.days.length; i++)
                                      new Container(
                                        child: new DayWidget.DayWidget(week.days[i]),
                                        width: 40,
                                        height: 35,
                                        margin: EdgeInsets.only(right: 0),
                                      ),
                                  ],
                                ),
                              )
                          )
                          )
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
