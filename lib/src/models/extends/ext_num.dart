extension ExtNum on num {
  String toBRL() {
    return "R\$ ${toStringAsFixed(2).replaceAll(".", "/").replaceAll(",", ".").replaceAll("/", ",")}";
  }
}
