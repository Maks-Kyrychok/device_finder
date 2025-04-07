import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../bloc/devices_bloc.dart';
import '../data/discovered_device.dart';

class DeviceCard extends StatelessWidget {
  final BluetoothDeviceInfo deviceInfo;

  const DeviceCard({super.key, required this.deviceInfo});

  static const int rssiThreshold1 = -50;
  static const int rssiThreshold2 = -70;
  static const int rssiThreshold3 = -90;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(deviceInfo.device.remoteId.str, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (deviceInfo.device.platformName.isNotEmpty) _PlatformNameText(platformName: deviceInfo.device.platformName),
            const SizedBox(height: 4),
            _RssiText(rssi: deviceInfo.rssi),
          ],
        ),
        trailing: _ConnectionStatus(device: deviceInfo.device),
        onTap: () => context.read<DevicesBloc>().add(ChangeConnection(device: deviceInfo.device)),
      ),
    );
  }
}

class _RssiText extends StatelessWidget {
  final int rssi;

  const _RssiText({required this.rssi});

  @override
  Widget build(BuildContext context) {
    return Text(
      "RSSI: $rssi dBm",
      style: TextStyle(color: _rssiColor(rssi)),
    );
  }

  Color _rssiColor(int rssi) {
    if (rssi >= DeviceCard.rssiThreshold1) return Colors.green;
    if (rssi >= DeviceCard.rssiThreshold2) return Colors.orange;
    if (rssi >= DeviceCard.rssiThreshold3) return Colors.deepOrange;
    return Colors.red;
  }
}

class _PlatformNameText extends StatelessWidget {
  final String platformName;

  const _PlatformNameText({required this.platformName});

  @override
  Widget build(BuildContext context) {
    return Text("Platform: $platformName");
  }
}

class _ConnectionStatus extends StatelessWidget {
  final BluetoothDevice device;

  const _ConnectionStatus({required this.device});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          device.isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
          color: device.isConnected ? Colors.blue : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(device.isConnected ? "Connected" : "Disconnected"),
      ],
    );
  }
}