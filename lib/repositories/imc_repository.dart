import 'package:calculadoraimcflutter/model/imc.dart';

abstract interface class IMCRepository {
  Future<void> addHeight(IMC imc);
  Future<double> getHeight();
  Future<void> addIMC(IMC imc);
  Future<void> removeIMC(IMC imc);
  Future<List<IMC>> getIMCs();
}
