import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'produit.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  _ProduitsListState createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController _imageUrlController = TextEditingController();

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        Navigator.pushNamed(context, '/profile');
        break;
      case 'logout':
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/auth');
        break;
    }
  }

  void _showAddProduitDialog() {
    final TextEditingController designationController = TextEditingController();
    final TextEditingController marqueController = TextEditingController();
    final TextEditingController categorieController = TextEditingController();
    final TextEditingController prixController = TextEditingController();
    final TextEditingController quantiteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un produit'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: designationController,
                  decoration: const InputDecoration(labelText: 'Désignation'),
                ),
                TextField(
                  controller: marqueController,
                  decoration: const InputDecoration(labelText: 'Marque'),
                ),
                TextField(
                  controller: categorieController,
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                ),
                TextField(
                  controller: prixController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: quantiteController,
                  decoration: const InputDecoration(labelText: 'Quantité'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  keyboardType: TextInputType.url,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final produit = Produit(
                  id: '',
                  designation: designationController.text,
                  marque: marqueController.text,
                  categorie: categorieController.text,
                  prix: double.tryParse(prixController.text) ?? 0.0,
                  quantite: int.tryParse(quantiteController.text) ?? 0,
                  photo: _imageUrlController.text,
                  isFavorite: false,
                );

                await _addProduitToFirestore(produit);
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addProduitToFirestore(Produit produit) async {
    try {
      await db.collection('produits').add({
        'designation': produit.designation,
        'marque': produit.marque,
        'categorie': produit.categorie,
        'prix': produit.prix,
        'photo': produit.photo,
        'quantite': produit.quantite,
        'isFavorite': produit.isFavorite,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du produit : $e')),
      );
    }
  }

  Future<void> _deleteProduit(String id) async {
    try {
      await db.collection('produits').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit supprimé avec succès.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression : $e')),
      );
    }
  }

  Future<void> _toggleFavorite(String id, bool isFavorite) async {
    try {
      await db.collection('produits').doc(id).update({
        'isFavorite': !isFavorite,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des produits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddProduitDialog,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: Text('Profil'),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Déconnexion'),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('produits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                  'Une erreur est survenue lors du chargement des produits.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Aucun produit disponible.'),
            );
          }

          final produits = snapshot.data!.docs.map((doc) {
            return Produit.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            itemCount: produits.length,
            itemBuilder: (context, index) {
              final produit = produits[index];
              return Slidable(
                key: ValueKey(produit.id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => _deleteProduit(produit.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Supprimer',
                    ),
                  ],
                ),
                child: ProduitItem(
                  produit: produit,
                  onToggleFavorite: _toggleFavorite,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProduitItem extends StatelessWidget {
  final Produit produit;
  final Function(String id, bool isFavorite) onToggleFavorite;

  const ProduitItem({
    super.key,
    required this.produit,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: produit.photo.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  produit.photo,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.image, size: 50);
                  },
                ),
              )
            : const Icon(Icons.image, size: 50),
        title: Text(
          produit.designation,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Marque: ${produit.marque}'),
            Text('Catégorie: ${produit.categorie}'),
            Text('Quantité: ${produit.quantite}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            produit.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: produit.isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () => onToggleFavorite(produit.id, produit.isFavorite),
        ),
      ),
    );
  }
}
