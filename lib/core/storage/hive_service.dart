import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();
    // Register adapters in feature models.
  }
}
