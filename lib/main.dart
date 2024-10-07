// main.dart
import 'package:flutter/material.dart';
import 'ui/company_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Company App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CompanyPage(),
    );
  }
}