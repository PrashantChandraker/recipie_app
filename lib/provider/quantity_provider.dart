import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientsAmounts = [];
  int get currentNumber => _currentNumber;
  // set initial ingrediants amounts
  void setBaseIngredientsAmount(List<double> amounts) {
    _baseIngredientsAmounts = amounts;
    notifyListeners();
  }

  List<String> get updateIngredientAmounts {
    return _baseIngredientsAmounts
        .map<String>((amount) => (amount * _currentNumber).toStringAsFixed(1))
        .toList();
  }
  //increase servings
  void increaseQuantity(){
    _currentNumber++; 
    notifyListeners();
  }

  // decrease servings
  void decreaseQuantity(){
   if(_currentNumber>1){
     _currentNumber--; 
      notifyListeners();
   }

  } 
}
