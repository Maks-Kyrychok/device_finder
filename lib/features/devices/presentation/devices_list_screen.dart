import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_cubit.dart';
import '../bloc/devices_bloc.dart';
import 'device_card.dart';

class DevicesListScreen extends StatelessWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DevicesBloc()..add(LoadDevices()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("BLE Devices"),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ],
        ),
        body: DevicesListBody(),
      ),
    );
  }
}

class DevicesListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DevicesBloc, DevicesState>(
      listener: (context, state) {
        if (state is DevicesFailure) {
          _showErrorSnackBar(context, state.errorMessage);
        }
      },
      child: BlocBuilder<DevicesBloc, DevicesState>(
        builder: (context, state) {
          if (state is DevicesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DevicesFailure) {
            return DevicesFailureState();
          }

          if (state is DevicesLoaded) {
            return DevicesList(state: state);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $errorMessage'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class DevicesFailureState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Failed to load devices'),
          ElevatedButton(
            onPressed: () {
              context.read<DevicesBloc>().add(LoadDevices());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class DevicesList extends StatelessWidget {
  final DevicesLoaded state;

  const DevicesList({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DevicesBloc>().add(LoadDevices());
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.devices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final device = state.devices[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DeviceCard(deviceInfo: device),
          );
        },
      ),
    );
  }
}