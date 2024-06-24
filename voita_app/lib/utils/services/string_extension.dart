extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toGenitive() {
    String s = this;

    if (s == "Лютий") {
      return "Лютого";
    } else if (s == "Листопад") {
      return "Листопада";
    }
    return s.replaceAll(s.substring(s.length - 3), "ня");
  }
}
