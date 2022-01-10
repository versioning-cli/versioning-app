import 'dart:io';

import 'package:versioning/classes/console_utils.dart';
import 'package:versioning/classes/version.dart';
import 'package:versioning/enums/version_type.dart';

abstract class Plugin {
  final List<String> files;
  bool git;
  bool verbose;

  Plugin({
    required this.files,
    this.git = true,
    this.verbose = false,
  });

  void run(VersionType versionType) {
    Version version = getVersion();
    if (version != Version.none) {
      onNextVersion(version, versionType);
    }
  }

  Version getVersion();

  Future<void> setVersion(Version version);

  Future<String?> _runCommand(String executable, List<String> args,
      {Function(String?)? onError}) async {
    if (verbose) {
      ConsoleUtils.printVerbose('$executable ${args.join(' ')}');
    }
    ProcessResult result = await Process.run(executable, args);
    if (result.exitCode != 0) {
      ConsoleUtils.printError(
          'An error has occurred while checking git status');
      if (verbose == true) {
        ConsoleUtils.printError('Git exit code: ${result.exitCode}');
        ConsoleUtils.printError(result.stderr.toString());
        if (onError != null) {
          onError(result.stderr);
        }
      }
      return null;
    } else {
      return result.stdout.toString();
    }
  }

  Future<bool?> _existsGitTag(Version version) async {
    String? result = await _runCommand('git', ['tag', '-l', 'v$version']);
    if (result != null) {
      return result.trim() == 'v$version';
    } else {
      return null;
    }
  }

  Future<bool?> _hasGitChanges() async {
    ProcessResult result = await Process.run('git', ['status', '--short']);
    if (result.exitCode == 0) {
      return result.stdout.toString().trim().isNotEmpty;
    } else {
      ConsoleUtils.printError(
          'An error has occurred while checking git status');
      if (verbose == true) {
        ConsoleUtils.printError('Git exit code: ${result.exitCode}');
        ConsoleUtils.printError(result.stderr.toString());
      }
      return null;
    }
  }

  Future<void> _createGitTag(Version previous, Version next) async {
    ProcessResult result = await Process.run(
        'git', ['tag', '-a', 'v$next', '-m', 'release v$next']);
    if (result.exitCode == 0) {
      ConsoleUtils.printSuccess("Version $next released");
    } else {
      ConsoleUtils.printError(
          'An error has occurred while creating the git tag. Trying to revert changes');
      if (verbose == true) {
        ConsoleUtils.printError('Git exit code: ${result.exitCode}');
        ConsoleUtils.printError(result.stderr.toString());
      }
      await setVersion(previous);
    }
  }

  void onNextVersion(Version version, VersionType versionType) async {
    Version newVersion = Version(
      major: version.major,
      minor: version.minor,
      patch: version.patch,
    );
    if (VersionType.major == versionType) {
      newVersion.major++;
      newVersion.minor = 0;
      newVersion.patch = 0;
    } else if (VersionType.minor == versionType) {
      newVersion.minor++;
      newVersion.patch = 0;
    } else if (VersionType.patch == versionType) {
      newVersion.patch++;
    } else {
      throw Exception('Invalid version type');
    }

    if (git == true) {
      bool? gitChanges = await _hasGitChanges();
      if (gitChanges != null) {
        if (gitChanges == true) {
          ConsoleUtils.printError(
              'Your project have pending changes, tag cannot be created. Trying to revert changes');
          await setVersion(version);
        } else {
          bool? existingTag = await _existsGitTag(newVersion);
          if (existingTag != null && existingTag == false) {
            await setVersion(newVersion);
            await _beforeGitTag(version, newVersion);
            await _createGitTag(version, newVersion);
          } else if (existingTag != null && existingTag == true) {
            ConsoleUtils.printError(
              'Existing git tag with v$newVersion. Please solve your versioning conflicts',
            );
          }
        }
      }
    } else {
      setVersion(newVersion);
      ConsoleUtils.printSuccess("Version $newVersion released");
    }
  }

  Future<void> _beforeGitTag(Version previous, Version next) async {
    await _runCommand('git', ['add', '--all']);
    await _runCommand(
      'git',
      ['commit', '-m', "release: new release v$next"],
      onError: (String? error) async {
        ConsoleUtils.printError(
          'An error occurred while commiting changes. Trying to revert changes',
        );
        _runCommand('git', ['rm', '-r', "*"]);
        await setVersion(previous);
      },
    );
  }
}
