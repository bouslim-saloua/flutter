import 'package:flutter/material.dart';
import 'package:produitsapp/produit.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Produit> _favoriteProducts = [];

  List<Produit> get favoriteProducts => List.unmodifiable(_favoriteProducts);

  bool isFavorite(Produit product) {
    return _favoriteProducts.contains(product);
  }

  void addFavorite(Produit product) {
    if (!_favoriteProducts.contains(product)) {
      _favoriteProducts.add(product);
      notifyListeners(); 
    }
  }

  void removeFavorite(Produit product) {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
      notifyListeners();
    }
  }

  void toggleFavorite(Produit product) {
    if (isFavorite(product)) {
      removeFavorite(product);
    } else {
      addFavorite(product);
    }
  }
}
