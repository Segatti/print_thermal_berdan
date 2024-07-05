extension ExtString on String {
  String removeDiacritics() {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    var newString = this;

    for (int i = 0; i < withDia.length; i++) {
      newString = newString.replaceAll(withDia[i], withoutDia[i]);
    }

    return newString;
  }

  String genereateSpace(int lenghtFixed) {
    var string = this;
    if (length < lenghtFixed) {
      var dif = lenghtFixed - length;
      string = string.padRight(dif);
    }
    return string;
  }
}
