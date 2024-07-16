import 'package:action_pump_wether/Controller/BluetoothController.dart';
import 'package:action_pump_wether/Model/WifiNetwkor.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:action_pump_wether/view/Components/wifiCard.dart';
import 'package:flutter/material.dart';

class WifiConnection extends StatefulWidget {
  const WifiConnection({super.key});

  @override
  State<WifiConnection> createState() => _WifiConnectionState();
}

class _WifiConnectionState extends State<WifiConnection> {
  final TextEditingController _passwordController = TextEditingController();
  BluetoothController bleController = locator<BluetoothController>();

  Widget _buildList() {
    if (bleController.deviceData.isConnecting) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 42),
          Text("Connessione alla rete wifi in corso"),
        ],
      );
    }

    var networkFound = bleController.deviceData.availableNetworks;
    if (networkFound.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 42),
          Text("Il dispositivo sta eseguendo la scansione"),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: networkFound.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(),
      itemBuilder: (context, index) => Wificard(network: networkFound[index], onTap: askPassword),
    );
  }

  void askPassword(Wifinetwkork network) async {
    _passwordController.clear();
    var needCheck = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Inserire la password per la rete wifi ${network.name}", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 32),
                TextField(
                  controller: _passwordController,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text("Annulla")),
                    const SizedBox(width: 8),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text("Conferma")),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );

    if (!needCheck) return;
    2 == 2;

    await bleController.sendWifiCredential(network.name, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connessione Wifi")),
      body: ListenableBuilder(
        listenable: bleController,
        builder: (context, child) {
          if (locator<BluetoothController>().deviceData.isConnectedWifi == false) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Text("Seleziona la rete wifi alla quale connettere la macchina", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text(
                    "La connessione wifi permette al dispositivo di prendere le informazioni meteo da internet e regolare l’erogazione in automatico",
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildList(),
                  ),
                  Visibility(
                    visible: locator<BluetoothController>().deviceData.isConnectedWifi,
                    child: Row(
                      children: [
                        Text("Connesso: ${bleController.deviceData.wifiNetworkIP ?? "not avaiable ip"}"),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_rounded, size: 100, color: Colors.green),
                const SizedBox(height: 48),
                Text(
                  "Il disposito è connesso alla rete Wifi selezionata",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 8),
                // Text(
                //   "Indirizzo IP: ${bleController.deviceData.wifiNetworkIP ?? "not avaiable ip"}",
                //   style: Theme.of(context).textTheme.titleMedium,
                // ),
                const SizedBox(height: 48),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Torna alla Home"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
