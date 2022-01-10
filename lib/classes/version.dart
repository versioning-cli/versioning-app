class Version {
  int major;
  int minor;
  int patch;

  Version({
    required this.major,
    required this.minor,
    required this.patch,
  }) {
    if (major < 0 || minor < 0 || patch < 0) {
      throw Exception('Invalid major version. Please use positive integers');
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is Version) {
      return other.major == major &&
          other.minor == minor &&
          other.patch == patch;
    } else {
      return other.hashCode == hashCode;
    }
  }

  bool operator >(Version other) {
    if (major > other.major) {
      return true;
    } else if (major == other.major && minor > other.minor) {
      return true;
    } else if (major == other.major &&
        minor == other.minor &&
        patch > other.patch) {
      return true;
    } else {
      return false;
    }
  }

  bool operator <(Version other) {
    if (major < other.major) {
      return true;
    } else if (major == other.major && minor < other.minor) {
      return true;
    } else if (major == other.major &&
        minor == other.minor &&
        patch < other.patch) {
      return true;
    } else {
      return false;
    }
  }

  operator &(Version other) {
    throw Exception('Invalid operation on Version');
  }

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

  @override
  int get hashCode => toString().hashCode;
}
