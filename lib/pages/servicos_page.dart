import 'package:flutter/material.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  List<Map<String, dynamic>> servicos = [
    {"nome": "Corte de cabelo", "preco": 50.0, "duracao": 30},
    {"nome": "Barba", "preco": 30.0, "duracao": 20},
  ];

  final nomeController = TextEditingController();
  final precoController = TextEditingController();
  final duracaoController = TextEditingController();

  void _adicionarServico() {
    if (nomeController.text.isEmpty ||
        precoController.text.isEmpty ||
        duracaoController.text.isEmpty)
      return;

    setState(() {
      servicos.add({
        "nome": nomeController.text,
        "preco": double.parse(precoController.text),
        "duracao": int.parse(duracaoController.text),
      });
    });

    nomeController.clear();
    precoController.clear();
    duracaoController.clear();

    Navigator.pop(context);
  }

  void _mostrarDialogoAdicionar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Novo Serviço"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: precoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Preço"),
            ),
            TextField(
              controller: duracaoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Duração (min)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: _adicionarServico,
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Serviços")),
      body: ListView.builder(
        itemCount: servicos.length,
        itemBuilder: (context, index) {
          final servico = servicos[index];
          return ListTile(
            leading: const Icon(Icons.build),
            title: Text(servico["nome"]),
            subtitle: Text(
              "R\$ ${servico["preco"].toStringAsFixed(2)} • ${servico["duracao"]} min",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  servicos.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}
