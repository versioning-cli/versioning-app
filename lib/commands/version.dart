import 'package:args/command_runner.dart';
import 'package:versioning/classes/console_utils.dart';

class VersionCommand extends Command {
  @override
  String get description => "Show CLI's version";

  @override
  String get name => 'version';

  @override
  void run() async {
    ConsoleUtils.print('APP_VERSION');
  }
}
