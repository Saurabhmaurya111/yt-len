import 'package:flutter/material.dart';
import 'package:last_moment/core/sharing/share_intent_listener.dart';
import 'package:last_moment/core/theme/app_theme.dart';
import 'package:last_moment/features/auth/presentation/auth_gate.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ShareIntentListener(
      navigatorKey: _navigatorKey,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'YT Len',
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}
