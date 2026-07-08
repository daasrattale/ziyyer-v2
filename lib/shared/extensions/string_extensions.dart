extension StringCasingExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    if (length == 1) return toUpperCase();
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
