import 'dart:convert';

bool isJson(String str) {
  try {
    jsonDecode(str);
    return true;
  } catch (_) {
    return false;
  }
}
