class Version {
  int major;
  int minor;
  int patch;

  Version({
    required this.major,
    required this.minor,
    required this.patch,
  });

  @override
  String toString() {
    return '$major.$minor.$patch';
  }

  static bool match(String input) {
    return RegExp(r'^\d+\.\d+\.\d+$').hasMatch(input);
  }

  static Version parse(String input) {
    if (match(input)) {
      List<int> tokens =
          input.split('.').map((String token) => int.parse(token)).toList();
      return Version(
        major: tokens[0],
        minor: tokens[1],
        patch: tokens[2],
      );
    } else {
      throw Exception('The provided string is not a valid version');
    }
  }

  static Version none = Version(major: 0, minor: 0, patch: 0);
}
