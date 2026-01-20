import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import '../service/db_service.dart';
import 'app.dart';

final class AppRunner {
  Future<void> initializeAndRun() async {
    WidgetsFlutterBinding.ensureInitialized();

    await DBService.initialize();

    runApp(const App());
  }
}
