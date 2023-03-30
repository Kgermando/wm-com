class ChartFinanceModel {
  final String name;
  final double depot;
  final double retrait;

  ChartFinanceModel(
      {required this.name, required this.depot, required this.retrait});

  factory ChartFinanceModel.fromSQL(List<dynamic> row) {
    return ChartFinanceModel(
      name: row[0],
      depot: row[1],
      retrait: row[2],
    );
  }

  factory ChartFinanceModel.fromJson(Map<String, dynamic> json) {
    return ChartFinanceModel(
      name: json['name'], depot: json['depot'], retrait: json['retrait']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'depot': depot, 'retrait': retrait};
  }
}



class ChartProductionModel {
  final String idProduct;
  final double qtyTotal;
  final double qtyBonne;
  final double qtyMauvaise;

  ChartProductionModel(
      {required this.idProduct,
      required this.qtyTotal,
      required this.qtyBonne,
      required this.qtyMauvaise});

  factory ChartProductionModel.fromSQL(List<dynamic> row) {
    return ChartProductionModel(
        idProduct: row[0],
        qtyTotal: row[1],
        qtyBonne: row[2],
        qtyMauvaise: row[3]);
  }

  factory ChartProductionModel.fromJson(Map<String, dynamic> json) {
    return ChartProductionModel(
        idProduct: json['idProduct'],
        qtyTotal: json['qtyTotal'],
        qtyBonne: json['qtyBonne'],
        qtyMauvaise: json['qtyMauvaise']);
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduct': idProduct,
      'qtyTotal': qtyTotal,
      'qtyBonne': qtyBonne,
      'qtyMauvaise': qtyMauvaise
    };
  }
}
