class Wifinetwkork {
  int power;
  String name;
  late ConnectionPowerLevel powerLevel;

  Wifinetwkork({required this.power, required this.name}) {
    powerLevel = ConnectionPowerLevel.veryWeak;

    if (power > -70) {
      powerLevel = ConnectionPowerLevel.strong;
    } else if (power > -85) {
      powerLevel = ConnectionPowerLevel.medium;
    } else if (power > -100) {
      powerLevel = ConnectionPowerLevel.weak;
    } else {
      powerLevel = ConnectionPowerLevel.veryWeak;
    }
  }
}

enum ConnectionPowerLevel { veryWeak, weak, medium, strong }
