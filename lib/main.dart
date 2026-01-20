import 'package:flutter/widgets.dart';
import 'package:sotamiz/src/core/app/app.dart';
import 'package:sotamiz/src/core/service/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService.initialize();
  runApp(const App());
}
