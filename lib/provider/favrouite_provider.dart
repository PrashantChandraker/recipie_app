import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoruiteProvider extends ChangeNotifier{
  List<String> _favouriteIds = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favorites =>_favouriteIds;


  FavoriteProvider(){
    loadFavorites();
    // toggleFavorite(product);
  }

  //toggle favorites state
  void toggleFavorite(DocumentSnapshot product) async{
    String ProductId = product.id;
    if(_favouriteIds.contains(ProductId)){
      _favouriteIds.remove(ProductId);
      await _removeFavourite(ProductId); // remove from favorite

    }else{
      _favouriteIds.add(ProductId);
      await _addFavourite(ProductId); // add to Favourite
    }
    notifyListeners();
  }
  //check if the product us favourited
  bool isExist(DocumentSnapshot product){
    return _favouriteIds.contains(product.id);
  }

  // Add favourites to firestore
  Future<void> _addFavourite(String ProductId) async{
    try {
      await _firestore.collection("userFavourite").doc(ProductId).set({
        'isFavourite':true // It creates userFavourites collection and add item as favourites in firestore
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Remove favourites from the screen
    Future<void> _removeFavourite(String ProductId) async{
    try {
      // this will delete the data from the firestore database
      await _firestore.collection("userFavourite").doc(ProductId).delete(); 
    } catch (e) {
      print(e.toString());
    }
  }

  // Load favourites from firestore (store favourite or not)
  Future<void> loadFavorites() async{
    try {
      QuerySnapshot snapshot = await _firestore.collection("userFavourite").get();
      _favouriteIds = snapshot.docs.map((doc)=> doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  //static method to access the provider from any context
  static FavoruiteProvider of<FavoriteProvider>(BuildContext context, {bool listen = true}){
    return Provider.of(context,listen: listen);
  }
}