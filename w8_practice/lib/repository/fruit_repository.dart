import 'package:w8_practice/model/fruit.dart';

abstract class FruitRepository {
  Future<Fruit> addFruit({required String name, required double price});
  Future<List<Fruit>> getFruits();
  Future<void> removeFruit(String id);
  Future<void> updateFruit(Fruit fruit);
}