// ignore_for_file: must_be_immutable

import 'package:action_pump_wether/Controller/BluetoothController.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:action_pump_wether/view/Components/Erogation/erogation_info.dart';
import 'package:action_pump_wether/view/pages/erogation_parameter_page.dart';
import 'package:action_pump_wether/view/pages/WifiConnection.dart';
import 'package:flutter/material.dart';

class ErogationSection extends StatelessWidget {
  ErogationSection({super.key});
  BluetoothController bluetoothController = locator<BluetoothController>();

  Widget _buildCommandButton(bool isDisabled) {
    if (bluetoothController.deviceData.isPumpActive) {
      return FilledButton.icon(
        style: IconButton.styleFrom(backgroundColor: const Color.fromARGB(255, 221, 59, 47)),
        onPressed: isDisabled ? null : () => bluetoothController.setErogationActive(false),
        icon: const Icon(Icons.stop, size: 20),
        label: const Text("Ferma"),
      );
    }

    return FilledButton.icon(
      style: IconButton.styleFrom(backgroundColor: const Color.fromARGB(255, 56, 154, 60)),
      onPressed: isDisabled ? null : () => bluetoothController.setErogationActive(true),
      icon: const Icon(Icons.play_arrow, size: 20),
      label: const Text("Inizia"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!bluetoothController.connected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Comando dispositvo", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bluetooth_searching, size: 45, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 16),
                      Text("Ricerca dispositivo in corso", style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (!bluetoothController.deviceData.isConnectedWifi) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Comando dispositvo", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.wifi_find_sharp, size: 50, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  const Text("Il dispositivo è connesso alla applicazione ma necessita di una connessione ad internet per funzionare"),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog.fullscreen(
                            child: WifiConnection(),
                          );
                        },
                      );
                    },
                    child: const Text("Collega ad una rete wifi"),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Comando dispositvo", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stato attuale"),
                    Text("Connesso"),
                  ],
                ),
                const SizedBox(height: 8),
                ErogationInfo(data: locator<BluetoothController>().deviceData),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCommandButton(false),
                    FilledButton.icon(
                      style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ErogationParameterPage())),
                      icon: const Icon(Icons.settings, size: 20),
                      label: const Text("Parametri"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
