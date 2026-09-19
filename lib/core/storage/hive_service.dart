import 'package:hive_flutter/hive_flutter.dart';

import '../../features/explore/models/book_model.dart';
import '../../features/library/models/shelf_book_model.dart';
import '../../features/sessions/models/note_model.dart';

class HiveService {
  HiveService._();

  static const String shelvesBox = 'shelves';
  static const String notesBox = 'notes';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ShelfBookModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ShelfStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BookModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(NoteModelAdapter());
    }

    // Open boxes
    await Hive.openBox<ShelfBookModel>(shelvesBox);
    await Hive.openBox<NoteModel>(notesBox);
  }

  static Box<ShelfBookModel> get shelves =>
      Hive.box<ShelfBookModel>(shelvesBox);

  static Box<NoteModel> get notes =>
      Hive.box<NoteModel>(notesBox);
}