import 'dart:io';

void main() {
  stdout.write('Enter your Flutter app class name (e.g. MyApp): ');
  String? appName = stdin.readLineSync();

  if (appName == null || appName.trim().isEmpty) {
    print('❌ App name cannot be empty. Exiting.');
    return;
  }
  if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(appName)) {
    print('❌ Invalid app name. Use only letters, numbers, and underscores.');
    return;
  }
  appName = appName.trim();

  // Directories to create
  final directories = [
    'lib/core/constants',
    'lib/core/network',
    'lib/core/services',
    'lib/core/di',
    'lib/features/auth/presentation',
    'lib/features/home/presentation',
    'lib/shared/widgets',
    'assets/images',
    'assets/fonts',
    'lib/core/helpers',
  ];

  for (var dir in directories) {
    final directory = Directory(dir);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
      print('✅ Created folder: $dir');
    }
  }

  // Empty placeholder files
  final emptyFiles = [
    'lib/core/helpers/extensions.dart',
    'lib/shared/widgets/custom_button.dart',
  ];

  for (var path in emptyFiles) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      print('📄 Created empty file: $path');
    }
  }

  // Write main.dart and app.dart with appName
  File('lib/main.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const $appName());
}
''');

  File('test/widget_test.dart').writeAsStringSync('''
import 'package:flutter_test/flutter_test.dart';

import 'package:${appName.toLowerCase()}/app.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const $appName());
    expect(find.byType($appName), findsOneWidget);
  });
}
''');

  File('lib/app.dart').writeAsStringSync('''
import 'package:flutter/material.dart';

class $appName extends StatelessWidget {
  const $appName({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$appName Starter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: const Center(child: Text('Hello, Flutter!')),
      ),
    );
  }
}
''');

  // App constants
  File('lib/core/constants/app_constants.dart').writeAsStringSync('''
/// This file contains application-wide constants
class AppConstants {
  static const String baseUrl = "https://api.example.com/";
}
''');

  // ApiService placeholderservice_locator
  File('lib/core/network/api_service.dart').writeAsStringSync('''
/// Placeholder for API service class
/// Add your API calls and networking logic here
class ApiService {
  // Future<void> fetchData() async {}
}
''');

  // Simple login screen
  File('lib/features/auth/presentation/login_screen.dart').writeAsStringSync('''
import 'package:flutter/material.dart';

/// Simple Login Screen placeholder
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Login Screen"),
      ),
    );
  }
}
''');

  // Dependency Injection service locator example
  File('lib/core/di/service_locator.dart').writeAsStringSync('''
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register your services here, e.g.:
  // getIt.registerLazySingleton<ApiService>(() => ApiService());
}
''');

  // pubspec.yaml with flutter_native_splash and other basics
  File('pubspec.yaml').writeAsStringSync('''
name: ${appName.toLowerCase()}
description: A new Flutter project created with custom scaffold script.
publish_to: 'none' # Remove this line if publishing to pub.dev

environment:
  sdk: ">=2.19.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_native_splash: ^2.4.6
  get_it: ^7.6.1

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/fonts/
''');

  print(
      '\n🚀 Flutter base project structure with pubspec.yaml and DI created successfully for app: $appName!');
}
