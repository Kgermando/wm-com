class VenteChartRestaurantModel {
  final String identifiant;
  final int count;

  VenteChartRestaurantModel({required this.identifiant, required this.count});

  factory VenteChartRestaurantModel.fromSQL(List<dynamic> row) {
    return VenteChartRestaurantModel(identifiant: row[0], count: row[1]);
  }

  factory VenteChartRestaurantModel.fromJson(Map<String, dynamic> json) {
    return VenteChartRestaurantModel(
        identifiant: json['identifiant'], count: json['count']);
  }

  Map<String, dynamic> toJson() {
    return {'identifiant': identifiant, 'count': count};
  }
}
