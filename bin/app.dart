import 'package:args/command_runner.dart';
import 'package:versioning/commands/release.dart';
import 'package:versioning/commands/version.dart';

void main(List<String> arguments) {
  CommandRunner runner = CommandRunner(
      'versioning', 'A CLI app to help you manage versioning on your packages');
  runner.addCommand(ReleaseCommand());
  runner.addCommand(VersionCommand());
  runner.run(arguments);
}
