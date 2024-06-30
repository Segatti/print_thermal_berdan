import 'dart:convert';

class DataItemAdicional {
  final String adicional;
  final num? price;
  final int quantity;

  const DataItemAdicional({
    this.adicional = "",
    this.price,
    this.quantity = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adicional': adicional,
      'price': price,
      'quantity': quantity,
    };
  }

  factory DataItemAdicional.fromMap(Map<String, dynamic> map) {
    return DataItemAdicional(
      adicional: map['adicional'] ?? "",
      price: map['price'],
      quantity: map['quantity'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataItemAdicional.fromJson(String source) =>
      DataItemAdicional.fromMap(json.decode(source) as Map<String, dynamic>);
}
