part of 'devices_bloc.dart';

sealed class DevicesState extends Equatable {}

final class DevicesInitial extends DevicesState {
  @override
  List<Object?> get props => [];
}

final class DevicesLoading extends DevicesState {
  @override
  List<Object?> get props => [];
}

final class DevicesLoaded extends DevicesState {
  final List<BluetoothDeviceInfo> devices;

  DevicesLoaded({required this.devices});

  @override
  List<Object?> get props => [devices];
}

final class DevicesFailure extends DevicesState {
  final Object? exception;
  final String errorMessage;

  DevicesFailure({required this.exception, required this.errorMessage});

  @override
  List<Object?> get props => [exception, errorMessage];
}
