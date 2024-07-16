// ignore_for_file: prefer_initializing_formals

class WeatherData {
  late DateTime date;
  double temperature;
  Weather _weatherType = Weather.unkwon;
  int rainProbability;
  int weatherCode;
  int precepitedTemperature;

  WeatherData({DateTime? hour, this.temperature = 0, this.rainProbability = 0, this.weatherCode = 0, this.precepitedTemperature = 0}) {
    hour ??= DateTime.now();
    date = hour;

    if (weatherCode == 0) {
      _weatherType = Weather.sun;
    } else if (weatherCode == 1) {
      _weatherType = Weather.sunWithCloud;
    } else if (weatherCode == 2 || weatherCode == 3) {
      _weatherType = Weather.cloud;
    } else if (weatherCode >= 40 && weatherCode <= 49) {
      _weatherType = Weather.fog;
    } else if (weatherCode >= 50 && weatherCode <= 59) {
      _weatherType = Weather.drizzle;
    } else if (weatherCode >= 60 && weatherCode <= 69) {
      _weatherType = Weather.rain;
    } else if (weatherCode >= 80 && weatherCode <= 82) {
      _weatherType = Weather.shower;
    } else if (weatherCode >= 83 && weatherCode <= 84) {
      _weatherType = Weather.showerWithSnow;
    } else if (weatherCode >= 85 && weatherCode <= 86) {
      _weatherType = Weather.snow;
    } else if (weatherCode >= 95 && weatherCode <= 97) {
      _weatherType = Weather.storm;
    } else if (weatherCode >= 98 && weatherCode <= 99) {
      _weatherType = Weather.stormWithHail;
    }
  }

  String get temperatureString => "$temperature°";
  Weather get type => _weatherType;

  String get weatherTypeString {
    switch (_weatherType) {
      case Weather.unkwon:
        return "N/A";
      case Weather.sun:
        return "Soleggiato";
      case Weather.sunWithCloud:
        return "Sole con nuvole";
      case Weather.cloud:
        return "Nuvoloso";
      case Weather.fog:
        return "Nebbia";
      case Weather.drizzle:
      case Weather.rain:
      case Weather.shower:
        return "Pioggia";
      case Weather.showerWithSnow:
        return "Pioggia con neve";
      case Weather.snow:
        return "Neve";
      case Weather.storm:
        return "Temporale";
      case Weather.stormWithHail:
        return "Tempesta con grandine";
      default:
        return "";
    }
  }
}

enum Weather {
  stormWithHail,
  storm,
  shower,
  showerWithSnow,
  snow,
  fog,
  wind,
  sun,
  sunWithCloud,
  cloud,
  drizzle,
  rain,
  unkwon,
}
