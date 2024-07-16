import 'package:action_pump_wether/Controller/weatherController.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:action_pump_wether/view/Components/weatherPredictionCard.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Predictionvisualizer extends StatelessWidget {
  const Predictionvisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherController weatherController = locator<WeatherController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Skeleton.replace(
        replacement: const Card(
          child: SizedBox(
            height: 175,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 175,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return WeatherPredictionCard(data: weatherController.prediction[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              itemCount: weatherController.prediction.length,
            ),
          ),
        ),
      ),
    );
  }
}
