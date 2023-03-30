class CaisseNameModel {
  late int? id;
  late String nomComplet;
  late String rccm;
  late String idNat;
  late String addresse;
  late DateTime created;
  late String business;
  late String sync; // new, update, sync
  late String async;

  CaisseNameModel({
    this.id,
    required this.nomComplet,
    required this.rccm,
    required this.idNat,
    required this.addresse,
    required this.created,
    required this.business,
    required this.sync,
    required this.async,
  });

  factory CaisseNameModel.fromSQL(List<dynamic> row) {
    return CaisseNameModel(
        id: row[0],
        nomComplet: row[1],
        rccm: row[2],
        idNat: row[3],
        addresse: row[4],
        created: row[5],
        business: row[6],
        sync: row[7],
        async: row[8]);
  }

  factory CaisseNameModel.fromJson(Map<String, dynamic> json) {
    return CaisseNameModel(
      id: json['id'],
      nomComplet: json['nomComplet'],
      rccm: json['rccm'],
      idNat: json['idNat'],
      addresse: json['addresse'],
      created: DateTime.parse(json['created']),
      business: json['business'],
      sync: json['sync'],
      async: json['async'],
    );
  }

  Map<String, dynamic> toJson({int? id}) {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'rccm': rccm,
      'idNat': idNat,
      'addresse': addresse,
      'created': created.toIso8601String(),
      'business': business,
      'sync': sync,
      'async': async,
    };
  }
}
