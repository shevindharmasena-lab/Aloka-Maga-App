import 'package:flutter/material.dart';
import 'flutter_app/lib/screens/home_screen_A.dart';
import 'flutter_app/lib/screens/home_screen_B.dart';
import 'flutter_app/lib/screens/home_screen_C.dart';
import 'flutter_app/lib/screens/home_screen_D.dart';

int _todayIndex() {
  final days = DateTime.now().toUtc().difference(DateTime.utc(1970)).inDays;
  return days % 4;
}

Widget dailyScreen() {
  final idx = _todayIndex();
  switch (idx) {
    case 0: return HomeScreenA();
    case 1: return HomeScreenB();
    case 2: return HomeScreenC();
    default: return HomeScreenD();
  }
}
