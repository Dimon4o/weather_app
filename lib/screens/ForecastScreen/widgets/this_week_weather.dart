

import 'package:flutter/material.dart';

import '../../../config/themes/themes.dart';
import '../../../data/models/models.dart';
import '../../../utils/utils.dart';
import '../forecast_screen.dart';

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
                            "${thisWeeksWeather.eightDays[index].date}",
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
