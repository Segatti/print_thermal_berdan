import 'dart:convert';

import 'data_item_adicional.dart';
import 'data_item_opcional.dart';

class DataItem {
  final String name;
  final num price;
  final int quantity;
  final List<DataItemOpcional> opcionais;
  final List<DataItemAdicional> adicionais;

  const DataItem({
    this.name = "",
    this.price = 0,
    this.quantity = 0,
    this.opcionais = const [],
    this.adicionais = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pName': name,
      'price': price,
      'quantity': quantity,
      'opcionais': opcionais.map((x) => x.toMap()).toList(),
      'adicionais': adicionais.map((x) => x.toMap()).toList(),
    };
  }

  factory DataItem.fromMap(Map<String, dynamic> map) {
    return DataItem(
      name: map['pName'] ?? "",
      price: map['pPrice'] ?? 0,
      quantity: map['quantity'] ?? 0,
      opcionais: (map['opcionais'] as List?)
              ?.map((e) => DataItemOpcional.fromMap(e))
              .toList() ??
          [],
      adicionais: (map['adicionais'] as List?)
              ?.map((e) => DataItemAdicional.fromMap(e))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataItem.fromJson(String source) =>
      DataItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
