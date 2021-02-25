import 'package:flutter/material.dart';
import 'package:aramco_calendar/CoreFunctions/DatesFunctions.dart' as DatesFunctions;
import 'package:aramco_calendar/Models/Day.dart' as Day;
import 'package:aramco_calendar/Models/Week.dart' as Week;
import 'package:aramco_calendar/Models/Month.dart' as Month;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:intl/intl.dart';


// connect to api file here
// months List generated here

List<dynamic> _datesList = [];
List<Month.Month> _months = [];
final _getData = AsyncMemoizer();


Widget build(context){

}