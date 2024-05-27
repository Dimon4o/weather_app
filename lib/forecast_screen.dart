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

List<HourlyWeather> hourlyWeatherForDay(List dailyForecast, int dayIndex) {
  final hours = dailyForecast.toList()[dayIndex]["hour"].toList();
  return List.generate(
    hours.length,
    (hour) {
      return HourlyWeather(
        cloudyCondition: hours[hour]["condition"]["text"],
        windSpeed: hours[hour]["wind_kph"].toInt(),
        windDirection: hours[hour]["wind_dir"],
        temperature: hours[hour]["temp_c"].toInt(),
        humidity: hours[hour]["humidity"].toInt(),
        time: hours[hour]["time"].toString().split(" ")[1],
      );
    },
  );
}

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
                    snapshot.data!["forecast"]["forecastday"].toList();

                final currentHour = int.tryParse(
                  weather["location"]["localtime"]
                      .toString()
                      .split(" ")[1]
                      .split(":")[0],
                );

                final thisWeeksWeather = ThisWeeksWeather(
                  eightDays: List.generate(
                    dailyForecast.length,
                    (index) {
                      return DailyWeather(
                        date: dailyForecast[index]["date"]
                            .toString()
                            .split("-")[2],
                        cloudyCondition: dailyForecast[index]["day"]
                            ["condition"]["text"],
                        windSpeed:
                            dailyForecast[index]["day"]["maxwind_kph"].toInt(),
                        maxTemperature:
                            dailyForecast[index]["day"]["maxtemp_c"].toInt(),
                        minTemperature:
                            dailyForecast[index]["day"]["mintemp_c"].toInt(),
                        averageTemperature:
                            dailyForecast[index]["day"]["avgtemp_c"].toInt(),
                        humidity:
                            dailyForecast[index]["day"]["avghumidity"].toInt(),
                      );
                    },
                  ),
                );

                final currentWeather = CurrentWeather(
                  cloudyCondition: weather["current"]["condition"]["text"],
                  windSpeed: weather["current"]["wind_kph"].toInt(),
                  windDirection: weather["current"]["wind_dir"],
                  temperature: weather["current"]["temp_c"].toInt(),
                  feelsLike: weather["current"]["feelslike_c"].toInt(),
                  humidity: weather["current"]["humidity"].toInt(),
                  sunriseTime: dailyForecast[0]["astro"]["sunrise"],
                  sunsetTime: dailyForecast[0]["astro"]["sunset"],
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
                            currentWeather: currentWeather, weather: weather),
                        const UpgradeVersionButton(),
                        ThisAfternoonWidget(
                            sixteenHoursForecast: sixteenHoursForecast),
                        const SizedBox(height: 20),
                        ThisWeekWidget(thisWeeksWeather: thisWeeksWeather),
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
