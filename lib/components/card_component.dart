import 'package:flutter/material.dart';

class CardComponent extends StatelessWidget {
  final double weightCard;
  final double heightCard;
  final double imcCard;

  const CardComponent({
    Key? key,
    required this.weightCard,
    required this.heightCard,
    required this.imcCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 8.0, 4.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Peso",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(weightCard.toString()),
                const SizedBox(
                  width: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Altura",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(heightCard.toString()),
                const SizedBox(
                  width: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "IMC",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(imcCard.toStringAsFixed(2)),
              ],
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "ÍNDICE",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(_result(imcCard)),
            ],
          ),
        ],
      ),
    );
  }
}

String _result(double imcResult) {
  String result = '';
  switch (imcResult) {
    case < 16:
      result = ('Magreza grave');
    case < 17:
      result = ('Magreza moderada');

    case < 18.5:
      result = ('Magreza leve');
    case < 25:
      result = ('Saudável');

    case < 30:
      result = ('Sobrepeso');

    case < 35:
      result = ('Obesidade grau 1');

    case < 40:
      result = ('Obesidade grau 2 (severa)');

    case >= 40:
      result = ('Obesidade grau 3 (morbida)');
  }
  return result;
}
