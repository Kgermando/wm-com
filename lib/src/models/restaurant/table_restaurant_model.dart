class TableRestaurantModel {
  late int? id;
  late String table;
  late String part; // cote bon de commande ou bon de consommation
  late String succursale;
  late String signature; // Celui qui fait le document
  late DateTime created;
  late String business;
  late String sync; // new, update, sync
  late String async;

  TableRestaurantModel({
    this.id,
    required this.table,
    required this.part,
    required this.succursale,
    required this.signature,
    required this.created,
    required this.business,
    required this.sync,
    required this.async,
  });

  factory TableRestaurantModel.fromSQL(List<dynamic> row) {
    return TableRestaurantModel(
        id: row[0],
        table: row[1],
        part: row[2],
        succursale: row[3],
        signature: row[4],
        created: row[5],
        business: row[6],
        sync: row[7],
        async: row[8]);
  }

  factory TableRestaurantModel.fromJson(Map<String, dynamic> json) {
    return TableRestaurantModel(
      id: json['id'],
      table: json['table'],
      part: json['part'],
      succursale: json['succursale'],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
      business: json['business'],
      sync: json['sync'],
      async: json['async'],
    );
  }

  Map<String, dynamic> toJson({int? id}) {
    return {
      'id': id,
      'table': table,
      'part': part,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String(),
      'business': business,
      'sync': sync,
      'async': async,
    };
  }
}
