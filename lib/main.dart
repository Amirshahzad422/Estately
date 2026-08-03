import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'styles/app_theme.dart';
import 'layouts/main_layout.dart';
import 'screens/not_found_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const EstatelyApp(),
    ),
  );
}

class EstatelyApp extends StatelessWidget {
  const EstatelyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estately — Premium Real Estate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainLayout(),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
      },
    );
  }
}
