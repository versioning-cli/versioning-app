import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:versioning/classes/plugin.dart';
import 'package:versioning/enums/version_type.dart';
import 'package:versioning/plugins/dart.dart';
import 'package:versioning/versioning.dart';

class ReleaseCommand extends Command {
  @override
  String get description => 'Releasing a new version';

  @override
  String get name => 'release';

  ReleaseCommand() {
    argParser.addOption(
      'type',
      help: 'Select the project type',
      allowed: [
        'major',
        'minor',
        'patch',
      ],
      defaultsTo: 'patch',
    );

    argParser.addOption(
      'lang',
      help: 'Select the language used',
      allowed: [
        'auto',
        'dart',
      ],
      defaultsTo: 'auto',
    );

    argParser.addFlag(
      'git',
      help: 'Create new tag after releasing',
      defaultsTo: true,
    );

    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      defaultsTo: false,
      help: 'Show more information for debugging',
    );
  }

  @override
  void run() {
    String releaseType = argResults!['type'];
    String projectLanguage = argResults!['lang'];
    bool verbose = argResults!['verbose'];

    if (projectLanguage == "auto") {
      List<Plugin> plugins = [
        DartPlugin(),
      ];

      List<String> files = getFiles();

      for (Plugin plugin in plugins) {
        if (plugin.files.any((file) => files.contains(file))) {
          plugin.git = argResults!['git'];
          plugin.verbose = verbose;
          plugin.run(
            VersionTypeHelper.fromString(
              releaseType,
            ),
          );
          return;
        }
      }

      stderr.writeln('No compatible project found');
      return;
    } else if (projectLanguage == "dart") {
      DartPlugin plugin = DartPlugin();
      plugin.git = argResults!['git'];
      plugin.verbose = verbose;
      plugin.run(
        VersionTypeHelper.fromString(
          releaseType,
        ),
      );
    }
  }
}
