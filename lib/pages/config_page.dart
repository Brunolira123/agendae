import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final nomeController = TextEditingController(text: "João Profissional");
  final telefoneController = TextEditingController(text: "(11) 99999-9999");
  final enderecoController = TextEditingController(
    text: "Rua Exemplo, 123 - Centro",
  );

  bool notificacoes = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(labelText: "Telefone"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: enderecoController,
              decoration: const InputDecoration(labelText: "Endereço"),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              value: notificacoes,
              onChanged: (val) {
                setState(() => notificacoes = val);
              },
              title: const Text("Receber notificações"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aqui depois vamos salvar no banco
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Configurações salvas!")),
                );
              },
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
