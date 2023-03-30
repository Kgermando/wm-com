class AbonnementModel {
  late int? id;
  late String statut; // statut abonnement
  late DateTime dateAbonnement;
  late DateTime dateEcheance;
  late String refCode; // Code de reference
  late String moyen; // Moyen de paiement (Ex: Mpsa, PayPal, credit card, ..)
  late String business;
  late String signature;
  late DateTime created;

  AbonnementModel(
      {this.id,
      required this.statut,
      required this.dateAbonnement,
      required this.dateEcheance,
      required this.business,
      required this.refCode,
      required this.moyen,
      required this.signature,
      required this.created});

  factory AbonnementModel.fromSQL(List<dynamic> row) {
    return AbonnementModel(
        id: row[0],
        statut: row[1],
        dateAbonnement: row[2],
        dateEcheance: row[3],
        refCode: row[4],
        moyen: row[5],
        business: row[6],
        signature: row[7],
        created: row[8]);
  }

  factory AbonnementModel.fromJson(Map<String, dynamic> json) {
    return AbonnementModel(
      id: json['id'],
      statut: json['departement'],
      dateAbonnement: DateTime.parse(json['dateAbonnement']),
      dateEcheance: DateTime.parse(json['dateEcheance']),
      refCode: json['refCode'],
      moyen: json['moyen'],
      business: json['business'],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson({int? id}) {
    return {
      'id': id,
      'statut': statut,
      'dateAbonnement': dateAbonnement.toIso8601String(),
      'dateEcheance': dateEcheance.toIso8601String(),
      'refCode': refCode,
      'moyen': moyen,
      'business': business,
      'signature': signature,
      'created': created.toIso8601String(),
    };
  }
}
