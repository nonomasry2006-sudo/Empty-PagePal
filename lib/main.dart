import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/storage/hive_service.dart'; // Adjust path to your hive_service if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Call your centralized service to handle all Hive setup
  await HiveService.init();

  runApp(const BookReadingTrackerApp());
}