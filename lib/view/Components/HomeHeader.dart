import 'package:action_pump_wether/Controller/weatherController.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:action_pump_wether/view/Components/WatherImage.dart';
import 'package:flutter/material.dart';

class Homeheader extends StatelessWidget {
  const Homeheader({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherController weatherController = locator<WeatherController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                weatherController.currentWeather?.temperatureString ?? "",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 50),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Center(
                  child: Watherimage(
                    data: weatherController.currentWeather,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            weatherController.currentWeather?.weatherTypeString ?? "",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
