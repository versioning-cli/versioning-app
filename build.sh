#!/bin/sh
VERSION=$(grep 'version:' pubspec.yaml | sed -e 's?version: ??')
sed -i -e "s/APP_VERSION/$VERSION/" ./lib/commands/version.dart
if [[ ! -d ./build ]]; then
    mkdir build
fi
if [[ "$OSTYPE" == "msys" ]]; then
    dart compile exe bin/app.dart --output build/versioning-$VERSION-win64.exe
    sed -i -e "s/$VERSION/APP_VERSION/" ./lib/commands/version.dart
fi
