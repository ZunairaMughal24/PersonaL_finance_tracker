class ChartAxisConfig {
  final double maxY;
  final double interval;

  const ChartAxisConfig({required this.maxY, required this.interval});
}

class ChartUtils {
  static ChartAxisConfig getNiceAxisConfig(double maxVal) {
    if (maxVal == 0) {
      return const ChartAxisConfig(maxY: 100, interval: 25);
    }

    final int exponent = int.parse(
      maxVal.abs().toStringAsExponential().split('e')[1],
    );
    final double magnitude = double.parse('1e$exponent');

    final double ratio = maxVal / magnitude;
    double niceMagnitude;

    if (ratio <= 1.5) {
      niceMagnitude = 0.2 * magnitude;
    } else if (ratio <= 3) {
      niceMagnitude = 0.5 * magnitude;
    } else if (ratio <= 7) {
      niceMagnitude = 1.0 * magnitude;
    } else {
      niceMagnitude = 2.0 * magnitude;
    }

    double interval = niceMagnitude;
    double maxY = (maxVal / interval).ceil() * interval;

    if (maxY / interval < 4) {
      interval /= 2;
    }

    return ChartAxisConfig(maxY: maxY, interval: interval);
  }
}
