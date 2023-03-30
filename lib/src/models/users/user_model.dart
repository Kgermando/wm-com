import 'package:sembast/sembast.dart';

class UserModel {
  late int? id;
  late String? photo;
  late String nom;
  late String prenom;
  late String email;
  late String telephone;
  late String matricule;
  late String departement;
  late String servicesAffectation;
  late String fonctionOccupe;
  late String role; // Acces user de 1 à 5
  late String isOnline; // Agent connecté
  late DateTime createdAt;
  late String passwordHash;
  late String succursale;
  late String business;
  late String sync; // new, update, sync
  late String async;

  UserModel({
    this.id,
    this.photo,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.matricule,
    required this.departement,
    required this.servicesAffectation,
    required this.fonctionOccupe,
    required this.role,
    required this.isOnline,
    required this.createdAt,
    required this.passwordHash,
    required this.succursale,
    required this.business,
    required this.sync,
    required this.async,
  });

  factory UserModel.fromSQL(List<dynamic> row) {
    return UserModel(
        id: row[0],
        photo: row[1],
        nom: row[2],
        prenom: row[3],
        email: row[4],
        telephone: row[5],
        matricule: row[6],
        departement: row[7],
        servicesAffectation: row[8],
        fonctionOccupe: row[9],
        role: row[10],
        isOnline: row[11],
        createdAt: row[12],
        passwordHash: row[13],
        succursale: row[14],
        business: row[15],
        sync: row[16],
        async: row[17]);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      photo: json["photo"],
      nom: json["nom"],
      prenom: json["prenom"],
      email: json["email"],
      telephone: json["telephone"],
      matricule: json["matricule"],
      departement: json["departement"],
      servicesAffectation: json["servicesAffectation"],
      fonctionOccupe: json["fonctionOccupe"],
      role: json["role"],
      isOnline: json["isOnline"],
      createdAt: DateTime.parse(json["createdAt"]),
      passwordHash: json["passwordHash"],
      succursale: json["succursale"],
      business: json['business'],
      sync: json['sync'],
      async: json['async'],
    );
  }

  Map<String, dynamic> toJson({int? id}) {
    return {
      'id': id,
      'photo': photo,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'matricule': matricule,
      'departement': departement,
      'servicesAffectation': servicesAffectation,
      'fonctionOccupe': fonctionOccupe,
      'role': role,
      'isOnline': isOnline.toString(),
      'createdAt': createdAt.toIso8601String(),
      'passwordHash': passwordHash,
      'succursale': succursale,
      'business': business,
      'sync': sync,
      'async': async,
    };
  }

  UserModel.fromDatabase(RecordSnapshot<int, Map<String, dynamic>> snapshot)
      : id = snapshot.key,
        photo = snapshot.value['photo'] as String,
        nom = snapshot.value['nom'] as String,
        prenom = snapshot.value['prenom'] as String,
        email = snapshot.value['email'] as String,
        telephone = snapshot.value['telephone'] as String,
        matricule = snapshot.value['matricule'] as String,
        departement = snapshot.value['departement'] as String,
        servicesAffectation = snapshot.value['servicesAffectation'] as String,
        fonctionOccupe = snapshot.value['fonctionOccupe'] as String,
        role = snapshot.value['role'] as String,
        isOnline = snapshot.value['isOnline'] as String,
        createdAt = DateTime.parse(snapshot.value['createdAt'] as String),
        passwordHash = snapshot.value['passwordHash'] as String,
        succursale = snapshot.value['succursale'] as String,
        business = snapshot.value['business'] as String,
        sync = snapshot.value['sync'] as String,
        async = snapshot.value['async'] as String;
}
