import 'package:flutter/material.dart';

class Logger {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    debugPrint('** $text [$isError]');
  }
}
