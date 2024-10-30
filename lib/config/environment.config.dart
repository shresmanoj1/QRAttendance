import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentConfig {
  static String url = "";
  static String platform = "";
  static bool open = false;
  static String? queueRouteName;
  static String? queueArgs;

  init() async {
    if (Platform.isAndroid) {
      platform = "android";
      // Android-specific code
    } else if (Platform.isIOS) {
      // iOS-specific code
      platform = "ios";
    }
    switch (dotenv.env["ENV"].toString()) {
      case "production":
        url = dotenv.env["LIVE_URL"].toString();
        break;
      case "staging":
        url = dotenv.env["STAGING_URL"].toString();
        break;
      case "local":
        url = dotenv.env["LOCAL_URL"].toString();
        break;
      case "development":
      default:
        url = dotenv.env["DEV_URL"].toString();
        break;
    }
  }
}
