// lib/screens/provider/fruit_provider.dart
import 'package:flutter/material.dart';
import 'package:w8_practice/screen/provider/async_value.dart';

import '../../dto/fruit_dto.dart';
import '../../model/fruit.dart';
import '../../repository/fruit_repository.dart';
import 'package:provider/provider.dart';

class FruitProvider extends ChangeNotifier {
  final FruitRepository _repository;
  AsyncValue<List<Fruit>>? fruitsState;

  FruitProvider(this._repository) {
    fetchFruits();
  }

  bool get isLoading => fruitsState?.state == AsyncValueState.loading;
  bool get hasData => fruitsState?.state == AsyncValueState.success;

  Future<void> fetchFruits() async {
    try {
      fruitsState = AsyncValue.loading();
      notifyListeners();

      fruitsState = AsyncValue.success(await _repository.getFruits());
    } catch (error) {
      fruitsState = AsyncValue.error(error);
    }
    notifyListeners();
  }

  Future<void> addFruit(String name, double price) async {
    final tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
    final newFruit = Fruit(id: tempId, name: name ,price: price);

    if (fruitsState?.state == AsyncValueState.success) {
      fruitsState = AsyncValue.success([...fruitsState!.data!, newFruit]);
      notifyListeners();
    }

    try {
      final addedFruit = await _repository.addFruit(name: name, price: price);
      
      if (fruitsState?.state == AsyncValueState.success) {
        final updatedList = fruitsState!.data!
          .where((fruit) => fruit.id != tempId)
          .toList()
          ..add(addedFruit);
        
        fruitsState = AsyncValue.success(updatedList);
        notifyListeners();
      }
    } catch (error) {
      if (fruitsState?.state == AsyncValueState.success) {
        fruitsState = AsyncValue.success(
          fruitsState!.data!.where((fruit) => fruit.id != tempId).toList()
        );
        notifyListeners();
      }
      rethrow;
    }
  }

  Future<void> removeFruit(String id) async {
    Fruit? removedFruit;
    if (fruitsState?.state == AsyncValueState.success) {
      removedFruit = fruitsState!.data!.firstWhere((fruit) => fruit.id == id);
      fruitsState = AsyncValue.success(
        fruitsState!.data!.where((fruit) => fruit.id != id).toList()
      );
      notifyListeners();
    }

    try {
      await _repository.removeFruit(id);
    } catch (error) {
      if (removedFruit != null && fruitsState?.state == AsyncValueState.success) {
        fruitsState = AsyncValue.success([...fruitsState!.data!, removedFruit]);
        notifyListeners();
      }
      rethrow;
    }
  }

  Future<void> updateFruit(Fruit fruit) async {
    final oldFruit = fruitsState?.data?.firstWhere((f) => f.id == fruit.id);
    if (oldFruit != null && fruitsState?.state == AsyncValueState.success) {
      final updatedList = fruitsState!.data!
        .map((f) => f.id == fruit.id ? fruit : f)
        .toList();
      
      fruitsState = AsyncValue.success(updatedList);
      notifyListeners();
    }

    try {
      await _repository.updateFruit(fruit);
    } catch (error) {
      if (oldFruit != null && fruitsState?.state == AsyncValueState.success) {
        final rolledBackList = fruitsState!.data!
          .map((f) => f.id == oldFruit.id ? oldFruit : f)
          .toList();
        
        fruitsState = AsyncValue.success(rolledBackList);
        notifyListeners();
      }
      rethrow;
    }
  }
}