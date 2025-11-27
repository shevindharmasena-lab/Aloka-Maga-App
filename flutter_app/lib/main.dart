import 'package:flutter/material.dart';
import 'daily_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // if using Firebase
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: dailyScreen(),
  ));
}
