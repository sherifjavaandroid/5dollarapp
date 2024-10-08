// main.dart
import 'package:dollarapp/repository/ompany_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/bloc/company_bloc.dart';
import 'ui/company_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyBloc(
        repository: CompanyRepository(),
      ),
      child: MaterialApp(
        title: 'Company App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const CompanyPage(),
      ),
    );
  }
}