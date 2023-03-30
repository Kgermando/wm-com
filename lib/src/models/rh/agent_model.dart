class AgentModel {
  late int? id;
  late String nom;
  late String postNom;
  late String prenom;
  late String email;
  late String telephone;
  late String adresse;
  late String sexe;
  late String role; // droit d'acces au logiciel de 0 à 5
  late String matricule;
  late DateTime dateNaissance;
  late String lieuNaissance;
  late String nationalite;
  late String typeContrat;
  late String departement;
  late String servicesAffectation; // Caisse, livraison, rangement, securite
  late DateTime dateDebutContrat;
  late DateTime dateFinContrat;
  late String fonctionOccupe; // Administrateur, manager, superviseur, agent
  late String? detailPersonnel; // Formation, experience, loisirs, ...
  late String statutAgent;
  late DateTime createdAt;
  late String? photo;
  late String salaire;
  late String signature; // celui qui fait le document
  late DateTime created;
  late String isDelete;
  late String business;
  late String sync;
  late String async;

  AgentModel({
    this.id,
    required this.nom,
    required this.postNom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.adresse,
    required this.sexe,
    required this.role,
    required this.matricule,
    required this.dateNaissance,
    required this.lieuNaissance,
    required this.nationalite,
    required this.typeContrat,
    required this.departement,
    required this.servicesAffectation,
    required this.dateDebutContrat,
    required this.dateFinContrat,
    required this.fonctionOccupe,
    this.detailPersonnel,
    required this.statutAgent,
    required this.createdAt,
    this.photo,
    required this.salaire,
    required this.signature,
    required this.created,
    required this.isDelete,
    required this.business,
    required this.sync,
    required this.async,
  });

  factory AgentModel.fromSQL(List<dynamic> row) {
    return AgentModel(
        id: row[0],
        nom: row[1],
        postNom: row[2],
        prenom: row[3],
        email: row[4],
        telephone: row[5],
        adresse: row[6],
        sexe: row[7],
        role: row[8],
        matricule: row[9],
        dateNaissance: row[10],
        lieuNaissance: row[11],
        nationalite: row[12],
        typeContrat: row[13],
        departement: row[14],
        servicesAffectation: row[15],
        dateDebutContrat: row[16],
        dateFinContrat: row[17],
        fonctionOccupe: row[18],
        detailPersonnel: row[19],
        statutAgent: row[20],
        createdAt: row[21],
        photo: row[22],
        salaire: row[23],
        signature: row[24],
        created: row[25],
        isDelete: row[26],
        business: row[27],
        sync: row[28],
        async: row[29]);
  }

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json["id"],
      nom: json["nom"],
      postNom: json["postNom"],
      prenom: json["prenom"],
      email: json["email"],
      telephone: json["telephone"],
      adresse: json["adresse"],
      sexe: json["sexe"],
      role: json["role"],
      matricule: json["matricule"],
      dateNaissance: DateTime.parse(json['dateNaissance']),
      lieuNaissance: json["lieuNaissance"],
      nationalite: json["nationalite"],
      typeContrat: json["typeContrat"],
      departement: json["departement"],
      servicesAffectation: json["servicesAffectation"],
      dateDebutContrat: DateTime.parse(json['dateDebutContrat']),
      dateFinContrat: DateTime.parse(json['dateFinContrat']),
      fonctionOccupe: json["fonctionOccupe"],
      detailPersonnel: json["detailPersonnel"],
      statutAgent: json['statutAgent'],
      createdAt: DateTime.parse(json["createdAt"]),
      photo: json["photo"],
      salaire: json["salaire"],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
      isDelete: json['isDelete'],
      business: json['business'],
      sync: json['sync'],
      async: json['async'],
    );
  }

  Map<String, dynamic> toJson({int? id}) {
    return {
      'id': id,
      'nom': nom,
      'postNom': postNom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
      'sexe': sexe,
      'role': role,
      'matricule': matricule,
      'dateNaissance': dateNaissance.toIso8601String(),
      'lieuNaissance': lieuNaissance,
      'nationalite': nationalite,
      'typeContrat': typeContrat,
      'departement': departement,
      'servicesAffectation': servicesAffectation,
      'dateDebutContrat': dateDebutContrat.toIso8601String(),
      'dateFinContrat': dateFinContrat.toIso8601String(),
      'fonctionOccupe': fonctionOccupe,
      'detailPersonnel': detailPersonnel,
      'statutAgent': statutAgent.toString(),
      'createdAt': createdAt.toIso8601String(),
      'photo': photo,
      'salaire': salaire,
      'signature': signature,
      'created': created.toIso8601String(),
      'isDelete': isDelete,
      'business': business,
      'sync': sync,
      'async': async,
    };
  }
}
