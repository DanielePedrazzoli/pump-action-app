import 'package:action_pump_wether/Model/WifiNetwkor.dart';

class DeviceData {
  bool isConnectedWifi = false;
  int wifiSignalStrengh = 0;
  List<Wifinetwkork> availableNetworks = [];
  bool isWifiScanning = false;
  String? wifiNetworkIP = "";
  bool isPumpActive = false;
  bool isConnecting = false;
  bool hasInternet = false;

  ErogationData erogationData = ErogationData();
  ConfigurationData configurationData = ConfigurationData();

  void importWifiDataFromStatus(int status) {
    isConnectedWifi = status & (1 << 0) != 0;
    isWifiScanning = status & (1 << 1) != 0;
    isConnecting = status & (1 << 2) != 0;
    hasInternet = status & (1 << 3) != 0;
  }

  void importErogationStatus(int status) {
    isPumpActive = status & (1 << 0) != 0;
  }
}

class ErogationData {
  int duration = 0;
  int remainingTime = 0;
  int erogationTime = 0;
  // List<Erogation> erogations = [];

  // importErogations(List<int> data) {
  //   erogations.clear();
  //   if (data.length != 56) {
  //     print('Dati non validi: la lunghezza dell\'input deve essere 56 byte.Ricevuta: ${data.length} byte');
  //     return;
  //   }

  //   for (int i = 0; i < 14; i++) {
  //     int value = 0;
  //     value |= (data[i * 4 + 3] << 24);
  //     value |= (data[i * 4 + 2] << 16);
  //     value |= (data[i * 4 + 1] << 8);
  //     value |= (data[i * 4 + 0] << 0);
  //     erogations.add(Erogation.fromUint32(value));
  //   }
  // }
}

class ConfigurationData {
  int probabilityThreshold = 0;
  int forecastHoursAhead = 0;
  int forecastHoursPast = 0;
  int weatherCheckOffset = 0;
}

enum ConfigurationVoice {
  probabilityThreshold,
  forecastHoursAhead,
  forecastHoursPast,
  weatherCheckOffset,
  duration,
  erogationTime,
}
