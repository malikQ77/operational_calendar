//
// class Day {
//   int date;
//   int H_date;
//   String dayName;
//   dynamic full_dateHijri;
//   bool isNationalDay;
//   bool isHoliday;
//   bool isDayoff;
//   bool dayColor;
//
//   Day(date, H_date ,dayName , full_dateHijri , isNationalDay , isHoliday, isDayoff , dayColor) {
//     this.date = date;
//     this.H_date = H_date;
//     this.dayName = dayName;
//     this.full_dateHijri = full_dateHijri;
//     this.isNationalDay = isNationalDay;
//     this.isHoliday = isHoliday;
//     this.isDayoff = isDayoff;
//     this.dayColor = dayColor;
//   }
// }





// for(int rem = 0; rem < bodyReminders.length; rem++){
//           var xdxd = DateTime.parse(bodyReminders[rem]['reminder_date']);
//           if(tempDate.toString() == DateFormat('yyyy-MM-dd').format(xdxd)){
//             weekDays.add(new DayModel.Day(
//                 date[z],
//                 date_H[z].hDay,
//                 date_H[z].dayWeName,
//                 date_H[z],
//                 false,
//                 false,
//                 true,
//                 dayColor));
//             tempDates.add(DateFormat('yyyy-MM-dd').format(xdxd));
//           }
//         }
//
//
//         /*
//               Same for loop
//               => add color to day { National date , Holiday , DayOff }
//               => list of reminders
//               => list of events
//               => list of tasks
//          */
//
//
//         for (int i = 1; i <= monthsLength; i++) {
//           var date = listOfMonthDate(currentYear, i);
//           var date_H = listOfHijriDatesOfMonth(currentYear, i);
//           var weeks = eachDayWeekNumber(currentYear, i);
//           List<int> WeekNumbers = weeks.toSet().toList();
//           var first_H_month = getFirstHijriNameOfMonth(currentYear, i);
//           var second_H_month = getLastHijriNameOfMonth(currentYear, i);
//
//           List<WeekModel.Week> monthWeeks = [];
//           for (int j = 0; j < WeekNumbers.length; j++) {
//             List<DayModel.Day> weekDays = [];
//             for (int z = 0; z < date_H.length; z++) {
//               if (weeks[z] == WeekNumbers[j]) {
//                 if (date_H[z].hDay == 1) {
//                   dayColor = !dayColor;
//                 }
//                 List<dynamic> tempDates = [];
//                 var tempDate = new DateFormat('yyyy-MM-dd')
//                     .format(new DateTime(currentYear, i, date[z]));
//                 for (int kj = 0; kj < body.length; kj++) {
//                   if (tempDate.toString() == body[kj]['date'].toString()) {
//                     if (body[kj]['type'] == 'Holidays') {
//                       weekDays.add(new DayModel.Day(
//                           date[z],
//                           date_H[z].hDay,
//                           date_H[z].dayWeName,
//                           date_H[z],
//                           false,
//                           true,
//                           false,
//                           dayColor));
//                       tempDates.add(body[kj]['date']);
//                     } else if (body[kj]['type'] == 'Rescheduled days off') {
//                       weekDays.add(new DayModel.Day(
//                           date[z],
//                           date_H[z].hDay,
//                           date_H[z].dayWeName,
//                           date_H[z],
//                           false,
//                           false,
//                           true,
//                           dayColor));
//                       tempDates.add(body[kj]['date']);
//                     }
//                   }
//                 }
//                 if (i == 9 && z == 22) {
//                   weekDays.add(new DayModel.Day(
//                       date[z],
//                       date_H[z].hDay,
//                       date_H[z].dayWeName,
//                       date_H[z],
//                       true,
//                       false,
//                       false,
//                       dayColor));
//                 } else {
//                   var tempDate = new DateFormat('yyyy-MM-dd')
//                       .format(new DateTime(currentYear, i, date[z]));
//                   if (!tempDates.contains(tempDate)) {
//                     weekDays.add(new DayModel.Day(
//                         date[z],
//                         date_H[z].hDay,
//                         date_H[z].dayWeName,
//                         date_H[z],
//                         false,
//                         false,
//                         false,
//                         dayColor));
//                   }
//                 }
//               }
//             }
//             if (weekDays[0].dayName == 'Monday' && weekDays.length < 7) {
//               for (int r = 0; r < 1; r++) {
//                 if (weekDays.length != 7) {
//                   weekDays.insert(
//                       0,
//                       new DayModel.Day(
//                           null, null, null, null, false, false, false, null));
//                 }
//               }
//             } else if (weekDays[0].dayName == 'Tuesday' &&
//                 weekDays.length < 7) {
//               for (int r = 0; r < 2; r++) {
//                 if (weekDays.length != 7) {
//                   weekDays.insert(
//                       0,
//                       new DayModel.Day(
//                           null, null, null, null, false, false, false, null));
//                 }
//               }
//             } else if (weekDays[0].dayName == 'Wednesday' &&
//                 weekDays.length < 7) {
//               for (int r = 0; r < 3; r++) {
//                 if (weekDays.length != 7) {
//                   weekDays.insert(
//                       0,
//                       new DayModel.Day(
//                           null, null, null, null, false, false, false, null));
//                 }
//               }
//             } else if (weekDays[0].dayName == 'Thursday' &&
//                 weekDays.length < 7) {
//               for (int r = 0; r < 4; r++) {
//                 if (weekDays.length != 7) {
//                   weekDays.insert(
//                       0,
//                       new DayModel.Day(
//                           null, null, null, null, false, false, false, null));
//                 }
//               }
//             } else if (weekDays[0].dayName == 'Friday' && weekDays.length < 7) {
//               for (int r = 0; r < 5; r++) {
//                 if (weekDays.length != 7) {
//                   weekDays.insert(
//                       0,
//                       new DayModel.Day(
//                           null, null, null, null, false, false, false, null));
//                 }
//               }
//             } else if (weekDays[0].dayName == 'Saturday' &&
//                 weekDays.length < 7) {
//               for (int r = 0; r < 6; r++) {
//                 if (weekDays.length != 7) {
//                   weekDays.insert(
//                       0,
//                       new DayModel.Day(
//                           null, null, null, null, false, false, false, null));
//                 }
//               }
//             } else if (weekDays.length < 7) {
//               for (int r = 0; r < 6; r++) {
//                 if (weekDays.length != 7) {
//                   weekDays.insert(
//                       weekDays.length,
//                       new DayModel.Day(
//                           null, null, null, null, false, false, false, null));
//                 }
//               }
//             }
//             monthWeeks.add(new WeekModel.Week(WeekNumbers[j], weekDays));
//           }
//
//           year.add(new MonthModel.Month(monthNames[i - 1], i, first_H_month,
//               second_H_month, monthWeeks, firstHijryYear, secondHijryYear));
//         }

import 'package:aramco_calendar/Models/Task.dart' as Task;
import 'package:aramco_calendar/Models/Event.dart' as Event;
import 'package:aramco_calendar/Models/Reminder.dart' as Reminder;

class Day {

  int date;
  int H_date;
  String type;
  String dayName;
  dynamic full_dateHijri;
  int bgColor;
  int txColor;
  List<Task.Task> tasks;
  List<Event.Event> events;
  List<Reminder.Reminder> reminders;

  Day(date, H_date ,type,dayName , full_dateHijri , bgColor , txColor, tasks , events , reminders) {
    this.date = date;
    this.H_date = H_date;
    this.type = type;
    this.dayName = dayName;
    this.full_dateHijri = full_dateHijri;
    this.bgColor = bgColor;
    this.txColor = txColor;
    this.tasks = tasks;
    this.events = events;
    this.reminders = reminders;
  }

}