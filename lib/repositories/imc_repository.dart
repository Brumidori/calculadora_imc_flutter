import 'package:calculadoraimcflutter/model/imc.dart';

class ImcRepository {
  final List<Imc> _imc = [];

  Future<void> add(Imc imc) async {
    Future.delayed(const Duration(milliseconds: 100));
    _imc.add(imc);
  }

  List<Imc> imcList() {
    return _imc;
  }
}
