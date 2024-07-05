import 'package:intl/intl.dart';

extension ExtNum on num {
  String toBRL() {
    final NumberFormat brlFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: "");
    return brlFormat.format(this);
  }
}
