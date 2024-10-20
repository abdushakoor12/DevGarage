extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String shorten({int maxLength = 100, bool addEllipsis = true}) {
    if (length <= maxLength) return this;
    if (addEllipsis) {
      return "${substring(0, maxLength)}...";
    } else {
      return substring(0, maxLength);
    }
  }
}
