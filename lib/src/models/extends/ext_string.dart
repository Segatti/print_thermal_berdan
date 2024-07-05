extension ExtString on String {
  String removeDiacritics() {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    var newString = this;

    for (int i = 0; i < withDia.length; i++) {
      newString.replaceAll(withDia[i], withoutDia[i]);
    }

    return newString;
  }
}
