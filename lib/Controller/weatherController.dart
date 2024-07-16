import 'dart:async';
import 'dart:convert';

import 'package:action_pump_wether/Model/AlertData.dart';
import 'package:action_pump_wether/Model/WeatherPrediction.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherController extends ChangeNotifier {
  List<WeatherData> prediction = [];
  bool ready = false;
  WeatherData? currentWeather;

  Timer? _autoUpdateTimer;
  bool get autoUpdateEnabled => _autoUpdateTimer != null;

  AlertData? alertData;

  bool get isAlertPreset => alertData != null;

  WeatherController();

  init() async {
    enableAutoUpdate();
    getData();
  }

  getData() async {
    String url =
        "https://api.open-meteo.com/v1/forecast?latitude=44.8396&longitude=10.7543&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m,wind_direction_10m&hourly=temperature_2m,relative_humidity_2m,precipitation_probability,precipitation,weather_code,wind_speed_80m,wind_direction_80m,temperature_80m&timezone=auto&forecast_days=2";
    var resposne = await http.get(
      Uri.parse(url),
    );

    var json = jsonDecode(resposne.body);

    currentWeather = WeatherData(
      temperature: json["current"]["temperature_2m"],
      weatherCode: json["current"]["weather_code"],
    );

    var now = DateTime.now();
    prediction.clear();

    var currentIndex = now.hour + DateTime.now().timeZoneOffset.inHours;

    for (int i = currentIndex - 1; i < currentIndex + 24; i++) {
      prediction.add(WeatherData(
        hour: DateTime.parse(json["hourly"]["time"][i].toString()),
        temperature: json["hourly"]["temperature_2m"][i],
        weatherCode: json["hourly"]["weather_code"][i],
        rainProbability: json["hourly"]["precipitation_probability"][i],
      ));
    }

    ready = true;
    notifyListeners();
  }

  void enableAutoUpdate() {
    _autoUpdateTimer = Timer.periodic(const Duration(minutes: 5), (_) => getData());
  }

  @override
  void dispose() {
    super.dispose();
    _autoUpdateTimer?.cancel();
    _autoUpdateTimer = null;
  }
}
