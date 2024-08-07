import 'dart:convert';

class DataValuesOrder {
  final num subtotal;
  final num deliveryFee;
  final num discount;
  final num priceTotal;
  final String paymentMethod;
  final bool isPaid;

  const DataValuesOrder({
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    this.priceTotal = 0,
    this.paymentMethod = "",
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': priceTotal,
      'paymentMethod': paymentMethod,
      'paid': isPaid,
    };
  }

  factory DataValuesOrder.fromMap(Map<String, dynamic> map) {
    return DataValuesOrder(
      subtotal: map['subtotal'] ?? 0,
      deliveryFee: map['deliveryFee'] ?? 0,
      discount: map['discount'] ?? 0,
      priceTotal: map['total'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? "",
      isPaid: map['paid'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataValuesOrder.fromJson(String source) =>
      DataValuesOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}
