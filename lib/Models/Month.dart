import 'package:aramco_calendar/Models/Week.dart' as Week;
class Month{
  String name;
  dynamic first_H;
  dynamic second_H;
  int number;
  String firstHijryYear;
  String secondHijryYear;

  List<Week.Week> weeks;

  Month(name, number, first_H, second_H, weeks , firstHijryYear , secondHijryYear) {
    this.name = name;
    this.number = number;
    this.first_H = first_H;
    this.second_H = second_H;
    this.weeks = weeks;
    this.firstHijryYear = firstHijryYear;
    this.secondHijryYear = secondHijryYear;
  }
}