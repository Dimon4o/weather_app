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
