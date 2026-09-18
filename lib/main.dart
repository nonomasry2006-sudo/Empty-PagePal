import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'features/library/models/shelf_book_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters if you have them
  Hive.registerAdapter(ShelfBookModelAdapter());
  
  // Open the box
  await Hive.openBox<ShelfBookModel>('shelves');
  
  runApp(const BookReadingTrackerApp());
}