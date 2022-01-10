import 'package:test/test.dart';
import 'package:versioning/classes/version.dart';

void main() {
  group('Testing class Version', () {
    test('None version is 0.0.0', () {
      expect(Version.none, equals(Version(major: 0, minor: 0, patch: 0)));
    });

    test('Version toString is MAJOR.MINOR.PATCH', () {
      expect(Version.none.toString(), equals('0.0.0'));
      expect(Version(major: 1, minor: 2, patch: 3).toString(), equals('1.2.3'));
    });

    test('Version components must be positive integers', () {
      expect(() => Version(major: -1, minor: 0, patch: 0), throwsException);
      expect(() => Version(major: 0, minor: -1, patch: 0), throwsException);
      expect(() => Version(major: 0, minor: 0, patch: -1), throwsException);
    });
  });
}
