class StringHelper {
  static durationToString(Duration value) {
    String negativeSign = value.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(value.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(value.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(value.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
