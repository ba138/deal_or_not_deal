import 'package:deal_or_not_deal/pages/FirstPage/first_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:window_manager/window_manager.dart';
import 'package:logging/logging.dart';

void main() async {
  // Ensure all bindings are initialized before using window_manager
  WidgetsFlutterBinding.ensureInitialized();
  _setupLogging();
  // Initialize the window_manager
  await windowManager.ensureInitialized();

  // Set window options
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1400, 700), // Set a fixed size for the window
    center: true, // Center the window on the screen
    backgroundColor: Colors.transparent,
    title: 'DEAL OR NOT DEAL',
    fullScreen: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

void _setupLogging() {
  // Set the logging level to capture all logs
  Logger.root.level = Level.ALL; // Capture all log levels
  Logger.root.onRecord.listen((record) {
    // Print logs to console
    print(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      print('StackTrace: ${record.stackTrace}');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DEAL OR NOT DEAL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // Set the overall theme to dark
        scaffoldBackgroundColor:
            Colors.black, // Set Scaffold background color to dark
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
          surface: Colors.grey[900]!,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.white), // Ensure text is visible on dark background
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const FirstPage(),
    );
  }
}
