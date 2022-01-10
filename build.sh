#!/bin/sh
VERSION=$(grep 'version:' pubspec.yaml | sed -e 's?version: ??')
sed -i -e "s/APP_VERSION/$VERSION/" ./lib/commands/version.dart
if [[ "$OSTYPE" == "msys" ]]; then
    dart compile exe bin/app.dart --output versioning.exe
    sed -i -e "s/$VERSION/APP_VERSION/" ./lib/commands/version.dart
fi