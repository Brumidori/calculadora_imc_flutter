import 'package:calculadoraimcflutter/repositories/imc_repository.dart';
import 'package:calculadoraimcflutter/services/calculatorImc.dart';

import '../model/imc.dart';
import '../services/height_service.dart';
import '../services/imc_service.dart';

class IMCRepositoryImpl implements IMCRepository {
  final ImcService imcService = ImcService();
  final HeightService heightService = HeightService();

  @override
  Future<void> addHeight(IMC imc) async {
    await heightService.add(imc.height!);
  }

  @override
  Future<void> addIMC(IMC imc) async {
    final height = await getHeight();
    final result = CalculatorIMC.result(imc.weigth!, height);

    await imcService.add(imc.weigth!, result);
  }

  @override
  Future<double> getHeight() async {
    return await heightService.getOne();
  }

  @override
  Future<List<IMC>> getIMCs() async {
    final response = await imcService.getAll();
    final imcs = response.map((imc) => IMC.fromJson(imc)).toList();
    return imcs;
  }

  @override
  Future<void> removeIMC(IMC imc) async {
    await imcService.delete(imc.id!);
  }
}
