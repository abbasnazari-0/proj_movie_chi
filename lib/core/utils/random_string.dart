// method that generae random string
import 'dart:math';

String generateRandomString(int len) {
  var r = Random();
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}
