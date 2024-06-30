import 'dart:convert';

import 'data_item.dart';

class DataItemsOrder {
  final List<DataItem> cartList;
  
  const DataItemsOrder({
    this.cartList = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartList': cartList.map((x) => x.toMap()).toList(),
    };
  }

  factory DataItemsOrder.fromMap(Map<String, dynamic> map) {
    return DataItemsOrder(
      cartList: (map['cartList'] as List?)
              ?.map((e) => DataItem.fromMap(e))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataItemsOrder.fromJson(String source) =>
      DataItemsOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}
