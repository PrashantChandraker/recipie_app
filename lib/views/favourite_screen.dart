import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipie_app/constants/constants.dart';
import 'package:recipie_app/provider/favrouite_provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoruiteProvider.of(context);
    final favouriteItems = provider.favourites;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: const Text(
          "Favorite",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: favouriteItems.isEmpty
          ? const Center(
              child: Text(
                "No Favorites yet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favouriteItems.length,
              itemBuilder: (context, index) {
                String favorite = favouriteItems[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("complete-flutter-app")
                      .doc(favorite)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      // print("length of favourites => ${favouriteItems.length}");
                      return const Center(
                        child: Text("Error Loading Favorites"),
                      );
                    }
                    var favoriteItem = snapshot.data!;
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Stack(children: [
                        Container(
                          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      
                                      favoriteItem["image"],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favoriteItem["name"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Iconsax.flash_1,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${favoriteItem["cal"]} cal",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Iconsax.watch,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${favoriteItem["time"]} min",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 38,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                provider.toggleFavorite(favoriteItem);
                              });
                            },
                          child: Icon(Icons.delete,color: Colors.red,size: 30,),
                        ),),
                      ],),
                    );
                  },
                );
              },
            ),
    );
  }
}
