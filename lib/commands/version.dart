import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:versioning/classes/console_utils.dart';
import 'package:versioning/versioning.dart';

class VersionCommand extends Command {
  @override
  String get description => "Show CLI's version";

  @override
  String get name => 'version';

  VersionCommand() {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help:
          'Show full information. Including application and operating system data',
      negatable: false,
    );
  }

  @override
  void run() async {
    bool verbose = argResults!['verbose'];
    if (verbose == false) {
      ConsoleUtils.print('versioning $version');
    } else {
      ConsoleUtils.print('''versioning: $version
OS: ${Platform.operatingSystemVersion}
''');
    }
  }
}
