import 'package:hive_flutter/hive_flutter.dart';
import '../../features/library/models/shelf_book_model.dart';

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(ShelfStatusAdapter());
    Hive.registerAdapter(ShelfBookModelAdapter());
    await Hive.openBox<ShelfBookModel>('shelves');
  }
}