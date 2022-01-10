enum VersionType {
  major,
  minor,
  patch,
}

class VersionTypeHelper {
  static VersionType fromString(String input) {
    return VersionType.values.firstWhere((element) => element.name == input);
  }
}
