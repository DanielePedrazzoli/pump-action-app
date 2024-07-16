import 'package:action_pump_wether/Model/WeatherPrediction.dart';
import 'package:action_pump_wether/view/Components/WatherImage.dart';
import 'package:flutter/material.dart';

class WeatherPredictionCard extends StatelessWidget {
  final WeatherData data;
  const WeatherPredictionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "${data.date.hour.toString().padLeft(2, "0")}:${data.date.minute.toString().padLeft(2, "0")}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Watherimage(data: data, height: 25),
          Text(
            "${data.temperature}°",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
