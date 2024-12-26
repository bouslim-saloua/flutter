import 'package:cloud_firestore/cloud_firestore.dart';

class Produit {
  String id;
  String marque;
  String designation;
  String categorie;
  double prix;
  String photo;
  int quantite;
  bool isFavorite;

  Produit(
      {required this.id,
      required this.marque,
      required this.designation,
      required this.categorie,
      required this.prix,
      required this.photo,
      required this.quantite,
      required this.isFavorite});

  factory Produit.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Produit(
      id: doc.id,
      marque: data['marque'] ?? '',
      designation: data['designation'] ?? '',
      categorie: data['categorie'] ?? '',
      prix: (data['prix'] ?? 0.0).toDouble(),
      photo: data['photo'] ?? '',
      quantite: data['quantite'] ?? 0,
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}
