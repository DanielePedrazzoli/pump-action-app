import 'package:action_pump_wether/Controller/BluetoothController.dart';
import 'package:action_pump_wether/Controller/weatherController.dart';
import 'package:action_pump_wether/locator.dart';
import 'package:action_pump_wether/view/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool ready = false;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    await locator<BluetoothController>().init();
    await locator<WeatherController>().init();

    ready = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3CB6C7)),
        // scaffoldBackgroundColor: const Color.fromARGB(255, 19, 169, 189),
        // cardTheme: CardTheme(
        //   color: Color.fromARGB(255, 210, 250, 255),
        //   elevation: 0,
        //   shadowColor: Colors.transparent,
        //   surfaceTintColor: const Color.fromARGB(0, 60, 183, 199),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        // ),
        // listTileTheme: const ListTileThemeData(
        //   tileColor: Color.fromRGBO(241, 241, 241, 1),
        // ),
        // sliderTheme: SliderTheme.of(context).copyWith(
        //   inactiveTickMarkColor: Colors.transparent,
        // ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF3CB6C7),
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
