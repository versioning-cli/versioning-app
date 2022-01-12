import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:versioning/classes/console_utils.dart';
import 'package:versioning/commands/release.dart';
import 'package:versioning/commands/version.dart';

void main(List<String> arguments) {
  try {
    CommandRunner runner = CommandRunner('versioning',
        'A CLI app to help you manage versioning on your packages');
    runner.addCommand(ReleaseCommand());
    runner.addCommand(VersionCommand());
    runner.run(arguments);
  } catch (exception) {
    ConsoleUtils.printError(
        '''Unexpected error occurred. Check versioning.log for details

Report bugs: https://github.com/versioning-cli/versioning-app/issues
Propose new features and Q&A: https://github.com/versioning-cli/versioning-app/discussions
''');
    File(join(Directory.current.path, 'versioning.log'))
        .writeAsStringSync('${exception.toString()}\n', mode: FileMode.append);
  }
}
