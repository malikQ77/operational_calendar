import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthTitleWidget extends StatefulWidget {
  final String monthName;
  final int monthNumber;
  final dynamic first_H_month;
  final dynamic Last_H_month;
  final String first_H_monthNumber;
  final String Last_H_monthNumber;
  final String  firstHijryYear;
  final String  secondHijryYear;
  final bool color;


  MonthTitleWidget(this.monthName, this.first_H_month, this.Last_H_month,
      this.first_H_monthNumber, this.Last_H_monthNumber, this.firstHijryYear, this.secondHijryYear, this.monthNumber, this.color);

  @override
  _MonthTitleWidgetState createState() => _MonthTitleWidgetState();
}

class _MonthTitleWidgetState extends State<MonthTitleWidget> {

  @override
  Widget build(BuildContext context) {
    var first_H_year = '';
    var second_H_year = '';
    if(widget.monthNumber == 1){
      first_H_year = widget.firstHijryYear + ' ';
    }
    if(widget.Last_H_month == 'Muharram'){
      second_H_year = widget.secondHijryYear + ' ';
    }
    var monthTitle;
    if(widget.color == true){
      monthTitle = new Wrap(
        children: [
          Container(
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                  alignment: Alignment.topLeft,
                  margin:
                  EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 0),
                  child: Text(
                    widget.monthName,
                    style: TextStyle(
                        fontFamily: 'Aramco',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff5b5a5f)),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 0),
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          first_H_year +
                              widget.first_H_month +
                              ' (' +
                              widget.first_H_monthNumber
                                  .toString()
                                  .padLeft(2, '0') +
                              ')',
                          style: TextStyle(
                            color: const Color(0xFF02a1e2),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                            second_H_year +
                                widget.Last_H_month +
                                ' (' +
                                widget.Last_H_monthNumber.toString()
                                    .padLeft(2, '0') +
                                ')',
                            style: TextStyle(
                              color: const Color(0xFF84bd00),
                            )),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      );
    }else{
      monthTitle = new Wrap(
        children: [
          Container(
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                  alignment: Alignment.topLeft,
                  margin:
                  EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 0),
                  child: Text(
                    widget.monthName,
                    style: TextStyle(
                        fontFamily: 'Aramco',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff5b5a5f)),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 0),
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          first_H_year +
                              widget.first_H_month +
                              ' (' +
                              widget.first_H_monthNumber
                                  .toString()
                                  .padLeft(2, '0') +
                              ')',
                          style: TextStyle(
                            color: const Color(0xFF84bd00),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                            second_H_year +
                                widget.Last_H_month +
                                ' (' +
                                widget.Last_H_monthNumber.toString()
                                    .padLeft(2, '0') +
                                ')',
                            style: TextStyle(
                              color: const Color(0xFF02a1e2),
                            )),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: monthTitle,
    );
  }
}
