import 'package:hive_flutter/hive_flutter.dart';
import '../../features/library/models/shelf_book_model.dart';

class HiveService {
  HiveService._();

  static const String shelvesBox = 'shelves';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ShelfStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ShelfBookModelAdapter());
    }

    await Hive.openBox<ShelfBookModel>(shelvesBox);
  }

  static Box<ShelfBookModel> get shelves => Hive.box<ShelfBookModel>(shelvesBox);
}