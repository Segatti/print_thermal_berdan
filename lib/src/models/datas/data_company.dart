import 'dart:convert';

class DataCompany {
  final String name;
  final String cnpj;
  final String address;
  final String phone;

  const DataCompany({
    this.name = "",
    this.cnpj = "",
    this.address = "",
    this.phone = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entName': name,
      'cnpj': cnpj,
      'entFullAddress': address,
      'entWhatsapp': phone,
    };
  }

  factory DataCompany.fromMap(Map<String, dynamic> map) {
    return DataCompany(
      name: map['entName'] ?? "",
      cnpj: map['cnpj'] ?? "",
      address: map['entFullAddress'] ?? "",
      phone: map['entWhatsapp'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DataCompany.fromJson(String source) => DataCompany.fromMap(json.decode(source) as Map<String, dynamic>);
}
