import 'package:universal_html/html.dart' as html;

String getOSInsideWeb() {
  final userAgent = html.window.navigator.userAgent.toString().toLowerCase();
  if (userAgent.contains("iphone")) return "ios";
  if (userAgent.contains("ipad")) return "ios";
  if (userAgent.contains("android")) return "Android";
  if (userAgent.contains("windows")) return "Web";
  if (userAgent.contains("mac")) return "Web";
  if (userAgent.contains("linux")) return "Web";
  if (userAgent.contains("x11")) return "Web";

  return "Web";
}
