import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './screens/splashscreen.dart';
import './theme/theme.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: lighttheme(),
        darkTheme: darktheme(),
        themeMode: ThemeMode.system,
        home: Splashscreen());
  }
}
