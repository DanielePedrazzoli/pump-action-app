import 'package:action_pump_wether/Model/WeatherPrediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Watherimage extends StatelessWidget {
  final WeatherData? data;
  final double? height;
  final double? width;
  const Watherimage({super.key, required this.data, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    String path = "assets/weather svg/";

    switch (data?.type) {
      case Weather.storm:
      case Weather.stormWithHail:
        path += "Storm.svg";
        break;

      case Weather.drizzle:
      case Weather.rain:
      case Weather.shower:
        path += "Rain.svg";
        break;

      case Weather.showerWithSnow:
        path += "RainAndSnow.svg";
        break;

      case Weather.snow:
        path += "Snow.svg";
        break;

      case Weather.fog:
        path += "Fog.svg";
        break;

      case Weather.wind:
        path += "Wind.svg";
        break;

      case Weather.sun:
        path += "Sun.svg";
        break;

      case Weather.sunWithCloud:
        path += "SunAndCloud.svg";
        break;

      case Weather.cloud:
        path += "Cloud.svg";
        break;

      case Weather.unkwon:
        path += "Sun.svg";
        break;

      case null:
        path += "Sun.svg";
        break;
    }

    return Skeleton.replace(
      child: SvgPicture.asset(
        path,
        width: width,
        height: height,
      ),
    );
  }
}
