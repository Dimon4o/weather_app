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