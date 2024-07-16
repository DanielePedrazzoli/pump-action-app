import 'package:action_pump_wether/Controller/time_formatter.dart';
import 'package:action_pump_wether/Model/DeviceData.dart';
import 'package:flutter/material.dart';

class ErogationInfo extends StatelessWidget {
  final DeviceData data;
  const ErogationInfo({super.key, required this.data});

  int calcuateNextErogation() {
    var now = DateTime.now();
    var nowInSeconds = now.hour * 3600 + now.minute * 60 + now.second;

    var difference = data.erogationData.erogationTime - nowInSeconds;

    if (difference < 0) {
      return difference + 24 * 3600;
    }
    return difference;
  }

  @override
  Widget build(BuildContext context) {
    if (!data.isPumpActive) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Prossima erogazione tra"),
          Text(TimeFormatter.writeDurationHM(calcuateNextErogation(), "adesso")),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Durata rimante erogazione"),
        Text(TimeFormatter.writeDurationMS(data.erogationData.remainingTime, "terminato")),
      ],
    );
  }
}
