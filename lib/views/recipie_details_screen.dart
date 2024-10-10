import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:recipie_app/constants/constants.dart';
import 'package:recipie_app/provider/favrouite_provider.dart';
import 'package:recipie_app/provider/quantity_provider.dart';
import 'package:recipie_app/widgets/my_icon_button.dart';
import 'package:recipie_app/widgets/quantityIncrementDecrement.dart';

class RecipieDetailsScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipieDetailsScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipieDetailsScreen> createState() => _RecipieDetailsScreenState();
}

class _RecipieDetailsScreenState extends State<RecipieDetailsScreen> {
  @override
  void initState() {
    // initializing the base ingredient amounts in the provider
    List<double> baseAmounts = widget.documentSnapshot["ingredientsAmount"]
        .map<double>(
          (amount) => double.parse(
            amount.toString(),
          ),
        )
        .toList();
    Provider.of<QuantityProvider>(context, listen: false)
        .setBaseIngredientsAmount(baseAmounts);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoruiteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: startCookingAndFavoriteButton(provider),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // for image
                Hero(
                  tag: widget.documentSnapshot["image"],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          widget.documentSnapshot["image"],
                        ),
                      ),
                    ),
                  ),
                ),
                // for back button
                Positioned(
                  top: 20,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      MyIconButton(icon: Iconsax.notification, pressed: () {})
                    ],
                  ),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: -15,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                    ))
              ],
            ),
            // for drag handle
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    widget.documentSnapshot["name"],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Iconsax.flash_1,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "${widget.documentSnapshot["cal"]} cal",
                        style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const Spacer(),
                      const Icon(
                        Iconsax.clock,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "${widget.documentSnapshot["time"]} min",
                        style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Iconsax.star1,
                        color: Colors.amberAccent,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.documentSnapshot["rating"],
                        style: const TextStyle(

                            // fontWeight: FontWeight.bold
                            ),
                      ),
                      const Text("/5"),
                      const Spacer(),
                      Text(
                        "${widget.documentSnapshot["reviews"]} Reviews",
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " Ingredients :-",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.double,
                                decorationThickness: 1,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "How many servings?",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                      Spacer(),
                      QuantityIncrementDecrement(
                        currentNumber: quantityProvider.currentNumber,
                        onAdd: () => quantityProvider.increaseQuantity(),
                        onRemove: () => quantityProvider.decreaseQuantity(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //list of ingredients
                  Column(
                    children: [
                      Row(
                        children: [
                          // ingredients images
                          Column(
                            children: widget
                                .documentSnapshot["ingredientImages"]
                                .map<Widget>(
                                  (imageUrl) => Container(
                                    height: 60,
                                    width: 60,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(imageUrl),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          //ingredinet names
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.documentSnapshot["ingredientNames"]
                                .map<Widget>((ingredient) => SizedBox(
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          ingredient,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                            const  Spacer(),
                          // ingredients amounts
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: quantityProvider.updateIngredientAmounts
                                .map<Widget>(
                                  (amount) => SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        "${amount}gm",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade600),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton startCookingAndFavoriteButton(
      FavoruiteProvider provider) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: () {},
      label: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10)),
              onPressed: () {},
              child: const Text(
                "Start Cooking",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              style: IconButton.styleFrom(
                  shape: CircleBorder(
                      side: BorderSide(
                color: Colors.grey.shade300,
                width: 2,
              ))),
              onPressed: () {
                provider.toggleFavorite(widget.documentSnapshot);
              },
              icon: Icon(
                provider.isExist(widget.documentSnapshot)
                    ? Iconsax.heart5
                    : Iconsax.heart,
                color: provider.isExist(widget.documentSnapshot)
                    ? Colors.red
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
