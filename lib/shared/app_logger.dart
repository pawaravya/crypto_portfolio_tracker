import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class AppLogger {
  static var logger = Logger(printer: PrettyPrinter());
  static showErrorLogs(String message) {
    if (kReleaseMode) {
      return;
    }
    logger.e("ERROR " + message.toString());
  }

  static showInfoLogs(String message) {
    if (kReleaseMode) {
      return;
    }
    logger.i("INFO " + message.toString());
  }
}
