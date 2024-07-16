// ignore_for_file: non_constant_identifier_names, unused_field, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:action_pump_wether/Model/DeviceData.dart';
import 'package:action_pump_wether/Model/WifiNetwkor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController extends ChangeNotifier {
  final String _UUID_SERVICE_CONNECTION = "00000000-0001-4181-8813-29504f5dd727";
  final String _UUID_CHARACTERISTIC_WIFI_CCONNECTION_STATUS = "00000001-0001-4018-950b-bd7f813ae149";
  final String _UUID_CHARACTERISTIC_CREDENTIAL = "00000002-0001-4018-950b-bd7f813ae149";
  final String _UUID_CHARACTERISTIC_WIFI_POWER = "00000003-0001-461e-b02d-a253381b64d8";
  final String _UUID_CHARACTERISTIC_AVAIABLE_NETWORK = "00000004-0001-437c-99c4-7b829c179bb9";
  final String _UUID_CHARACTERISTIC_NETWORK_IP = "00000005-0001-435b-86b1-b7fd6559e949";

  final String _UUID_EROGATION_DATA = "00000000-0002-49ea-90a2-93e2b252141c";
  final String _UUID_CHARACTERISTIC_EROGATION_STATUS = "00000001-0002-4ac2-8cc9-decfc9511411";
  final String _UUID_CHARACTERISTIC_EROGATION_CONTROLL = "00000002-0002-4f3a-9de5-cae7c45f5a8c";
  final String _UUID_CHARACTERISTIC_EROGATION_DURATION = "00000003-0002-4f3a-9de5-cae7c45f5a8c";
  final String _UUID_CHARACTERISTIC_REMAING_TIME = "00000004-0002-4f3a-9de5-cae7c45f5a8c";
  final String _UUID_CHARACTERISTIC_EROGATION_TIME = "00000005-0002-4f3a-9de5-cae7c45f5a8c";

  final String _UUID_CONFIGURATION_DATA = "00000000-0003-49ea-90a2-93e2b252141c";
  final String _UUID_CHARACTERISTIC_PROBABILITY_THRESHOLD = "00000001-0003-4ac2-8cc9-decfc9511411";
  final String _UUID_CHARACTERISTIC_FORECAST_HOURS_AHEAD = "00000002-0003-4f3a-9de5-cae7c45f5a8c";
  final String _UUID_CHARACTERISTIC_FORECAST_HOURS_PAST = "00000003-0003-4f3a-9de5-cae7c45f5a8c";
  final String _UUID_CHARACTERISTIC_WEATHER_CHECK_OFFSET = "00000004-0003-4f3a-9de5-cae7c45f5a8c";

  final String _DEVICE_NAME = "PumpAction";

  DeviceData deviceData = DeviceData();
  bool _connected = false;
  bool _connecting = false;
  BluetoothDevice? _device;
  bool get connected => _connected;
  bool get scanning => FlutterBluePlus.isScanningNow;
  final List<BluetoothCharacteristic> _deviceCharacteristics = [];

  BluetoothController();

  Future<void> init() async {
    await FlutterBluePlus.setLogLevel(LogLevel.info);

    _startScan();
  }

  void _startScan() async {
    await FlutterBluePlus.startScan(
      withServices: [
        Guid(_UUID_SERVICE_CONNECTION),
        Guid(_UUID_EROGATION_DATA),
        Guid(_UUID_CONFIGURATION_DATA),
      ],
      withNames: [_DEVICE_NAME],
    );
    var subscription = FlutterBluePlus.onScanResults.listen(_onScanResult);
    FlutterBluePlus.cancelWhenScanComplete(subscription);
  }

  void _onScanResult(List<ScanResult> results) {
    if (results.isEmpty) return;

    ScanResult r = results.last;
    if (r.device.advName != _DEVICE_NAME) return;
    if (_connecting) return;
    _connectToDevice(r.device);
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    _device = device;
    _connecting = true;

    // deviceData = DeviceData();
    // listen for disconnection
    var subscription = device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        _startScan();
        print("${device.disconnectReason} ${device.disconnectReason?.description}");
      }
    });

    device.cancelWhenDisconnected(subscription, delayed: true, next: true);
    await Future.delayed(const Duration(seconds: 1));
    await device.connect();
    await device.connectionState.where((val) => val == BluetoothConnectionState.connected).first;
    _connected = true;
    _connecting = false;

    _deviceCharacteristics.clear();
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      _deviceCharacteristics.addAll(service.characteristics);
    }

    _setCallbackOnValue(_getCharatteristichFromUUID(_UUID_CHARACTERISTIC_WIFI_CCONNECTION_STATUS)!, (List<int> value) {
      int status = _bleValueToInt(value);
      deviceData.importWifiDataFromStatus(status);
      print("Connection status: $status");
      notifyListeners();
    });

    _setCallbackOnValue(_getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_STATUS)!, (List<int> value) {
      int status = _bleValueToInt(value);
      deviceData.importErogationStatus(status);
      notifyListeners();
    });

    _setCallbackOnValue(_getCharatteristichFromUUID(_UUID_CHARACTERISTIC_REMAING_TIME)!, (List<int> value) {
      int time = _bleValueToInt(value);
      deviceData.erogationData.remainingTime = time;
      notifyListeners();
    });

    _setCallbackOnValue(_getCharatteristichFromUUID(_UUID_CHARACTERISTIC_AVAIABLE_NETWORK)!, (List<int> v) {
      deviceData.availableNetworks.clear();
      List<String> fields = _bleValueToString(v).split(';');
      List<Wifinetwkork> resultNet = [];
      if (fields.length % 2 != 0) fields.removeLast();

      for (int i = 0; i < fields.length; i += 2) {
        String name = fields[i];
        int power = int.parse(fields[i + 1]);

        Wifinetwkork net = Wifinetwkork(power: power, name: name);
        resultNet.add(net);
      }

      List<Wifinetwkork> filtredList = [];

      for (Wifinetwkork net in resultNet) {
        bool isPresent = false;

        for (Wifinetwkork nw in filtredList) {
          if (nw.name == net.name) {
            isPresent = true;
            break;
          }
        }

        if (!isPresent) {
          filtredList.add(net);
        }
      }

      deviceData.availableNetworks.addAll(filtredList);
    });

    device.connectionState.listen((BluetoothConnectionState state) {
      if (state == BluetoothConnectionState.disconnected) {
        _connected = false;
      } else if (state == BluetoothConnectionState.connected) {
        _connected = true;
      }
      notifyListeners();
    });

    await readAllValue();
  }

  /// Preleva tutti i valori iniziali dall'ESP. Questo poiché finche l'ESP non li notifica i callback non vengono
  /// chiamati e quindi i valori non vengono aggiornati
  Future<void> readAllValue() async {
    // Connessione wifi
    BluetoothCharacteristic connectionStatus = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_WIFI_CCONNECTION_STATUS)!;
    BluetoothCharacteristic wifiIP = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_NETWORK_IP)!;

    deviceData.importWifiDataFromStatus(_bleValueToInt(await connectionStatus.read()));
    deviceData.wifiNetworkIP = _bleValueToString(await wifiIP.read());

    // comando e configurazione
    BluetoothCharacteristic erogationStatus = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_STATUS)!;
    BluetoothCharacteristic duration = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_DURATION)!;
    // BluetoothCharacteristic erogationList = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_LIST)!;
    BluetoothCharacteristic prob = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_PROBABILITY_THRESHOLD)!;
    BluetoothCharacteristic forcastAhead = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_FORECAST_HOURS_AHEAD)!;
    BluetoothCharacteristic forcastPast = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_FORECAST_HOURS_PAST)!;
    BluetoothCharacteristic offset = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_WEATHER_CHECK_OFFSET)!;
    BluetoothCharacteristic remainingTime = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_REMAING_TIME)!;
    BluetoothCharacteristic erogationTime = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_TIME)!;

    deviceData.importErogationStatus(_bleValueToInt(await erogationStatus.read()));
    deviceData.erogationData.duration = _bleValueToInt(await duration.read());
    // deviceData.erogationData.importErogations(await erogationList.read());
    deviceData.configurationData.probabilityThreshold = _bleValueToInt(await prob.read());
    deviceData.configurationData.forecastHoursAhead = _bleValueToInt(await forcastAhead.read());
    deviceData.configurationData.forecastHoursPast = _bleValueToInt(await forcastPast.read());
    deviceData.configurationData.weatherCheckOffset = _bleValueToInt(await offset.read());
    deviceData.erogationData.remainingTime = _bleValueToInt(await remainingTime.read());
    deviceData.erogationData.erogationTime = _bleValueToInt(await erogationTime.read());
    notifyListeners();
  }

  /// Dato il nome della caratteristica viene impostato il callback passato come parametro nel momento in
  /// cui la caratteristica è notifica dall'ESP
  ///
  /// Gestisce in automatico anche il dispose qual'ora il dispositivo di dovesse disconnettere
  Future<StreamSubscription> _setCallbackOnValue(BluetoothCharacteristic char, Function(List<int>) callback) async {
    StreamSubscription subscription = char.onValueReceived.listen((List<int> v) {
      callback(v);
      notifyListeners();
    });

    _device!.cancelWhenDisconnected(subscription, next: true);
    await char.setNotifyValue(true);
    return subscription;
  }

  /// Dato il codice UUID della caratteristica restituisce la caratteristica corrispondente se presente nella
  /// lista fornita dall'ESP32
  BluetoothCharacteristic? _getCharatteristichFromUUID(String uuid) {
    return _deviceCharacteristics.firstWhere((c) => c.characteristicUuid.toString() == uuid);
  }

  Future<void> sendWifiCredential(String ssid, String password) async {
    BluetoothCharacteristic char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_CREDENTIAL)!;
    String valueToSend = "$ssid?$password";
    await char.write(valueToSend.codeUnits);
  }

  Future<void> setErogationActive(bool status) async {
    BluetoothCharacteristic char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_CONTROLL)!;
    try {
      await char.write([status ? 1 : 0]);
    } catch (e) {
      print("Errore nell'invio del comando di controllo");
    }
  }

  Future<void> setNewConfigurationValue(ConfigurationVoice voice, int newValue) async {
    if (connected == false) {
      log("Errore: Tentativo di invio dati $voice con valore $newValue, ma il dispositivo non è connesso");
      return;
    }
    BluetoothCharacteristic char;

    switch (voice) {
      case ConfigurationVoice.probabilityThreshold:
        char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_PROBABILITY_THRESHOLD)!;
        break;

      case ConfigurationVoice.forecastHoursAhead:
        char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_FORECAST_HOURS_AHEAD)!;
        newValue = newValue ~/ 3600;
        break;

      case ConfigurationVoice.forecastHoursPast:
        char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_FORECAST_HOURS_PAST)!;
        newValue = newValue ~/ 3600;
        break;

      case ConfigurationVoice.weatherCheckOffset:
        char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_WEATHER_CHECK_OFFSET)!;
        break;

      case ConfigurationVoice.duration:
        char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_DURATION)!;
        break;

      case ConfigurationVoice.erogationTime:
        char = _getCharatteristichFromUUID(_UUID_CHARACTERISTIC_EROGATION_TIME)!;
        break;
    }

    _setCharatteristichValue(char, newValue);
    await readAllValue();
  }

  Future<bool> _setCharatteristichValue(BluetoothCharacteristic char, int value) async {
    try {
      await char.write(_intToUint8List(value));
    } catch (e) {
      print("Errore nell'invio del comando di controllo");
      return false;
    }

    return true;
  }

  String _bleValueToString(List<int> value, [String defaultValue = ""]) {
    if (value.isEmpty) return defaultValue;
    return String.fromCharCodes(value);
  }

  int _bleValueToInt(List<int> value, [int defaultValue = 0]) {
    if (value.isEmpty) return defaultValue;

    if (value.length == 1) return value.first;

    int result = 0;
    for (int i = 0; i < value.length; i++) {
      result |= value[i] << (8 * i);
    }
    return result;
  }

  Uint8List _intToUint8List(int value) {
    var byteData = ByteData(4);
    byteData.setInt32(0, value, Endian.little);
    return byteData.buffer.asUint8List();
  }
}
