import 'package:deal_or_not_deal/pages/splash_page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:window_manager/window_manager.dart';

void main() async {
  // Ensure all bindings are initialized before using window_manager
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the window_manager
  await windowManager.ensureInitialized();

  // Set window options
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600), // Set a fixed size for the window
    center: true, // Center the window on the screen
    backgroundColor: Colors.transparent,
    title: 'DEAL OR NOT DEAL',
    fullScreen: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
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
      home: const SplashPage(),
    );
  }
}
