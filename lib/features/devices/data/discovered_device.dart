import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceInfo {
  final BluetoothDevice device;
  final int rssi;

  BluetoothDeviceInfo({required this.device, required this.rssi});
}
