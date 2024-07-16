import 'package:action_pump_wether/Controller/BluetoothController.dart';
import 'package:action_pump_wether/Controller/time_formatter.dart';
import 'package:action_pump_wether/Model/DeviceData.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:action_pump_wether/view/Components/settings/settingItem.dart';
import 'package:action_pump_wether/view/Components/settings/settingsList.dart';
import 'package:action_pump_wether/view/Components/StateFull%20dialog/SliderDialog.dart';
import 'package:flutter/material.dart';

class ErogationParameterPage extends StatefulWidget {
  const ErogationParameterPage({super.key});

  @override
  State<ErogationParameterPage> createState() => _ErogationParameterPageState();
}

class _ErogationParameterPageState extends State<ErogationParameterPage> {
  BluetoothController bluetoothController = locator<BluetoothController>();
  DeviceData deviceData = locator<BluetoothController>().deviceData;

  // String _writeHour(int value) {
  //   if (value == 0) return "No";
  //   if (value == 1) return "$value ora";
  //   return "$value ore";
  // }

  void showSuccesSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 24, 98, 26),
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 0,
    ));
  }

  // String _writeTimeOnlyHour(double value) {
  //   if (value == 0) return "No";
  //   return "${value ~/ 3600}h ";
  // }

  // String _writeTime(double value) {
  //   if (value == 0) return "No";
  //   int minutes = value ~/ 60 % 60;
  //   return "${value ~/ 3600}h ${minutes}m";
  // }

  // String _writeTimeAsTimeOfDay(int value) {
  //   if (value == 0) return "No";
  //   int minutes = value ~/ 60 % 60;
  //   int hours = value ~/ 3600;

  //   return "${hours.toString().padLeft(2, "0")}h ${minutes.toString().padLeft(2, "0")}m";
  // }

  // String _writeTimeMinutes(double value) {
  //   int seconds = value.toInt() % 60;
  //   int minutes = value ~/ 60 % 60;
  //   return "${minutes}m ${seconds}s";
  // }

  String _writePercentage(int value) => "${value.toStringAsFixed(0)}%";

  void _changeValue(ConfigurationVoice voice) async {
    Duration max, step;
    int startingValue = 0;
    String title = "";
    String subTitle = "";
    String Function(int) parser;

    switch (voice) {
      case ConfigurationVoice.probabilityThreshold:
        max = const Duration(seconds: 100);
        step = const Duration(seconds: 1);
        title = "Probabilità limite";
        subTitle = "Il limite di probabilità di pioggia nelle ore di analisi. Se superato annulla l’erogazione";
        startingValue = deviceData.configurationData.probabilityThreshold;
        parser = _writePercentage;
        break;

      case ConfigurationVoice.forecastHoursAhead:
        max = const Duration(hours: 5);
        step = const Duration(hours: 1);
        title = "Controllo orario in avanti";
        subTitle = "Quante ore di previsioni vengono considerate per l’analisi della probailità di pioggia";
        startingValue = deviceData.configurationData.forecastHoursAhead * 3600;
        parser = TimeFormatter.writeHour;
        break;
      case ConfigurationVoice.forecastHoursPast:
        max = const Duration(hours: 5);
        step = const Duration(hours: 1);
        title = "Controllo orario passato";
        subTitle = "Quante ore passate vengono considerate per l’analisi della probailità di pioggia";
        startingValue = deviceData.configurationData.forecastHoursPast * 3600;
        parser = TimeFormatter.writeHour;
        break;
      case ConfigurationVoice.weatherCheckOffset:
        max = const Duration(hours: 3);
        step = const Duration(minutes: 5);
        title = "Anticipo controllo";
        subTitle = "Quanto tempo prima dell’erogazione viene effettuato il controllo del meteo";
        startingValue = deviceData.configurationData.weatherCheckOffset;
        parser = TimeFormatter.writeDurationHM;
        break;
      case ConfigurationVoice.duration:
        max = const Duration(minutes: 10);
        step = const Duration(seconds: 5);
        title = "Durata erogazione";
        subTitle = "Per quanto tempo l’erogazione avviene";
        startingValue = deviceData.erogationData.duration;
        parser = TimeFormatter.writeDurationMS;
        break;
      case ConfigurationVoice.erogationTime:
        return;
    }

    int? value = await showDialog(
      context: context,
      builder: (context) {
        return SliderDialog(
          startingValue: startingValue.toDouble(),
          subtitle: subTitle,
          title: title,
          step: step.inSeconds,
          max: max.inSeconds,
          min: 0,
          valueDisplayer: parser,
        );
      },
    );

    if (value == null) return;
    await bluetoothController.setNewConfigurationValue(voice, value);
    showSuccesSnackBar("Modifica ${voice.name} inviata");
  }

  void _askTime(int prevTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now().replacing(hour: prevTime ~/ 3600, minute: prevTime ~/ 60 % 60),
      context: context,
    );

    if (selectedTime == null) return;

    await bluetoothController.setNewConfigurationValue(
      ConfigurationVoice.erogationTime,
      selectedTime.hour * 3600 + selectedTime.minute * 60,
    );
    showSuccesSnackBar("Modifica inviata");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Configurazione erogazione"),
      ),
      body: ListenableBuilder(
        listenable: bluetoothController,
        builder: (context, child) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SettingsList(
              listName: "Configurazione",
              children: [
                SettingsItem(
                  title: "Probabilità limite",
                  description: "Il limite di probabilità di pioggia nelle ore di analisi. Se superato annulla l’erogazione",
                  value: "${deviceData.configurationData.probabilityThreshold}%",
                  onTap: () => _changeValue(ConfigurationVoice.probabilityThreshold),
                ),
                SettingsItem(
                  title: "Controllo orario in avanti",
                  description: "Quante ore di previsioni vengono considerate per l’analisi della probailità di pioggia",
                  value: TimeFormatter.writeHour(deviceData.configurationData.forecastHoursAhead * 3600),
                  onTap: () => _changeValue(ConfigurationVoice.forecastHoursAhead),
                ),
                SettingsItem(
                  title: "Controllo orario passato",
                  description: "Quante ore passate vengono considerate per l’analisi della probailità di pioggia",
                  value: TimeFormatter.writeHour(deviceData.configurationData.forecastHoursPast * 3600),
                  onTap: () => _changeValue(ConfigurationVoice.forecastHoursPast),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsList(
              listName: "Erogazione",
              children: [
                SettingsItem(
                  title: "Inizio erogazione",
                  description: "A quale orario del giorno iniziare l'erogazione",
                  value: TimeFormatter.writeTimeOfDay(deviceData.erogationData.erogationTime),
                  onTap: () => _askTime(deviceData.erogationData.erogationTime),
                ),
                SettingsItem(
                  title: "Durata erogazione",
                  description: "Per quanto tempo l’erogazione avviene",
                  value: TimeFormatter.writeDurationMS(deviceData.erogationData.duration),
                  onTap: () => _changeValue(ConfigurationVoice.duration),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
