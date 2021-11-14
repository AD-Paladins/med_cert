// ignore_for_file: unnecessary_this

extension StringCasingExtension on String {
  String toCapitalized() =>
      this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}

extension CapExtension on String {
  String get cleanSpacesBewtween => this.replaceAll(RegExp(' +'), ' ');
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .split(" ")
      .map((str) => str[0].toUpperCase() + str.substring(1).toLowerCase())
      .join(" ");
}
