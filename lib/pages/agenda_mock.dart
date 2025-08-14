import 'package:flutter/material.dart';

class AgendaMock extends StatelessWidget {
  final List<Map<String, dynamic>> horarios = [
    {"inicio": "09:00", "fim": "09:30", "status": "livre"},
    {
      "inicio": "09:30",
      "fim": "10:30",
      "status": "agendado",
      "cliente": "Bruno",
    },
    {"inicio": "10:30", "fim": "11:00", "status": "livre"},
    {
      "inicio": "11:00",
      "fim": "12:00",
      "status": "agendado",
      "cliente": "Maria",
    },
    {
      "inicio": "14:00",
      "fim": "15:30",
      "status": "agendado",
      "cliente": "Carlos",
    },
    {"inicio": "15:30", "fim": "16:00", "status": "livre"},
  ];

  AgendaMock({super.key});

  double _calcularAltura(String inicio, String fim) {
    final fmt = (s) {
      final parts = s.split(":");
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    };
    return (fmt(fim) - fmt(inicio)).toDouble(); // altura proporcional em px
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: horarios.map((h) {
        final altura = _calcularAltura(h["inicio"], h["fim"]);
        final isLivre = h["status"] == "livre";
        final cor = isLivre ? Colors.green[300] : Colors.red[300];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          height: altura,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${h["inicio"]} - ${h["fim"]}",
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                isLivre ? "Disponível" : "Agendado: ${h["cliente"]}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Icon(
                isLivre ? Icons.add : Icons.cancel,
                color: isLivre ? Colors.green : Colors.red,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
