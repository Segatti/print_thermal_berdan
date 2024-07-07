extension ExtNum on num {
  String toBRL() {
    return toStringAsFixed(2)
        .replaceAll(".", "/")
        .replaceAll(",", ".")
        .replaceAll("/", ",");
  }
}
