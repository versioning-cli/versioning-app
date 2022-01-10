#!/bin/sh
VERSION="v$(grep 'version:' pubspec.yaml | sed -E 's/version: (\b[0-9].\b[0-9].\b[0-9])/\1/')"
gh release create $VERSION --title "Release $VERSION" --notes "New release $VERSION" --draft ./versioning.exe
