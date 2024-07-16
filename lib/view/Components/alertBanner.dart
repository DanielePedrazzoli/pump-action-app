import 'package:action_pump_wether/Controller/weatherController.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:flutter/material.dart';

class AlertBanner extends StatelessWidget {
  const AlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherController weatherController = locator<WeatherController>();

    return Visibility(
      visible: weatherController.isAlertPreset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: const Color.fromARGB(255, 46, 139, 151),
            margin: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const Icon(Icons.info, size: 30, color: Color.fromARGB(255, 255, 255, 255)),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      "Possibilità di mancata erogazione\npioggia in arrivo per le ore${weatherController.alertData?.start.hour.toString() ?? ""}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
