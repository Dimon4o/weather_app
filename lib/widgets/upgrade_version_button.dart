import 'package:flutter/material.dart';
import 'package:weather_app/utils/utils.dart';

import '../utils/themes/themes.dart';

class UpgradeVersionButton extends StatelessWidget {
  const UpgradeVersionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
