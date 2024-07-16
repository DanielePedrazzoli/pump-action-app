import 'package:action_pump_wether/Model/WeatherPrediction.dart';

class AlertData {
  DateTime start;
  DateTime? end;
  int probability;

  Weather weather;

  AlertData({required this.start, this.end, this.probability = 0, required this.weather});
}
