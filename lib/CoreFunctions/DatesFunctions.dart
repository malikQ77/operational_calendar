import 'package:hijri/hijri_calendar.dart';
import 'package:week_of_year/week_of_year.dart';

int daysInMonth(DateTime date) {
  var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

List<String> monthsName() {
  return [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
}

int getCurrentYear() {
  return new DateTime.now().year;
}

dynamic getFirstDayOfYear(currentYear) {
  return new DateTime(currentYear, 1, 1);
}

dynamic getLastDayOfYear(currentYear) {
  return new DateTime(currentYear, 12, 15);
}

dynamic getFirstHijryYear(firstDayOfYear) {
  return new HijriCalendar.fromDate(firstDayOfYear).hYear;
}

dynamic getSecondHijryYear(lastDayOfYear) {
  return new HijriCalendar.fromDate(lastDayOfYear).hYear;
}

List<int> listOfMonthDate(currentYear, monthNumber) {
  var monthDays = DateTime(currentYear, monthNumber);
  var totalDays = daysInMonth(monthDays);
  var listOfDates =
  new List<int>.generate(totalDays, (monthNumber) => monthNumber + 1);
  return listOfDates;
}

dynamic firstHijriDayOfMonth(currentYear, month, day) {
  return new HijriCalendar.fromDate(new DateTime(currentYear, month, day));
}

dynamic lastHijriDayOfMonth(currentYear, month, day) {
  return new HijriCalendar.fromDate(new DateTime(currentYear, month, day));
}

List<dynamic> listOfHijriDatesOfMonth(currentYear, month) {
  List<dynamic> daysListH = [];
  List<int> month_days = listOfMonthDate(currentYear, month);
  for (int j = 0; j < month_days.length; j++) {
    var day = new DateTime(currentYear, month, month_days[j]);
    var hDate = new HijriCalendar.fromDate(day);
    daysListH.add(hDate);
  }
  return daysListH;
}

List<int> eachDayWeekNumber(currentYear, month) {
  List<int> eachDayWeek = [];
  List<int> month_days = listOfMonthDate(currentYear, month);
  for (int j = 0; j < month_days.length; j++) {
    var forWeek = new DateTime(currentYear + 1, month, month_days[j]);
    var week = forWeek.weekOfYear;
    week = week + 1;
    if (week == 53) {
      week = 1;
    }
    eachDayWeek.add(week);
  }
  return eachDayWeek;
}

List<int> eachMonthWeeksNumber(currentYear, month) {
  List<int> WeekNumbers = eachDayWeekNumber(currentYear, month);
  var nums;
  nums = WeekNumbers.toSet().toList();
  return nums;
}

dynamic getFirstHijriNameOfMonth(currentYear, month) {
  List<int> month_days = listOfMonthDate(currentYear, month);
  return new HijriCalendar.fromDate(
      new DateTime(currentYear, month, month_days[0]));
}

dynamic getLastHijriNameOfMonth(currentYear, month) {
  List<int> month_days = listOfMonthDate(currentYear, month);
  return new HijriCalendar.fromDate(
      new DateTime(currentYear, month, month_days[month_days.length - 1]));
}
