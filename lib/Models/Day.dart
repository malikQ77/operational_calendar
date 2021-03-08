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