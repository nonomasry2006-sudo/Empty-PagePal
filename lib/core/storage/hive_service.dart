import 'package:hive_flutter/hive_flutter.dart';
import '../../features/library/models/shelf_book_model.dart';
// Note: Verify this path correctly points to the frozen BookModel
import '../../features/explore/models/book_model.dart'; 

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register all adapters here
    Hive.registerAdapter(ShelfStatusAdapter());
    Hive.registerAdapter(BookModelAdapter()); // <-- Added BookModel
    Hive.registerAdapter(ShelfBookModelAdapter());
    
    await Hive.openBox<ShelfBookModel>('shelves');
  }
}