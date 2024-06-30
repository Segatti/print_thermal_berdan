import 'dart:convert';

class DataItemOpcional {
  final String opcional;
  final num? price;
  
  const DataItemOpcional({
    this.opcional = "",
    this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'opcional': opcional,
      'price': price,
    };
  }

  factory DataItemOpcional.fromMap(Map<String, dynamic> map) {
    return DataItemOpcional(
      opcional: map['opcional'] ?? "",
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataItemOpcional.fromJson(String source) => DataItemOpcional.fromMap(json.decode(source) as Map<String, dynamic>);
}
