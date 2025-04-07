import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../core/log_service.dart';
import '../data/discovered_device.dart';

part 'devices_event.dart';

part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc() : super(DevicesInitial()) {
    on<LoadDevices>(_onLoad);
    on<_SetLoadedDevices>(_setLoadedDevices);
    on<ChangeConnection>(_onDeviceConnectionChanged);
  }

  StreamSubscription<List<ScanResult>>? _devicesSubscription;

  StreamSubscription<BluetoothConnectionState>? _deviceSubscription;

  Future<void> _onLoad(LoadDevices event, Emitter<DevicesState> emit) async {
    try {
      emit(DevicesLoading());
      final isSupportedBle = await FlutterBluePlus.isSupported;
      if (!isSupportedBle) {
        throw Exception('Bluetooth not supported by this device');
      }

      final bleState = await FlutterBluePlus.adapterState.first;

      if (bleState != BluetoothAdapterState.on) {
        throw Exception('Bluetooth off');
      }

      final Map<DeviceIdentifier, BluetoothDeviceInfo> devicesMap = {};
      _devicesSubscription?.cancel();
      _devicesSubscription = FlutterBluePlus.onScanResults.listen((results) async {
        for (final result in results) {
          final device = result.device;
          final rssi = result.rssi;

          if (!devicesMap.containsKey(device.remoteId)) {
            devicesMap[device.remoteId] = BluetoothDeviceInfo(device: device, rssi: rssi);
          }
        }

        final connectedDevices = FlutterBluePlus.connectedDevices;
        for (var device in connectedDevices) {
          if (!devicesMap.containsKey(device.remoteId)) {
            final deviceRssi = await device.readRssi(timeout: 5);
            devicesMap[device.remoteId] = BluetoothDeviceInfo(device: device, rssi: deviceRssi);
          }
        }

        add(_SetLoadedDevices(devicesMap.values.toList()));
      });

      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (exception, stackTrace) {
      _handleError(exception, stackTrace, emit, exception.toString());
    }
  }

  Future<void> _setLoadedDevices(_SetLoadedDevices event, Emitter<DevicesState> emit) async {
    emit(DevicesLoaded(devices: event.devices));
  }

  Future<void> _onDeviceConnectionChanged(ChangeConnection event, Emitter<DevicesState> emit) async {
    final device = event.device;
    emit(DevicesLoading());

    try {
      final currentState = await device.connectionState.first;

      if (currentState == BluetoothConnectionState.connected) {
        await _safeDisconnect(device, emit);
      } else {
        await _safeConnect(device, emit);
      }
      add(LoadDevices());
    } catch (exception, stackTrace) {
      _handleError(exception, stackTrace, emit, exception.toString());
    }
  }

  Future<void> _safeDisconnect(BluetoothDevice device, Emitter<DevicesState> emit) async {
    try {
      await device.disconnect();
      LogService.log('Disconnected from device: ${device.remoteId}');
    } catch (exception, stackTrace) {
      _handleError(exception, stackTrace, emit, 'Failed to disconnect from device ${device.remoteId}.');
    }
  }

  Future<void> _safeConnect(BluetoothDevice device, Emitter<DevicesState> emit) async {
    try {
      await device.connect();
      LogService.log('Connected to device: ${device.remoteId}');
    } catch (exception, stackTrace) {
      _handleError(exception, stackTrace, emit, 'Failed to connect to device ${device.remoteId}.');
    }
  }

  void _handleError(Object exception, StackTrace stackTrace, Emitter<DevicesState> emit, String errorMessage) {
    LogService.log('Error: $exception\n$stackTrace');
    emit(DevicesFailure(exception: exception, errorMessage: errorMessage));
    log('$exception\n$stackTrace');
  }

  @override
  Future<void> close() async {
    await _devicesSubscription?.cancel();
    await _deviceSubscription?.cancel();
    super.close();
  }
}
