import 'dart:convert';

import 'package:print_thermal_berdan/src/models/datas/data_company.dart';
import 'package:print_thermal_berdan/src/models/datas/data_customer.dart';
import 'package:print_thermal_berdan/src/models/datas/data_items_order.dart';
import 'package:print_thermal_berdan/src/models/datas/data_order.dart';
import 'package:print_thermal_berdan/src/models/datas/data_values_order.dart';

class OrderReceipt {
  final DataCompany company;
  final DataCustomer customer;
  final DataOrder order;
  final DataItemsOrder itemsOrder;
  final DataValuesOrder valuesOrder;
  
  const OrderReceipt({
    this.company = const DataCompany(),
    this.customer = const DataCustomer(),
    this.order = const DataOrder(),
    this.itemsOrder = const DataItemsOrder(),
    this.valuesOrder = const DataValuesOrder(),
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...company.toMap(),
      ...customer.toMap(),
      ...order.toMap(),
      ...itemsOrder.toMap(),
      ...valuesOrder.toMap(),
    };
  }

  factory OrderReceipt.fromMap(Map<String, dynamic> map) {
    return OrderReceipt(
      company: DataCompany.fromMap(map),
      customer: DataCustomer.fromMap(map),
      order: DataOrder.fromMap(map),
      itemsOrder: DataItemsOrder.fromMap(map),
      valuesOrder: DataValuesOrder.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderReceipt.fromJson(String source) =>
      OrderReceipt.fromMap(json.decode(source) as Map<String, dynamic>);
}
