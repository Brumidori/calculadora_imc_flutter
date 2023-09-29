import 'package:calculadoraimcflutter/utils/form_field_validation.dart';
import 'package:flutter/material.dart';

import '../model/imc.dart';
import '../repositories/imc_repository.dart';
import '../repositories/imc_repository_impl.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController heightController = TextEditingController();
  bool loading = false;
  bool isValid = true;
  String? messageValidation;
  double height = 0.0;

  IMCRepository repository = IMCRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _getHeight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
      ),
      body: ListView(
        children: [
          if (loading)
            const LinearProgressIndicator(
              color: Colors.deepPurple,
            ),
          ExpansionTile(
            shape: const Border(),
            title: const Text("Altura"),
            childrenPadding: const EdgeInsets.all(8.0),
            children: [
              const Text(
                "Informe a Altura em metros",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: heightController,
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  suffixIcon: _AddHeight(
                    onPressed: _onAddAlturaPressed,
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: '${height.toStringAsFixed(2)} m',
                  hintStyle: const TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.deepPurple)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.deepPurple)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.deepPurple)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _getHeight() async {
    try {
      var response = await repository.getHeight();

      setState(() {
        heightController.text = response.toString();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro"),
        ));
      }
    }
  }

  _onAddAlturaPressed() async {
    _validateHeight();

    if (isValid) {
      _showLoadingProgress();

      await _addAltura();
      await _getHeight();

      heightController.clear();
      _hideLoadingProgress();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Cadastrado!"),
        ));

        _goToHomePage(context);
      }
    } else {
      SnackBar(content: Text(messageValidation!));

      _resetState();
    }
  }

  void _validateHeight() {
    setState(() {
      messageValidation =
          FormFieldValidation.alturaValidation(heightController.text);
      if (messageValidation != null) {
        isValid = false;
      }
    });
  }

  void _showLoadingProgress() {
    setState(() {
      loading = true;
    });
  }

  Future<void> _addAltura() async {
    setState(() {
      height = double.parse(heightController.text);
    });

    try {
      await repository.addHeight(IMC(height: height));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro"),
        ));
      }
    }
  }

  void _hideLoadingProgress() {
    setState(() {
      loading = false;
    });
  }

  void _resetState() {
    setState(() {
      isValid = true;
    });
  }

  void _goToHomePage(BuildContext context) {
    Navigator.pop(context);
  }
}

class _AddHeight extends StatelessWidget {
  const _AddHeight({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.send_rounded,
          color: Colors.deepPurple,
        ));
  }
}
