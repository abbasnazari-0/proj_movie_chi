extension DurationFormat on Duration {
  String formatToHHMMSS() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(inHours);
    String minutes = twoDigits(inMinutes.remainder(60));
    String seconds = twoDigits(inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }
}
