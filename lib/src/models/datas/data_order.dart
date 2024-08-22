import 'dart:convert';

class DataOrder {
  final String deliveryType;
  final String origin;
  final String orderCode;
  final String logistics;

  const DataOrder({
    this.deliveryType = "",
    this.origin = "",
    this.orderCode = "",
    this.logistics = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deliveryType': deliveryType,
      'origin': origin,
      'orderCode': orderCode,
      'logistics': logistics,
    };
  }

  factory DataOrder.fromMap(Map<String, dynamic> map) {
    return DataOrder(
      deliveryType: map['deliveryType'] ?? "",
      origin: map['origin'] ?? "",
      orderCode: map['orderCode'] ?? "",
      logistics: map['logistics'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DataOrder.fromJson(String source) =>
      DataOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}
