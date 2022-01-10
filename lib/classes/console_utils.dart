import 'dart:io';

class ConsoleUtils {
  static void printError(String message) {
    stderr.writeln("\x1B[31m$message\x1B[0m");
  }

  static void printVerbose(String message) {
    stdout.writeln("\x1B[34m$message\x1B[0m");
  }

  static void printSuccess(String message) {
    stdout.writeln("\x1B[32m$message\x1B[0m");
  }

  static void print(String message) {
    stdout.writeln(message);
  }
}
