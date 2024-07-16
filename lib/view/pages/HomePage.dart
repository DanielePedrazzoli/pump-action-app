import 'package:action_pump_wether/Controller/BluetoothController.dart';
import 'package:action_pump_wether/Controller/weatherController.dart';
import 'package:action_pump_wether/Model/WeatherPrediction.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:action_pump_wether/view/Components/Erogation/ErogationSection.dart';
import 'package:action_pump_wether/view/Components/HomeHeader.dart';
import 'package:action_pump_wether/view/Components/alertBanner.dart';
import 'package:action_pump_wether/view/Components/predictionVisualizer.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  WeatherController weatherController = locator<WeatherController>();
  BluetoothController bluetoothController = locator<BluetoothController>();

  Color _getBackgroundColorByWather() {
    switch (weatherController.currentWeather?.type) {
      case Weather.unkwon:
        return Theme.of(context).scaffoldBackgroundColor;
      case Weather.sun:
        return const Color.fromARGB(255, 203, 231, 255);
      case Weather.sunWithCloud:
        return const Color.fromARGB(255, 177, 213, 244);
      case Weather.cloud:
        return const Color.fromARGB(255, 171, 192, 211);
      case Weather.fog:
        return const Color.fromARGB(255, 201, 201, 201);
      case Weather.drizzle:
      case Weather.rain:
      case Weather.shower:
        return const Color.fromARGB(255, 128, 128, 128);
      case Weather.showerWithSnow:
        return const Color.fromARGB(255, 128, 128, 128);
      case Weather.snow:
        return const Color.fromARGB(255, 160, 160, 160);
      case Weather.storm:
        return const Color.fromARGB(255, 128, 128, 128);
      case Weather.stormWithHail:
        return const Color.fromARGB(255, 128, 128, 128);
      default:
        return const Color.fromARGB(255, 203, 231, 255);
    }
  }

  Future<void> _refreshData() async {
    await weatherController.getData();
    await bluetoothController.readAllValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campagnola Emilia"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      // drawer: const Drawer(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          children: [
            ListenableBuilder(
              listenable: weatherController,
              builder: (context, child) => Skeletonizer(
                enabled: weatherController.ready == false,
                child: const Column(
                  children: [
                    Homeheader(),
                    AlertBanner(),
                    Predictionvisualizer(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ListenableBuilder(
              listenable: bluetoothController,
              builder: (context, child) => ErogationSection(),
            ),
          ],
        ),
      ),
    );
  }
}
