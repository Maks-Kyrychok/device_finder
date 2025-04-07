part of 'devices_bloc.dart';

sealed class DevicesEvent extends Equatable {}

final class LoadDevices extends DevicesEvent {
  @override
  List<Object?> get props => [];
}

final class _SetLoadedDevices extends DevicesEvent {
  _SetLoadedDevices(this.devices);

  final List<BluetoothDeviceInfo> devices;

  @override
  List<Object?> get props => [devices];
}

final class ChangeConnection extends DevicesEvent {
  final BluetoothDevice device;

  ChangeConnection({required this.device});

  @override
  List<Object?> get props => [];
}
