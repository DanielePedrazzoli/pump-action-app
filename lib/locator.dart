// This is our global ServiceLocator
import 'package:action_pump_wether/Controller/BluetoothController.dart';
import 'package:action_pump_wether/Controller/weatherController.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerSingleton(BluetoothController());
  locator.registerSingleton(WeatherController());
}
