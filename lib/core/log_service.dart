import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class LogService {
  static File? _logFile;

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final logPath = '${directory.path}/ble_logs.txt';
    _logFile = File(logPath);
    if (!(await _logFile!.exists())) {
      await _logFile!.create();
    }
  }

  static Future<void> log(String message) async {
    if (_logFile == null) await init();

    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final formatted = "[$timestamp] $message\n";

    await _logFile!.writeAsString(formatted, mode: FileMode.append, flush: true);
  }

  static Future<String> getLogPath() async {
    if (_logFile == null) await init();
    return _logFile!.path;
  }
}