import 'package:action_pump_wether/Model/WifiNetwkor.dart';
import 'package:flutter/material.dart';

class Wificard extends StatelessWidget {
  final Wifinetwkork network;
  final Function(Wifinetwkork) onTap;

  const Wificard({super.key, required this.network, required this.onTap});

  Widget _getIconFromPowerLevel() {
    switch (network.powerLevel) {
      case ConnectionPowerLevel.veryWeak:
        return const Icon(Icons.wifi_1_bar, color: Colors.red);
      case ConnectionPowerLevel.weak:
        return const Icon(Icons.wifi_2_bar, color: Color.fromARGB(255, 244, 127, 54));
      case ConnectionPowerLevel.medium:
        return const Icon(Icons.wifi_2_bar, color: Color.fromARGB(255, 233, 174, 24));
      case ConnectionPowerLevel.strong:
        return const Icon(Icons.wifi, color: Color.fromARGB(255, 13, 146, 38));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        dense: true,
        // contentPadding: EdgeInsets.all(4),
        minVerticalPadding: 0,
        onTap: () => onTap(network),
        title: Text(network.name, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text("Potenza: ${network.power} db", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.grey)),
        trailing: _getIconFromPowerLevel(),
      ),
    );
  }
}
// 58 11 32 47 99 18 38 64 64 55 71

