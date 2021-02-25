
class Day {
  int date;
  int H_date;
  String dayName;
  dynamic full_dateHijri;
  bool isNationalDay;
  bool isHoliday;
  bool isDayoff;
  bool dayColor;

  Day(date, H_date ,dayName , full_dateHijri , isNationalDay , isHoliday, isDayoff , dayColor) {
    this.date = date;
    this.H_date = H_date;
    this.dayName = dayName;
    this.full_dateHijri = full_dateHijri;
    this.isNationalDay = isNationalDay;
    this.isHoliday = isHoliday;
    this.isDayoff = isDayoff;
    this.dayColor = dayColor;
  }
}