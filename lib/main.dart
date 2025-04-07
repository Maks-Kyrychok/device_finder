import 'package:flutter/material.dart';

import 'app.dart';
import 'core/log_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LogService.init();
  runApp(App());
}
