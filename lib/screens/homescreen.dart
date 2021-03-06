import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weathermodel.dart';
import '../models/forecastmodel.dart';
import '../widgets/weather.dart';
import '../widgets/weatherItem.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isloading = false;
  WeatherData weatherData;
  ForecastData forecastData;

  loadweather() async {
    setState(() {
      isloading = true;
    });
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
    } catch (e) {
      print(e);
    }
    if (position != null) {
      final lat = position.latitude;
      final lon = position.longitude;

      final weatherResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=${lat.toString()}&lon=${lon.toString()}&appid=522dd941e334c2179d8ef4c2299ef23f&units=metric');
      final forecastResponse = await http.get(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${lat.toString()}&lon=${lon.toString()}&appid=522dd941e334c2179d8ef4c2299ef23f&units=metric');
      if (weatherResponse.statusCode == 200 &&
          forecastResponse.statusCode == 200) {
        return setState(() {
          weatherData =
              new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          forecastData =
              new ForecastData.fromJson(jsonDecode(forecastResponse.body));
          isloading = false;
        });
      }
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadweather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Location Weather'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: weatherData != null
                        ? Weather(
                            weather: weatherData,
                          )
                        : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isloading
                        ? CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                new AlwaysStoppedAnimation(Colors.white),
                          )
                        : IconButton(
                            icon: new Icon(Icons.refresh),
                            tooltip: 'Refresh',
                            onPressed:loadweather,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 200,
                    child: forecastData != null
                        ? ListView.builder(
                            itemCount: forecastData.list.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => WeatherItem(
                              weather: forecastData.list.elementAt(index),
                            ),
                          )
                        : Container()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
