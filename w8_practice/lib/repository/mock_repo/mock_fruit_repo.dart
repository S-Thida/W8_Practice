// lib/repository/mock_repo/mock_fruit_repository.dart
import '../../model/fruit.dart';
import '../fruit_repository.dart';

class MockFruitRepository implements FruitRepository {
  final List<Fruit> _fruits = [];

  @override
  Future<Fruit> addFruit({required String name,required double price}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newFruit = Fruit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
    );
    _fruits.add(newFruit);
    return newFruit;
  }

  @override
  Future<List<Fruit>> getFruits() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _fruits;
  }

  @override
  Future<void> removeFruit(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fruits.removeWhere((fruit) => fruit.id == id);
  }

  @override
  Future<void> updateFruit(Fruit fruit) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _fruits.indexWhere((f) => f.id == fruit.id);
    if (index != -1) {
      _fruits[index] = fruit;
    }
  }
}