import 'package:aramco_calendar/Models/Day.dart' as Day;
class Week {
  int number;
  List<Day.Day> days;

  Week(number, days) {
    this.number = number;
    this.days = days;
  }

}