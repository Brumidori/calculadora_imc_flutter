import 'package:calculadoraimcflutter/components/card_component.dart';
import 'package:calculadoraimcflutter/model/imc.dart';
import 'package:calculadoraimcflutter/repositories/imc_repository.dart';
import 'package:calculadoraimcflutter/services/imc_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var weightController = TextEditingController();

  var heightController = TextEditingController();

  var imcRepository = ImcRepository();
  var imcService = ImceService();
  var _imc = <Imc>[];

  @override
  void initState() {
    super.initState();
    _imc = imcRepository.imcList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora IMC flutter"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          weightController.text = '';
          heightController.text = '';
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text('Digite o peso e altura'),
                  content: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Peso",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Altura",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                try {
                                  var imc = imcService.calcularImc(
                                      double.parse(weightController.text),
                                      double.parse(heightController.text));
                                  imcRepository.add(Imc(
                                      double.parse(weightController.text),
                                      double.parse(heightController.text),
                                      imc));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                          'Por favor digite um valor de peso e altura valido ("0-9", ".") '),
                                    ),
                                  );
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: const Text('calcular'))
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancelar')),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _imc.length,
          itemBuilder: (BuildContext bc, int index) {
            var imc = _imc[index];
            return CardComponent(
              weightCard: imc.weight,
              heightCard: imc.height,
              imcCard: imc.imc,
            );
          },
        ),
      ),
    );
  }
}
