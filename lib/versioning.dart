import 'dart:io';

import 'package:path/path.dart';

const version = 'APP_VERSION';

List<FileSystemEntity> getEntries() => Directory.current.listSync();

List<String> getFiles() {
  return getEntries().whereType<File>().map((File file) {
    String directory = file.parent.path;
    String path = file.path;
    return path.replaceAll(directory, '').replaceAll(separator, '');
  }).toList();
}

List<String> getFolders() {
  return getEntries().whereType<Directory>().map((Directory file) {
    String directory = file.parent.path;
    String path = file.path;
    return path.replaceAll(directory, '').replaceAll(separator, '');
  }).toList();
}
