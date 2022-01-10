import 'dart:io';

import 'package:path/path.dart';
import 'package:versioning/classes/console_utils.dart';
import 'package:versioning/classes/plugin.dart';
import 'package:versioning/classes/version.dart';

class DartPlugin extends Plugin {
  DartPlugin()
      : super(
          files: ['pubspec.yaml'],
        );

  @override
  Version getVersion() {
    Directory currentDirectory = Directory.current;
    File pubspecFile = File(
      join(
        currentDirectory.path,
        'pubspec.yaml',
      ),
    );
    if (!pubspecFile.existsSync()) {
      ConsoleUtils.printError(
        "pubspec.yaml file not found in the current directory",
      );
      return Version.none;
    }
    String content = pubspecFile.readAsStringSync();

    RegExp versionRegex = RegExp(
      r'^version: (\d+\.\d+\.\d+)$',
      multiLine: true,
    );

    for (RegExpMatch regExpMatch in versionRegex.allMatches(content)) {
      for (String? group in Iterable<int>.generate(regExpMatch.groupCount)
          .map((index) => regExpMatch.group(index))) {
        if (group != null && RegExp(r'\d+\.\d+\.\d+').hasMatch(group)) {
          RegExpMatch? versionMatch =
              RegExp(r'\d+\.\d+\.\d+').firstMatch(group);
          if (versionMatch == null) {
            return Version.none;
          }
          for (String? versionGroup
              in Iterable<int>.generate(regExpMatch.groupCount)
                  .map((index) => versionMatch.group(index))) {
            if (versionGroup != null && Version.match(versionGroup)) {
              return Version.parse(versionGroup);
            }
          }
        }
      }
    }

    ConsoleUtils.printError(
      'No valid semver version found. Please check your pubspec.yaml file',
    );
    return Version.none;
  }

  @override
  Future<void> setVersion(Version version) async {
    Directory currentDirectory = Directory.current;
    File pubspecFile = File(
      join(
        currentDirectory.path,
        'pubspec.yaml',
      ),
    );
    String content = await pubspecFile.readAsString();
    String contentReplaced = content.replaceAll(
      RegExp(
        r'^version: (\d+\.\d+\.\d+)$',
        multiLine: true,
      ),
      'version: $version',
    );
    await pubspecFile.writeAsString(
      contentReplaced,
      mode: FileMode.writeOnly,
      flush: true,
    );
  }
}
