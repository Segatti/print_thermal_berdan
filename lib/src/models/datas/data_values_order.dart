import 'dart:convert';

class DataValuesOrder {
  final num subtotal;
  final num deliveryFee;
  final num discount;
  final num priceTotal;
  final String paymentForm;

  const DataValuesOrder({
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    this.priceTotal = 0,
    this.paymentForm = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'priceTotal': priceTotal,
      'paymentForm': paymentForm,
    };
  }

  factory DataValuesOrder.fromMap(Map<String, dynamic> map) {
    return DataValuesOrder(
      subtotal: map['subtotal'] ?? 0,
      deliveryFee: map['deliveryFee'] ?? 0,
      discount: map['discount'] ?? 0,
      priceTotal: map['priceTotal'] ?? 0,
      paymentForm: map['paymentForm'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DataValuesOrder.fromJson(String source) =>
      DataValuesOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}
