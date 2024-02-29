import 'package:flutter/material.dart';
import 'package:yu_lost_item/config/api.dart';
import 'package:yu_lost_item/screens/login_page.dart';

void main() {
  getEnv();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
