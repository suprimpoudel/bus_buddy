import 'package:logger/logger.dart';

class Logging {
  static void log(dynamic message, {bool? isInfo}) {
    var logger = Logger();
    if (isInfo == true) {
      logger.i(message);
    } else {
      logger.e(message);
    }
  }
}
