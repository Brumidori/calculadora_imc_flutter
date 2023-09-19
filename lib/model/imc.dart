class Imc {
  double _weight = 0.0;
  double _height = 0.0;
  double _imc = 0.0;

  Imc(this._weight, this._height, this._imc);

  double get weight => _weight;
  double get height => _height;
  double get imc => _imc;

  set weight(double weight) {
    _weight = weight;
  }

  set height(double height) {
    _height = height;
  }

  set imc(double imc) {
    _imc = imc;
  }
}
