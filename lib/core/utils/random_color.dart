// method that get random color
import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
      255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
}
