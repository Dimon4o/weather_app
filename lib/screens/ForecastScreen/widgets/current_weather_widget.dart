import 'package:flutter/material.dart';

import '../../../data/models/models.dart';

class CurrentWeatherWidget extends StatelessWidget {
  const CurrentWeatherWidget({
    super.key,
    required this.currentWeather,
    required this.weather,
  });

  final CurrentWeather currentWeather;
  final Map<String, dynamic> weather;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Right now',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              Text(
                '${currentWeather.cloudyCondition} for the hour',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '${currentWeather.windSpeed}km/h winds from the southwest',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFB7F7F2).withOpacity(0.6),
                //color: Colors.blue.withOpacity(0.4),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.network(
                "https:${weather["current"]["condition"]["icon"]}",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentWeather.temperature}°',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xFF262D49),
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Text(
                    'Feels like ${currentWeather.feelsLike}°',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
