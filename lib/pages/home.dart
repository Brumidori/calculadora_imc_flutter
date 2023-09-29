import 'package:calculadoraimcflutter/repositories/imc_repository.dart';
import 'package:flutter/material.dart';

import '../model/imc.dart';
import '../repositories/imc_repository_impl.dart';
import '../utils/form_field_validation.dart';
import 'widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController pesoController = TextEditingController();
  bool isValid = true;
  String? messageValidation;

  IMCRepository repository = IMCRepositoryImpl();
  List<IMC> imcs = [];

  @override
  void initState() {
    super.initState();
    _getIMCs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora IMC'),
        actions: [
          IconButton(
            onPressed: _onAddButtonPressed,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: imcs.length,
          itemBuilder: (BuildContext bc, int index) {
            var imc = imcs[index];
            return Dismissible(
                onDismissed: (DismissDirection dismissDirection) async {
                  repository.removeIMC(imc);
                  _getIMCs();
                },
                key: Key(imc.result!),
                child: ListTile(
                  title: Text(imc.result ?? "índice"),
                  subtitle: Column(
                    children: [
                      Text('Peso: ${imc.weight?.toStringAsFixed(2)}'),
                      Text('Altura: ${imc.height?.toStringAsFixed(2)}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                      onPressed: () => _onDeleteButtonPressed(imc),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.deepPurple,
                      )),
                ));
          }),
    );
  }

  _getIMCs() async {
    try {
      imcs = await repository.getIMCs();
      _sortToDescendingOrder();
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro ao recuperar IMCs"),
        ));
      }
    }
  }

  void _sortToDescendingOrder() {
    imcs.sort((a, b) => b.id!.compareTo(a.id!));
  }

  void _onAddButtonPressed() {
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Informe o peso: '),
            titlePadding: const EdgeInsets.all(16.0),
            contentPadding: const EdgeInsets.all(16.0),
            content: TextFormField(
              controller: pesoController,
              decoration: const InputDecoration(
                hintText: "75.0 kg",
              ),
            ),
            actions: [
              TextButton(
                  onPressed: _onCalcularButtonPressed,
                  child: const Text("Calcular"))
            ],
          );
        });
  }

  void _onCalcularButtonPressed() async {
    _validateWeight();

    if (isValid) {
      await _addIMC();
      await _getIMCs();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Cadastrado"),
        ));
      }
      pesoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(messageValidation!),
      ));

      _resetState();
    }

    if (mounted) {
      _goBackToHomePage(context);
    }
  }

  void _validateWeight() {
    setState(() {
      messageValidation =
          FormFieldValidation.pesoValidation(pesoController.text);
      if (messageValidation != null) {
        isValid = false;
      }
    });
  }

  Future<void> _addIMC() async {
    double? peso;

    setState(() {
      peso = double.parse(pesoController.text);
    });

    try {
      await repository.addIMC(IMC(weigth: peso));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro ao adicionar peso"),
        ));
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Peso adicionado ao banco"),
    ));
  }

  void _resetState() => setState(() {
        isValid = true;
      });

  void _goBackToHomePage(BuildContext context) {
    Navigator.pop(context);
  }

  void _onDeleteButtonPressed(IMC imc) async {
    await _deleteIMC(imc);
    await _getIMCs();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Removido"),
      ));
    }
  }

  Future<void> _deleteIMC(IMC imc) async {
    try {
      await repository.removeIMC(imc);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro"),
        ));
      }
    }
  }
}
