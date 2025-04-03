// lib/repository/firebase_repo/firebase_fruit_repository.dart
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../../dto/fruit_dto.dart';
import '../../model/fruit.dart';
import '../fruit_repository.dart';

class FirebaseFruitRepository implements FruitRepository {
  static const String baseUrl = 'https://w8-practice-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String fruitsCollection = "fruit";
  static const String allFruitsUrl = '$baseUrl/$fruitsCollection.json';

  @override
  Future<Fruit> addFruit({required String name,required double price}) async {
    final response = await http.post(
      Uri.parse(allFruitsUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'price': price}),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add fruit');
    }

    final newId = json.decode(response.body)['name'];
    return Fruit(id: newId, name: name, price: price);
  }

  @override
  Future<List<Fruit>> getFruits() async {
    final response = await http.get(Uri.parse(allFruitsUrl));

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load fruits');
    }

    final data = json.decode(response.body) as Map<String, dynamic>?;
    return data?.entries.map((e) => FruitDto.fromJson(e.key, e.value)).toList() ?? [];
  }

  @override
  Future<void> removeFruit(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$fruitsCollection/$id.json'));
    
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to delete fruit');
    }
  }

  @override
  Future<void> updateFruit(Fruit fruit) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$fruitsCollection/${fruit.id}.json'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(FruitDto.toJson(fruit)),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to update fruit');
    }
  }
}