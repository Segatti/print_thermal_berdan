import 'dart:convert';

class DataCustomer {
  final String name;
  final String? instructions;
  final String address;
  final String phone;

  const DataCustomer({
    this.name = "",
    this.instructions,
    this.address = "",
    this.phone = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cName': name,
      'deliveryInstructions': instructions,
      'deliveryFullAddress': address,
      'phone': phone,
    };
  }

  factory DataCustomer.fromMap(Map<String, dynamic> map) {
    return DataCustomer(
      name: map['cName'] ?? "",
      instructions: map['deliveryInstructions'],
      address: map['deliveryFullAddress'] ?? "",
      phone: map['phone'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DataCustomer.fromJson(String source) => DataCustomer.fromMap(json.decode(source) as Map<String, dynamic>);
}
