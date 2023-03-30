class PaiementReservationModel {
  late int? id;
  late int reference;
  late String client;
  late String motif;
  late String montant;
  late String succursale;
  late String signature; // celui qui fait le document
  late DateTime created;
  late String business;
  late String sync; // new, update, sync
  late String async;

  PaiementReservationModel({
    this.id,
    required this.reference,
    required this.client,
    required this.motif,
    required this.montant,
    required this.succursale,
    required this.signature,
    required this.created,
    required this.business,
    required this.sync,
    required this.async,
  });

  factory PaiementReservationModel.fromSQL(List<dynamic> row) {
    return PaiementReservationModel(
        id: row[0],
        reference: row[1],
        client: row[2],
        motif: row[3],
        montant: row[4],
        succursale: row[5],
        signature: row[6],
        created: row[7],
        business: row[8],
        sync: row[9],
        async: row[10]);
  }

  factory PaiementReservationModel.fromJson(Map<String, dynamic> json) {
    return PaiementReservationModel(
      id: json["id"],
      reference: json["reference"],
      client: json["client"],
      motif: json["motif"],
      montant: json["montant"],
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
      'reference': reference,
      'client': client,
      'motif': motif,
      'montant': montant,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String(),
      'business': business,
      'sync': sync,
      'async': async,
    };
  }
}
