extension VersionUtils on String {
  /// Returns whether the [version] is greater than the string.
  /// The string is assumed to be of the format "x.x.x"(semver).
  bool hasHigherVersionThan(String version) {
    List<String> askerVersion = version.split(".");
    List<String> myVersion = split(".");
    for (var i = 0; i < 3; i++) {
      final askerVersionInt =
          askerVersion.length > i ? int.tryParse(askerVersion[i]) ?? 0 : 0;
      final myVersionInt =
          myVersion.length > i ? int.tryParse(myVersion[i]) ?? 0 : 0;
      if (askerVersionInt != myVersionInt) {
        return myVersionInt > askerVersionInt;
      }
    }
    return false;
  }
}
