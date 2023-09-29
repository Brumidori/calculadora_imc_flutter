class IMC {
  final int? id;
  final double? weigth;
  final double? height;
  final String? result;

  const IMC({this.id, this.weigth, this.height, this.result});

  factory IMC.fromJson(Map<String, dynamic> json) {
    return IMC(
      id: json['id'],
      weigth: json['weigth'],
      height: json['height'],
      result: json['result'],
    );
  }

  get weight => null;

  IMC copyWith({int? id, double? weigth, double? height, String? result}) {
    return IMC(
      id: id ?? this.id,
      weigth: weigth ?? this.weigth,
      height: height ?? this.height,
      result: result ?? this.result,
    );
  }
}
