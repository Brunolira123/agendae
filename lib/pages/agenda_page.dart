import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AgendaScreen());
  }
}

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime selectedDate = DateTime.now();

  List<Map<String, dynamic>> eventos = [
    {
      "inicio": TimeOfDay(hour: 5, minute: 30),
      "fim": TimeOfDay(hour: 7, minute: 30),
      "titulo": "Camily",
      "descricao": "Escova e babyliss pré Wedding",
      "cor": Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final horas = List.generate(24 * 2, (index) {
      final hour = index ~/ 2;
      final minute = (index % 2) * 30;
      return TimeOfDay(hour: hour, minute: minute);
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.blue),
              onPressed: () {
                setState(() {
                  selectedDate = selectedDate.subtract(Duration(days: 1));
                });
              },
            ),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  locale: const Locale("pt", "BR"),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Column(
                children: [
                  Text(
                    DateFormat("dd MMM yyyy", "pt_BR").format(selectedDate),
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateFormat("EEEE", "pt_BR").format(selectedDate),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.blue),
              onPressed: () {
                setState(() {
                  selectedDate = selectedDate.add(Duration(days: 1));
                });
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: horas.map((hora) {
            final horaTexto =
                "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}";

            final evento = eventos.firstWhere(
              (e) =>
                  e["inicio"].hour == hora.hour &&
                  e["inicio"].minute == hora.minute,
              orElse: () => {},
            );

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    horaTexto,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: evento.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: evento["cor"],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${evento["inicio"].format(context)} - ${evento["fim"].format(context)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  evento["titulo"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  evento["descricao"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {},
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendário",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: "Filtros",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: "Ações"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Criar"),
        ],
      ),
    );
  }
}
