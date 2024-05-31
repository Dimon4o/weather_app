import 'dart:convert';

import 'package:weather_app/data/weather_models.dart';
import 'utils/themes/themes.dart';
import '/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/widgets.dart';

String apiKey = 'd3e551015dc04c50b90110622240305';
String currentCity = 'Omsk';
int days = 8;

String weatherApiUrl = "https://api.weatherapi.com/v1/forecast.json?"
    "key=${apiKey}"
    "&q=${currentCity}"
    "&days=${days}"
    "&aqi=no&alerts=no";

Future<Map<String, dynamic>> fetchWeatherDataFromUrl(String apiUrl) async {
  final response = await http.Client().get(Uri.parse(apiUrl));
  return compute(parseData, response.body);
}

Map<String, dynamic> parseData(String responseBody) {
  final parsed = Map<String, dynamic>.from(json.decode(responseBody));
  return parsed;
}

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  List<HourlyWeather> hourlyWeatherForDay(List dailyForecast, int dayIndex) {
    final hours = dailyForecast.toList()[dayIndex]["hour"].toList();
    return List.generate(
      hours.length,
      (hour) => HourlyWeather.fromJson(hours[hour]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your location',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: AppColors.yellow,
                  )
                ],
              ),
            ),
          ),
          body: FutureBuilder(
            future: fetchWeatherDataFromUrl(weatherApiUrl),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final weather = snapshot.data!;
                final dailyForecast =
                    weather["forecast"]["forecastday"].toList();
                final currentWeather = CurrentWeather.fromJson(weather);
                final currentHour = int.tryParse(
                  weather["location"]["localtime"]
                      .toString()
                      .split(" ")[1]
                      .split(":")[0],
                );
                final thisWeeksWeather = ThisWeeksWeather(
                  eightDays: List.generate(
                    dailyForecast.length,
                    (index) => DailyWeather.fromJson(dailyForecast[index]),
                  ),
                );
                final sixteenHoursForecast = SixteenHoursWeather(
                  thisDayForecast: hourlyWeatherForDay(dailyForecast, 0),
                  nextDayForecast: hourlyWeatherForDay(dailyForecast, 1),
                  thisHour: currentHour ?? 0,
                );

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: context.deviceSize.width * 0.9,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        CurrentWeatherWidget(
                          currentWeather: currentWeather,
                          weather: weather,
                        ),
                        const SizedBox(height: 20),
                        ThisAfternoonWidget(
                          sixteenHoursForecast: sixteenHoursForecast,
                        ),
                        const SizedBox(height: 20),
                        ThisWeekWidget(
                          thisWeeksWeather: thisWeeksWeather,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint("${snapshot.error}");
                return const Center(child: Text("ERROR"));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
