import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      home: const ForecastScreen(),
    );
  }
}

ThemeData light = ThemeData(
  fontFamily: 'Montserrat',
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFAB011)),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: bottomNavBarTheme,
);

class AppColors {
  const AppColors._();

  static Color get yellow => const Color(0xFFFAB011);
  static Color get green => const Color(0xFF19BF6B);
  static Color get blue => const Color(0xFF4CD7DE);
  static Color get grey => const Color(0xFF7B7979);
  static Color get inactiveGrey => const Color(0xFFE4E4E4);
  static Color get whiteBackground => const Color(0xFFFFFFFF);
  static Color get purple => const Color(0xFF7A67D0);
}

BottomNavigationBarThemeData bottomNavBarTheme = BottomNavigationBarThemeData(
  backgroundColor: AppColors.whiteBackground,
  selectedLabelStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  unselectedLabelStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  selectedItemColor: AppColors.yellow,
  unselectedItemColor: AppColors.grey,
  type: BottomNavigationBarType.fixed,
);

extension BuildContextExtensions on BuildContext {
  Size get deviceSize => MediaQuery.sizeOf(this);
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const MyCustomBottomNavBarItem({
    required this.initialLocation,
    required super.icon,
    super.label,
    Widget? activeIcon,
  }) : super(activeIcon: activeIcon ?? icon);
}

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

double getNormalValue(
    double value, double coefficient, double maxValue, double minValue) {
  if (value * coefficient > maxValue) {
    return maxValue;
  }
  if (value * coefficient < minValue) {
    return minValue;
  } else {
    return value * coefficient;
  }
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

class ThisWeekWidget extends StatelessWidget {
  const ThisWeekWidget({
    super.key,
    required this.thisWeeksWeather,
  });

  final ThisWeeksWeather thisWeeksWeather;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: 30,
                        child: Center(
                          child: Text(
                            thisWeeksWeather.eightDays[index].date,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 30,
                      width: getNormalValue(
                        thisWeeksWeather.eightDays[index].maxTemperature
                            .toDouble(),
                        13,
                        context.deviceSize.width * 0.67,
                        100,
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            color: Colors.white.withOpacity(0.2),
                            child: Center(
                              child: Text(
                                "${thisWeeksWeather.eightDays[index].minTemperature}°",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "${thisWeeksWeather.eightDays[index].maxTemperature}°",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class ThisAfternoonWidget extends StatelessWidget {
  const ThisAfternoonWidget({
    super.key,
    required this.sixteenHoursForecast,
  });

  final SixteenHoursWeather sixteenHoursForecast;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: context.deviceSize.width * 0.10,
                          height: getNormalValue(
                            sixteenHoursForecast
                                .listOfForecasts[index].temperature
                                .toDouble(),
                            10,
                            120,
                            47,
                          ),
                          decoration: const ShapeDecoration(
                            color: Color(0xFFFFA91B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${sixteenHoursForecast.listOfForecasts[index].temperature}°",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  sixteenHoursForecast
                                      .listOfForecasts[index].windDirection
                                      .toLowerCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          sixteenHoursForecast.listOfForecasts[index].time,
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
    );
  }
}

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

class CurrentWeather {
  final String cloudyCondition;
  final int windSpeed;
  final String windDirection;
  final int temperature;
  final int feelsLike;
  final int humidity;
  final String sunriseTime;
  final String sunsetTime;
  const CurrentWeather({
    required this.cloudyCondition,
    required this.windSpeed,
    required this.windDirection,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> weather) {
    final dailyForecast = weather["forecast"]["forecastday"].toList()[0];
    return CurrentWeather(
      cloudyCondition: weather["current"]["condition"]["text"],
      windSpeed: weather["current"]["wind_kph"].toInt(),
      windDirection: weather["current"]["wind_dir"],
      temperature: weather["current"]["temp_c"].toInt(),
      feelsLike: weather["current"]["feelslike_c"].toInt(),
      humidity: weather["current"]["humidity"].toInt(),
      sunriseTime: dailyForecast["astro"]["sunrise"],
      sunsetTime: dailyForecast["astro"]["sunset"],
    );
  }
}

class SixteenHoursWeather {
  List<HourlyWeather> thisDayForecast;
  List<HourlyWeather> nextDayForecast;
  List<HourlyWeather> listOfForecasts;
  int thisHour;
  SixteenHoursWeather({
    required this.thisDayForecast,
    required this.nextDayForecast,
    required this.thisHour,
  }) : listOfForecasts = (thisDayForecast.sublist(thisHour) + nextDayForecast)
            .sublist(0, 17);
}

class ThisWeeksWeather {
  List<DailyWeather> eightDays;
  ThisWeeksWeather({
    required this.eightDays,
  });
}

class HourlyWeather {
  final String cloudyCondition;
  final int windSpeed;
  final String windDirection;
  final int temperature;
  final int humidity;
  final String time;
  HourlyWeather({
    required this.cloudyCondition,
    required this.windSpeed,
    required this.windDirection,
    required this.temperature,
    required this.humidity,
    required this.time,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> hour) {
    return HourlyWeather(
      cloudyCondition: hour["condition"]["text"],
      windSpeed: hour["wind_kph"].toInt(),
      windDirection: hour["wind_dir"],
      temperature: hour["temp_c"].toInt(),
      humidity: hour["humidity"].toInt(),
      time: hour["time"].toString().split(" ")[1],
    );
  }
}

class DailyWeather {
  final String date;
  final String cloudyCondition;
  final int windSpeed;
  final int maxTemperature;
  final int minTemperature;
  final int averageTemperature;
  final int humidity;
  DailyWeather({
    required this.date,
    required this.cloudyCondition,
    required this.windSpeed,
    required this.maxTemperature,
    required this.minTemperature,
    required this.averageTemperature,
    required this.humidity,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> dailyForecast) {
    return DailyWeather(
      date: dailyForecast["date"].toString().split("-")[2],
      cloudyCondition: dailyForecast["day"]["condition"]["text"],
      windSpeed: dailyForecast["day"]["maxwind_kph"].toInt(),
      maxTemperature: dailyForecast["day"]["maxtemp_c"].toInt(),
      minTemperature: dailyForecast["day"]["mintemp_c"].toInt(),
      averageTemperature: dailyForecast["day"]["avgtemp_c"].toInt(),
      humidity: dailyForecast["day"]["avghumidity"].toInt(),
    );
  }
}
