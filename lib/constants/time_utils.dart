import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_connection/constants/colors.dart';

class TimeUtils {
  static Future<DateTime?> pickDate(BuildContext context) =>
      showDatePicker(
        context: context,
        initialDate: DateTime.now(), // Replace with your initial date
        firstDate: DateTime(2000), // Replace with your first selectable date
        lastDate: DateTime(2100), // Replace with your last selectable date
      );

  static Future<TimeOfDay?> pickTime(BuildContext context) {
    final currentTime = DateTime.now();
    final initialTime = TimeOfDay(hour: currentTime.hour, minute: currentTime.minute);
    return showTimePicker(
        context: context, initialTime: initialTime);
  }
  static DateTime parseDateString(String dateString) {
    DateTime parsedDate = DateTime.parse(dateString);
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  }
  static DateTime getStartOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime getEndOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }
  static DateTime getStartOfTomorrow() {
    DateTime now = DateTime.now();
    DateTime startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
    return startOfTomorrow;
  }

  static DateTime getEndOfTomorrow() {
    DateTime now = DateTime.now();
    DateTime startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
    DateTime endOfTomorrow = DateTime(startOfTomorrow.year, startOfTomorrow.month, startOfTomorrow.day, 23, 59, 59, 999);
    return endOfTomorrow;
  }
}
