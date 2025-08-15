import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'agenda_page.dart';
import 'servicos_page.dart';

enum UserRole { admin, profissional, recepcionista }

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UserRole roleAtual = UserRole.admin; // mude aqui pra testar os papéis
  String usuarioNome = "Bruno";

  // Mock de profissionais
  final List<Map<String, dynamic>> profissionais = [
    {
      "nome": "Ana Souza",
      "especialidade": "Coloração",
      "telefone": "11999990001",
      "role": UserRole.profissional,
      "ocupado": true,
    },
    {
      "nome": "Carlos Lima",
      "especialidade": "Barba",
      "telefone": "11999990002",
      "role": UserRole.profissional,
      "ocupado": false,
    },
    {
      "nome": "Marina Alves",
      "especialidade": "Corte Feminino",
      "telefone": "11999990003",
      "role": UserRole.profissional,
      "ocupado": true,
    },
  ];

  // Mock de próximos agendamentos (usados em todas as visões)
  final List<Map<String, String>> proximos = [
    {"nome": "Camily", "hora": "09:30", "servico": "Escova"},
    {"nome": "João", "hora": "10:15", "servico": "Corte Masculino"},
    {"nome": "Luana", "hora": "11:00", "servico": "Coloração"},
  ];

  @override
  Widget build(BuildContext context) {
    final dataAtual = DateFormat(
      "EEEE, dd MMM",
      "pt_BR",
    ).format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Selector de papel (só pra DEMO) — em produção vem do login
          PopupMenuButton<UserRole>(
            icon: const Icon(Icons.switch_account),
            onSelected: (v) => setState(() => roleAtual = v),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: UserRole.admin,
                child: Text("Entrar como Admin"),
              ),
              const PopupMenuItem(
                value: UserRole.profissional,
                child: Text("Entrar como Profissional"),
              ),
              const PopupMenuItem(
                value: UserRole.recepcionista,
                child: Text("Entrar como Recepcionista"),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue[700]),
            ),
          ),
        ],
      ),

      body: ListView(
        children: [
          // Saudação e data
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bom dia, $usuarioNome! 👋",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(dataAtual, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                // Navegação rápida por dias (setas)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dayPill(
                      icon: Icons.chevron_left,
                      onTap: () {
                        /* voltar um dia */
                      },
                    ),
                    const SizedBox(width: 12),
                    _dayPill(
                      text: "Hoje",
                      onTap: () {
                        /* ir para hoje */
                      },
                    ),
                    const SizedBox(width: 12),
                    _dayPill(
                      icon: Icons.chevron_right,
                      onTap: () {
                        /* avançar um dia */
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // PRÓXIMO CLIENTE (mostra em todos os papéis)
          _cardProximoCliente(),

          const SizedBox(height: 12),

          // QUICK ACTIONS (mostra em todos)
          _quickActions(context),

          const SizedBox(height: 12),

          // CONTEÚDO CONDICIONAL POR PAPEL
          if (roleAtual == UserRole.admin) ..._secaoAdmin(context),
          if (roleAtual == UserRole.profissional)
            ..._secaoProfissional(context),
          if (roleAtual == UserRole.recepcionista)
            ..._secaoRecepcionista(context),

          const SizedBox(height: 20),
        ],
      ),

      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ======== SEÇÕES POR PAPEL ========

  List<Widget> _secaoAdmin(BuildContext context) {
    final int totalSlots = 20; // ex: 20 meias-horas no dia útil
    final int ocupados = 12;
    final int livres = totalSlots - ocupados;

    final double receitaDia = 820.0;
    final double metaDia = 1500.0;

    return [
      // Resumo Financeiro (somente Admin)
      _cardResumoFinanceiro(receitaDia, metaDia),

      const SizedBox(height: 12),

      // Ocupação (livre x ocupado) com barras simples
      _cardOcupacao(ocupados: ocupados, livres: livres),

      const SizedBox(height: 12),

      // Profissionais + botão de cadastro
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Equipe",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => _abrirCadastroProfissional(context),
              icon: const Icon(Icons.person_add),
              label: const Text("Novo profissional"),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      _listaProfissionais(),
    ];
  }

  List<Widget> _secaoProfissional(BuildContext context) {
    // Receita do próprio profissional (mock)
    final double minhaReceitaHoje = 420.0;
    final double minhaMetaHoje = 800.0;

    return [
      _cardResumoFinanceiro(
        minhaReceitaHoje,
        minhaMetaHoje,
        titulo: "Sua Receita de Hoje",
      ),
      const SizedBox(height: 12),
      _listaProximos(), // minha agenda
    ];
  }

  List<Widget> _secaoRecepcionista(BuildContext context) {
    return [
      _listaProximos(),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                _actionChip(Icons.check_circle, "Confirmar presença", () {}),
                _actionChip(Icons.cancel, "Registrar cancelamento", () {}),
                _actionChip(Icons.sms, "Enviar lembretes", () {}),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  // ======== WIDGETS DE SEÇÃO ========

  Widget _cardProximoCliente() {
    // Pega o primeiro da lista de proximos
    final proximo = proximos.first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue[100],
                child: Text(
                  proximo["nome"]!.substring(0, 1),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Próximo Cliente",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      proximo["nome"]!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Horário: ${proximo["hora"]} • ${proximo["servico"]}"),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () {
                  /* ligar */
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.teal),
                onPressed: () {
                  /* WhatsApp */
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _quickAction(
                Icons.add_circle,
                "Novo Agendamento",
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AgendaScreen()),
                  );
                },
              ),
              _quickAction(Icons.build, "Novo Serviço", Colors.orange, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServicosPage()),
                );
              }),
              _quickAction(
                Icons.view_week,
                "Agenda Semanal",
                Colors.purple,
                () {
                  // abrir visão semanal
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _cardResumoFinanceiro(
    double receita,
    double meta, {
    String titulo = "Resumo Financeiro",
  }) {
    final porcentagem = (meta == 0) ? 0 : (receita / meta).clamp(0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: porcentagem.toDouble(),
                        minHeight: 8,
                        color: Colors.green,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "R\$ ${receita.toStringAsFixed(2)} de R\$ ${meta.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardOcupacao({required int ocupados, required int livres}) {
    final total = (ocupados + livres).clamp(1, 1000000);
    final pOcupado = ocupados / total;
    final pLivre = livres / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.event_available, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Ocupação do Dia",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _barraProporcional(
                      partes: [
                        _ParteBarra(valor: pOcupado, cor: Colors.blue),
                        _ParteBarra(valor: pLivre, cor: Colors.grey.shade300),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text("${(pOcupado * 100).toStringAsFixed(0)}%"),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _legendaQuadradinho(Colors.blue, "Ocupado ($ocupados)"),
                  const SizedBox(width: 12),
                  _legendaQuadradinho(Colors.grey, "Livre ($livres)"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _barraProporcional({required List<_ParteBarra> partes}) {
    return SizedBox(
      height: 14,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: partes
              .map(
                (p) => Expanded(
                  flex: (p.valor * 1000).round(), // proporcional
                  child: Container(color: p.cor),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _legendaQuadradinho(Color cor, String texto) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(texto, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
      ],
    );
  }

  Widget _listaProfissionais() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: profissionais.map((p) {
            final cor = p["ocupado"] ? Colors.red : Colors.green;
            final label = p["ocupado"] ? "Ocupado" : "Livre";
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(
                  p["nome"].toString().substring(0, 1),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              title: Text(p["nome"]),
              subtitle: Text("${p["especialidade"]} • ${p["telefone"]}"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: cor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () {
                // abrir detalhes do profissional / agenda individual
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _listaProximos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: proximos
              .map(
                (ag) => ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(ag["nome"]!),
                  subtitle: Text(ag["servico"]!),
                  trailing: Text(
                    ag["hora"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // ======== BOTTOM SHEET: CADASTRO DE PROFISSIONAL ========

  void _abrirCadastroProfissional(BuildContext context) {
    final nomeCtrl = TextEditingController();
    final telCtrl = TextEditingController();
    final espCtrl = TextEditingController();
    UserRole papel = UserRole.profissional;
    bool ocupado = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 8,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Novo Profissional",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: telCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Telefone",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: espCtrl,
                    decoration: const InputDecoration(
                      labelText: "Especialidade",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Papel: "),
                      const SizedBox(width: 8),
                      DropdownButton<UserRole>(
                        value: papel,
                        items: const [
                          DropdownMenuItem(
                            value: UserRole.profissional,
                            child: Text("Profissional"),
                          ),
                          DropdownMenuItem(
                            value: UserRole.recepcionista,
                            child: Text("Recepcionista"),
                          ),
                          DropdownMenuItem(
                            value: UserRole.admin,
                            child: Text("Admin"),
                          ),
                        ],
                        onChanged: (v) => setModalState(
                          () => papel = v ?? UserRole.profissional,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Text("Ocupado"),
                          Switch(
                            value: ocupado,
                            onChanged: (v) => setModalState(() => ocupado = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (nomeCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Informe o nome.")),
                          );
                          return;
                        }
                        setState(() {
                          profissionais.add({
                            "nome": nomeCtrl.text.trim(),
                            "especialidade": espCtrl.text.trim(),
                            "telefone": telCtrl.text.trim(),
                            "role": papel,
                            "ocupado": ocupado,
                          });
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profissional cadastrado!"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Salvar"),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ======== AUXILIARES ========

  Widget _dayPill({IconData? icon, String? text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: icon != null
            ? Icon(icon, color: Colors.white)
            : Text(
                text ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _actionChip(IconData icon, String label, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: Colors.blue),
      label: Text(label),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: Colors.blue.withOpacity(0.2)),
    );
  }

  BottomNavigationBar _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Agenda",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.build), label: "Serviços"),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          label: "Financeiro",
        ),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AgendaScreen()),
          );
        }
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ServicosPage()),
          );
        }
      },
    );
  }
}

class _ParteBarra {
  final double valor;
  final Color cor;
  _ParteBarra({required this.valor, required this.cor});
}
