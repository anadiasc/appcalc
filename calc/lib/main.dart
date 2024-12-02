import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraJurosApp());
}


/// Widget principal do aplicativo
/// Configura o tema e inicializa a página principal
class CalculadoraJurosApp extends StatelessWidget {
  const CalculadoraJurosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculadoraJurosPage(),
    );
  }
}

/// Página principal para entrada dos dados do usuário
class CalculadoraJurosPage extends StatefulWidget {
  const CalculadoraJurosPage({Key? key}) : super(key: key);

  @override
  State<CalculadoraJurosPage> createState() => _CalculadoraJurosPageState();
}

/// Estado da página principal
class _CalculadoraJurosPageState extends State<CalculadoraJurosPage> {
   // Controladores para capturar os valores digitados nos campos de texto
  final TextEditingController _capitalInvest1Controller = TextEditingController();
  final TextEditingController _aplicacaoInvest1Controller = TextEditingController();
  final TextEditingController _taxaJurosInvest1Controller = TextEditingController();
  final TextEditingController _capitalInvest2Controller = TextEditingController();
  final TextEditingController _aplicacaoInvest2Controller = TextEditingController();
  final TextEditingController _taxaJurosInvest2Controller = TextEditingController();
  final TextEditingController _mesesController = TextEditingController();

  /// Exibe um alerta genérico na tela
  /// Utilizado para avisar sobre erros ou campos obrigatórios
  void _mostrarAlerta(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Realiza os cálculos e navega para a página de resultados
  /// Verifica se todos os campos estão preenchidos antes de calcular
  void _calcularEComparar() {
    if (_capitalInvest1Controller.text.isEmpty ||
        _aplicacaoInvest1Controller.text.isEmpty ||
        _taxaJurosInvest1Controller.text.isEmpty ||
        _capitalInvest2Controller.text.isEmpty ||
        _aplicacaoInvest2Controller.text.isEmpty ||
        _taxaJurosInvest2Controller.text.isEmpty ||
        _mesesController.text.isEmpty) {
      _mostrarAlerta('Por favor, preencha todos os campos!');
      return;
    }

    // Captura os valores de entrada e converte para o tipo necessário (double)
    double capital1 = double.parse(_capitalInvest1Controller.text);
    double aplicacao1 = double.parse(_aplicacaoInvest1Controller.text);
    double taxaJuros1 = double.parse(_taxaJurosInvest1Controller.text) / 100;
    double capital2 = double.parse(_capitalInvest2Controller.text);
    double aplicacao2 = double.parse(_aplicacaoInvest2Controller.text);
    double taxaJuros2 = double.parse(_taxaJurosInvest2Controller.text) / 100;
    int meses = int.parse(_mesesController.text);

    // Inicializa os detalhes e resultados dos cálculos
    List<String> detalhes1 = [];
    List<String> detalhes2 = [];
    double rendimentoTotal1 = 0.0, rendimentoTotal2 = 0.0;
     
     // Itera pelos meses e calcula os rendimentos para cada investimento
    for (int i = 1; i <= meses; i++) {
      double rendimentoMensal1 = capital1 * taxaJuros1;
      double rendimentoMensal2 = capital2 * taxaJuros2;
      rendimentoTotal1 += rendimentoMensal1;
      rendimentoTotal2 += rendimentoMensal2;
      capital1 += rendimentoMensal1 + aplicacao1;
      capital2 += rendimentoMensal2 + aplicacao2;
      
      // Adiciona os detalhes de cada mês
      detalhes1.add("Mês $i: R\$ ${capital1.toStringAsFixed(2)}");
      detalhes2.add("Mês $i: R\$ ${capital2.toStringAsFixed(2)}");
    }

    // Navega para a tela de resultados com os dados calculados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadosPage(
          montanteFinal1: capital1,
          rendimentoTotal1: rendimentoTotal1,
          detalhes1: detalhes1,
          montanteFinal2: capital2,
          rendimentoTotal2: rendimentoTotal2,
          detalhes2: detalhes2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparação de Investimentos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Campos de entrada para Investimento 1
              _campoTexto(controller: _capitalInvest1Controller, label: 'Investimento 1: Capital inicial (R\$)'),
              _campoTexto(controller: _aplicacaoInvest1Controller, label: 'Investimento 1: Aplicação mensal (R\$)'),
              _campoTexto(controller: _taxaJurosInvest1Controller, label: 'Investimento 1: Taxa de juros (%)'),
              const Divider(),

              // Campos de entrada para Investimento 2
              _campoTexto(controller: _capitalInvest2Controller, label: 'Investimento 2: Capital inicial (R\$)'),
              _campoTexto(controller: _aplicacaoInvest2Controller, label: 'Investimento 2: Aplicação mensal (R\$)'),
              _campoTexto(controller: _taxaJurosInvest2Controller, label: 'Investimento 2: Taxa de juros (%)'),
              const Divider(),

              // Campo para o período de meses
              _campoTexto(controller: _mesesController, label: 'Período em meses'),

               // Botão para calcular
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _calcularEComparar, // Chama a função de cálculo
                  child: const Text('Comparar Investimentos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Widget reutilizável para criar campos de texto
  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// Tela que exibe os resultados da comparação dos dois investimentos
class ResultadosPage extends StatelessWidget {
  // Valores finais e detalhes dos investimentos, recebidos como parâmetros
  final double montanteFinal1; // Montante final do investimento 1
  final double rendimentoTotal1; // Rendimento total do investimento 1
  final List<String> detalhes1; // Detalhes mês a mês do investimento 1
  final double montanteFinal2; // Montante final do investimento 2
  final double rendimentoTotal2; // Rendimento total do investimento 2
  final List<String> detalhes2; // Detalhes mês a mês do investimento 2

  /// Construtor que inicializa os parâmetros obrigatórios da página
  const ResultadosPage({
    Key? key,
    required this.montanteFinal1,
    required this.rendimentoTotal1,
    required this.detalhes1,
    required this.montanteFinal2,
    required this.rendimentoTotal2,
    required this.detalhes2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Comparação'), // Título da página
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margem para o conteúdo da página
        child: Column(
          children: [
            // Exibe os resultados finais de ambos os investimentos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Espaço uniforme entre os cards
              children: [
                _cardResultado(
                  label: 'Investimento 1', // Título do primeiro card
                  montanteFinal: montanteFinal1, // Valor final do investimento 1
                  rendimentoTotal: rendimentoTotal1, // Rendimento total do investimento 1
                ),
                _cardResultado(
                  label: 'Investimento 2', // Título do segundo card
                  montanteFinal: montanteFinal2, // Valor final do investimento 2
                  rendimentoTotal: rendimentoTotal2, // Rendimento total do investimento 2
                ),
              ],
            ),
            const Divider(), // Linha divisória para separação visual
            Expanded(
              // Exibe os detalhes mês a mês de cada investimento em uma lista
              child: ListView.builder(
                itemCount: detalhes1.length, // Número de itens na lista (mês a mês)
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Mês ${index + 1}'), // Título do item (mês atual)
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaçamento entre os textos
                      children: [
                        Text(detalhes1[index]), // Detalhes do investimento 1
                        Text(detalhes2[index]), // Detalhes do investimento 2
                      ],
                    ),
                  );
                },
              ),
            ),
            // Botão para voltar à tela anterior e refazer a simulação
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Volta à tela de entrada de dados
              child: const Text('Refazer Simulação'), // Texto do botão
            ),
          ],
        ),
      ),
    );
  }

  /// Cria um card para exibir os dados finais de cada investimento
  Widget _cardResultado({
    required String label, // Título do card
    required double montanteFinal, // Montante final a ser exibido
    required double rendimentoTotal, // Rendimento total a ser exibido
  }) {
    return Column(
      children: [
        // Título do card com estilo em negrito
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        // Exibe o montante final formatado como moeda
        Text('Montante: R\$ ${montanteFinal.toStringAsFixed(2)}'),
        // Exibe o rendimento total formatado como moeda
        Text('Rendimento: R\$ ${rendimentoTotal.toStringAsFixed(2)}'),
      ],
    );
  }
}
