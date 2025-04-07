# Bluetooth Device Finder

## Task Description
The **Bluetooth Device Finder** app is a mobile application designed to assist users in discovering and managing Bluetooth devices. It allows users to scan for nearby Bluetooth devices, connect to them, and disconnect when needed, with real-time updates on the device status. The app also logs key actions and events for troubleshooting or monitoring purposes.

## Main Features
1. **Device Scanning**  
   The application scans and displays a list of available Bluetooth devices in the vicinity.
   
2. **Device Connection**  
   Users can tap on a device in the list to establish a connection.

3. **Device Disconnection**  
   Re-clicking the same device in the list will disconnect it and update the list of available devices.
   
4. **Event Logging**  
   Important events, such as device connections and disconnections, are logged to a text file stored on the phone's local storage.

5. **Proximity Notification**  
   The app provides visual feedback on the proximity to the connected device, using color-coded indicators:

## Project Structure

The project follows a clean architecture to separate concerns and enhance maintainability. Below is an overview of the main directories and files in the project.

### Root Directory

- `lib/`  
  This is the main directory for the Flutter application code.

### `lib/`

- **`app.dart`**  
  The entry point of the application where the app’s root widget is defined.

- **`core/`**  
  Contains reusable components like services and utilities.

  - **`log_service.dart`**  
    A service responsible for logging important events, such as device connections, disconnections, and errors. It logs these events to a text file stored in the device's local storage.

  - **`theme/`**  
    This directory contains files related to the app’s theme.

    - **`theme_cubit.dart`**  
      Manages the theme (light/dark mode) of the app using the `Cubit` pattern from `flutter_bloc`.

- **`data/`**  
  This directory contains data-related models and structures.

  - **`discovered_device.dart`**  
    Contains the model class `BluetoothDeviceInfo`, which holds the necessary information about each Bluetooth device, including its `rssi` value and connection state.

- **`features/`**  
  This directory organizes the app by features.

  - **`devices/`**  
    Contains all the code related to scanning and managing Bluetooth devices.

    - **`devices_bloc.dart`**  
      Implements the `DevicesBloc` for managing the Bluetooth device list and device connection states using the `flutter_bloc` pattern.

    - **`devices_event.dart`**  
      Contains the events related to Bluetooth device scanning and connection management.

    - **`devices_state.dart`**  
      Defines the states related to Bluetooth device management (e.g., loading, loaded, failure).

    - **`device_card.dart`**  
      A widget that represents each Bluetooth device in the list with relevant information (name, RSSI, connection status).

    - **`devices_list_screen.dart`**  
      The main screen of the app that displays the list of available Bluetooth devices and allows users to connect or disconnect from them.

### `pubspec.yaml`

- This file contains all the dependencies required by the project, such as `flutter_bloc`, `flutter_blue_plus`, and `permissions`. It also includes configurations for assets and other settings.

## Summary

The project follows a modular and organized structure to separate concerns and enhance maintainability. It uses Flutter’s modern tools like `flutter_bloc` for state management and organizes the code into logical directories, making it easier to scale and maintain in the future.
