import 'package:w8_practice/model/fruit.dart';

class FruitDto {
  static Fruit fromJson(String id, Map<String, dynamic> json) {
    return Fruit(
      id: id,
      name: json['name'],
      price: json['price'],
    );
  }

  static Map<String, dynamic> toJson(Fruit fruit) {
    return {
      'name': fruit.name,
      'price': fruit.price,
    };
  }
}
