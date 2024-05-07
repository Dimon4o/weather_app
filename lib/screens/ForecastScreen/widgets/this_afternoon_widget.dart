import 'package:flutter/material.dart';
import 'package:weather_app/utils/utils.dart';

import '../../../data/models/models.dart';

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
