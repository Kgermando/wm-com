class VenteRestaurantModel {
  late int? id;
  late String identifiant;
  late String table;
  late String priceTotalCart;
  late String qty;
  late String price;
  late String unite;
  late String succursale;
  late String signature; // celui qui fait le document
  late DateTime created;
  late String business;
  late String sync; // new, update, sync
  late String async;

  VenteRestaurantModel({
    this.id,
    required this.identifiant,
    required this.table,
    required this.priceTotalCart,
    required this.qty,
    required this.price,
    required this.unite,
    required this.succursale,
    required this.signature,
    required this.created,
    required this.business,
    required this.sync,
    required this.async,
  });

  factory VenteRestaurantModel.fromSQL(List<dynamic> row) {
    return VenteRestaurantModel(
        id: row[0],
        identifiant: row[1],
        table: row[2],
        priceTotalCart: row[3],
        qty: row[4],
        price: row[5],
        unite: row[6],
        succursale: row[7],
        signature: row[8],
        created: row[9],
        business: row[10],
        sync: row[11],
        async: row[12]);
  }

  factory VenteRestaurantModel.fromJson(Map<String, dynamic> json) {
    return VenteRestaurantModel(
      id: json['id'],
      identifiant: json['identifiant'],
      table: json['table'],
      priceTotalCart: json['priceTotalCart'],
      qty: json['qty'],
      price: json['price'],
      unite: json["unite"],
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
      'identifiant': identifiant,
      'table': table,
      'priceTotalCart': priceTotalCart,
      'qty': qty,
      'price': price,
      "unite": unite,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String(),
      'business': business,
      'sync': sync,
      'async': async,
    };
  }
}
