import 'package:agendae/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'pages/agenda_page.dart';
import 'pages/servicos_page.dart';
import 'pages/config_page.dart';
import 'pages/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('pt_BR', null);
  runApp(const AgendaEApp());
}

class AgendaEApp extends StatelessWidget {
  const AgendaEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgendaE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
