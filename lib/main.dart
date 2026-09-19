import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/storage/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.deleteBoxFromDisk('shelves');

  await HiveService.init();

  final box = HiveService.shelves;
  print('STARTUP: box has ${box.length} items');

  runApp(const BookReadingTrackerApp());
}