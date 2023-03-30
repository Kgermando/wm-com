class ServiceHomeModel {
  late int? id;
  late String name;
  late String categorie;
  late String iconPlace;
  late String signature;
  late DateTime created;
  late String business;

  ServiceHomeModel(
      {this.id,
      required this.name,
      required this.categorie,
      required this.iconPlace,
      required this.signature,
      required this.created,
      required this.business});

  factory ServiceHomeModel.fromSQL(List<dynamic> row) {
    return ServiceHomeModel(
        id: row[0],
        name: row[1],
        categorie: row[2],
        iconPlace: row[3],
        signature: row[4],
        created: row[5],
        business: row[6]);
  }

  factory ServiceHomeModel.fromJson(Map<String, dynamic> json) {
    return ServiceHomeModel(
      id: json['id'],
      name: json['name'],
      categorie: json['categorie'],
      iconPlace: json['iconPlace'],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
      business: json['business'],
    );
  }

  Map<String, dynamic> toJson({int? id}) {
    return {
      'id': id,
      'name': name,
      'categorie': categorie,
      'iconPlace': iconPlace,
      'signature': signature,
      'created': created.toIso8601String(),
      'business': business,
    };
  }
}
