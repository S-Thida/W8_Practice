// REPOSITORY
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:w8_practice/repository/firebase_repo/firebase_fruit_repository.dart';
import 'package:w8_practice/repository/fruit_repository.dart';
import 'package:w8_practice/screen/app_screen.dart';
import 'package:w8_practice/screen/provider/fruit_provider.dart';

import 'screen/provider/async_value.dart';

// 5 - MAIN
void main() async {
  // 1 - Create repository
  final FruitRepository fruitRepository = FirebaseFruitRepository();

  // 2-  Run app
  runApp(
    ChangeNotifierProvider(
      create: (context) => FruitProvider(fruitRepository),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: const AppScreen()),
    ),
  );
}
