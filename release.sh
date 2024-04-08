#!/bin/bash

# Extract version number from pubspec.yaml
version=$(grep -E '^version:' pubspec.yaml | awk '{print $2}')

# Check if version is empty
if [ -z "$version" ]; then
  echo "Error: Version number not found in pubspec.yaml"
  exit 1
fi

# Create Git tag
git tag -a v$version -m "Release version $version"

# Push tag to remote repository
git push origin v$version

echo "Release tagged with version $version"