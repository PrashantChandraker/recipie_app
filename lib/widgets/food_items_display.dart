import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipie_app/provider/favrouite_provider.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoruiteProvider.of(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          documentSnapshot["image"]), // image from firestore
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: InkWell(
                      onTap: () {
                        // for favrouite button I am using provider
                        provider.toggleFavorite(documentSnapshot);
                      },
                      child: Icon(
                        provider.isExist(documentSnapshot)
                            ? Iconsax.heart5
                            : Iconsax.heart,
                        size: 20,
                        color: provider.isExist(documentSnapshot) ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  documentSnapshot["name"],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                const Icon(
                  Iconsax.flash_1,
                  size: 15,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  "${documentSnapshot["cal"]} cal",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Spacer(),
                const Icon(
                  Iconsax.watch,
                  size: 15,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  "${documentSnapshot["time"]} min",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
