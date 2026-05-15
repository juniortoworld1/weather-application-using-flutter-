import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimtedClouds extends StatelessWidget {
  final int isday_;
  final int code_;

  const AnimtedClouds({
    super.key,
    required this.isday_,
    required this.code_,
  });

  @override
  Widget build(BuildContext context) {
    // This will always get a local asset path now
    String animationPath = _getAnimationPath(code_, isday_);

    return Container(
      child: Lottie.asset(
        animationPath,
        fit: BoxFit.contain,
        // Shows a small loading spinner while the local JSON file parses
        frameBuilder: (context, child, composition) {
          return composition == null
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : child;
        },
        // Fallback icon if you made a typo in any asset name
      ),
    );
  }

  String _getAnimationPath(int code, int isDay) {
    bool isDaytime = isDay == 1;

    // 1. CLEAR / SUNNY / NIGHT
    if (code == 1000) {
      return isDaytime
          ? "assets/images/sunny.json"
          : "assets/images/clearnight.json";
    }

    // 2. CLOUDY / OVERCAST / MIST / FOG
    // 1003: Partly Cloudy, 1006: Cloudy, 1009: Overcast, 1030: Mist, 1135: Fog
    if ([1003, 1006, 1009, 1030, 1135, 1147].contains(code)) {
      if (code == 1003) {
        return isDaytime
            ? "assets/images/cloudy.json"
            : "assets/images/night_cloudy.json";
      }
      else{
        return isDaytime
            ? "assets/images/cloudy.json"
            : "assets/images/night_cloudy.json";
      }
    }

    // 3. LIGHT RAIN / DRIZZLE / SHOWERS
    // 1063: Patchy rain, 1150/1153: Drizzle, 1180/1183: Light rain, 1240: Light rain shower
    if ([1063, 1150, 1153, 1180, 1183, 1240].contains(code)) {
      return isDaytime
          ? "assets/images/rain.json"
          : "assets/images/nightrain.json";
    }

    // 4. HEAVY RAIN / TORRENTIAL
    // 1186/1189: Moderate rain, 1192/1195: Heavy rain, 1243: Heavy rain shower
    if ([1186, 1189, 1192, 1195, 1243, 1246].contains(code)) {
      return "assets/images/Thunderstorm.json";
    }

    // 5. THUNDERSTORMS
    // 1087: Thundery outbreaks, 1273: Light rain with thunder, 1276: Heavy rain with thunder
    if ([1087, 1273, 1276, 1279, 1282].contains(code)) {
      return "assets/images/Thunderstorm.json";
    }

    // 6. SNOW / SLEET / ICE PELLETS
    if ([1066, 1069, 1072, 1114, 1117, 1204, 1207, 1210, 1213, 1216, 1219, 1222, 1225, 1249, 1252, 1255, 1258].contains(code)) {
      return "assets/images/nightsnow.json";
    }

    // Fallback animation if an unmapped code comes through from the API
    return "assets/images/nightsnow.json";
  }
}