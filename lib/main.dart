import 'package:flutter/material.dart';
import 'presentation/screens/auth_page.dart';
import 'presentation/themes/app_theme.dart';

void main() {
  runApp(ELAApp());
}

class ELAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELA - Your Ultimate Plant Companion',
      theme: AppTheme.lightTheme,
      home: AuthPage(),
    );
  }
}
