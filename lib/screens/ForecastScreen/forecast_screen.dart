import 'dart:convert';

import 'package:go_router/go_router.dart';

import '/config/themes/themes.dart';
import '/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/data/models/models.dart';


String apiKey = 'd3e551015dc04c50b90110622240305';
String currentCity = 'Omsk';
int days = 8;

String weatherApiUrl = "https://api.weatherapi.com/v1/forecast.json?"
    "key=${apiKey}"
    "&q=${currentCity}"
    "&days=${7}"
    "&aqi=no&alerts=no";

double getNormalHeight(int value, double coefficient) {
  if (value * coefficient < 60) {
    return 60;
  } else {
    return value * coefficient;
  }
}

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
  static ForecastScreen builder(BuildContext context, GoRouterState state) =>
      const ForecastScreen();
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
                        // SvgPicture.asset(
                        //   'assets/icons/Share.svg',
                        //   height: 20,
                        //   colorFilter:
                        //       ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
                        // )
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
                        Row(
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
                          ],
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: context.deviceSize.width * 0.9,
                                  color: AppColors.purple,
                                  child: const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      'Upgrade for radar and more! \nU can’t join the Hello Weather fan club(',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'This afternoon',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 16,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: context.deviceSize.width *
                                                  0.10,
                                              height: getNormalHeight(
                                                  sixteenHoursForecast
                                                      .listOfForecasts[index]
                                                      .temperature,
                                                  10.0),
                                              decoration: const ShapeDecoration(
                                                color: Color(0xFFFFA91B),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    topRight:
                                                        Radius.circular(5),
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${sixteenHoursForecast.listOfForecasts[index].temperature}°",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    Text(
                                                      sixteenHoursForecast
                                                          .listOfForecasts[
                                                              index]
                                                          .windDirection
                                                          .toLowerCase(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              sixteenHoursForecast
                                                  .listOfForecasts[index].time,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'This week',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            Column(
                              children: List.generate(
                                days,
                                (index) {
                                  return Container(
                                    decoration: ShapeDecoration(
                                      color: AppColors.yellow,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "${thisWeeksWeather.eightDays[index].date}",
                                        ),
                                        Text(
                                          "${thisWeeksWeather.eightDays[index].maxTemperature}",
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
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
