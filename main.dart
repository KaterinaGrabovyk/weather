import 'package:flutter/material.dart';
//importing weather page
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

// Main
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const WeatherScreen(),
    );
  }
}
