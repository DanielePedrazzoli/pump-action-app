class TimeFormatter {
  /// Scrive il tempo fornito (in secondi) nel formato xxh xxm
  ///
  /// Nel caso il valore in secondi sia nullo, viene restituito il [[fallback]]
  static String writeDurationHM(int seconds, [String fallback = "No"]) {
    if (seconds == 0) {
      return fallback;
    }

    Duration duration = Duration(seconds: seconds);

    if (duration.inHours == 0) {
      return "${_padValue(duration.inMinutes)}m";
    }

    if (duration.inMinutes == 0) {
      return "${_padValue(duration.inHours)}h";
    }

    return "${_padValue(duration.inHours)}h ${_padValue(duration.inMinutes % 60)}m";
  }

  /// Scrive il tempo fornito (in secondi) nel formato xxm xxs
  ///
  /// Nel caso il valore in secondi sia nullo, viene restituito il [[fallback]]
  static String writeDurationMS(int seconds, [String fallback = "No"]) {
    if (seconds == 0) {
      return fallback;
    }

    Duration duration = Duration(seconds: seconds);

    if (duration.inMinutes == 0) {
      return "${_padValue(duration.inSeconds)}s";
    }

    return "${duration.inMinutes}m ${_padValue(duration.inSeconds % 60)}s";
  }

  /// Scrive il tempo fornito (in secondi) nel formato hh:mm
  static String writeTimeOfDay(int seconds) {
    Duration duration = Duration(seconds: seconds);

    return "${_padValue(duration.inHours)}:${_padValue(duration.inMinutes % 60)}";
  }

  /// Restituisce il valore in secondi del tempo fornito nel formato xh
  ///
  /// Nel caso il valore in secondi sia nullo, viene restituito il [[fallback]]
  static String writeHour(int seconds, [String fallback = "No"]) {
    Duration duration = Duration(seconds: seconds);

    return "${duration.inHours}h";
  }

  /// Restituisce il valore in secondi del tempo fornito nel formato xxm
  ///
  /// Nel caso il valore in secondi sia nullo, viene restituito il [[fallback]]
  static String writeMinutes(int seconds, [String fallback = "No"]) {
    Duration duration = Duration(seconds: seconds);

    return "${_padValue(duration.inMinutes)}h";
  }

  static String _padValue(int value) {
    return value.toString().padLeft(2, "0");
  }
}
