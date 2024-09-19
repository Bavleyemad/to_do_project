// lib/App_date_utilts.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Extension for DateTime to format and handle dates
extension DateTimeUtilits on DateTime {
  int dateOnly() {
    var newDateTime = DateTime(year, month, day,);
    return newDateTime.microsecondsSinceEpoch;
  }

  String formatDate() {
    final DateFormat formatter = DateFormat('EEE dd/MMM/yyyy');
    return formatter.format(this);
  }
}

// Extension for TimeOfDay to handle and format times
extension TimeUtilits on TimeOfDay {
  int timeSinceEpoch() {
    var newDateTime = DateTime(0, 0, 0, hour, minute);
    return newDateTime.microsecondsSinceEpoch;
  }

  String formatTime() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(DateTime(0, 0, 0, hour, minute));
  }
}

extension TimeFormat on int {
  String formatTime() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(DateTime.fromMicrosecondsSinceEpoch(this));
  }

  String formatDate() {
    final DateFormat formatter = DateFormat('EEE dd/MMM/yyyy');
    return formatter.format(DateTime.fromMicrosecondsSinceEpoch(this));
  }
}
