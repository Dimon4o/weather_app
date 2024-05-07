// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  }) : listOfForecasts = (thisDayForecast.sublist(thisHour) + nextDayForecast).sublist(0, 17);
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
}

enum WindDirections {
  None,
  East,
  West,
  South,
  North,
  NorthEast,
  NorthWest,
  SouthEast,
  SouthWest,
}
