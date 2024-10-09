import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          ? Center(
              child: Text(
                "No Favorites yet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favouriteItems.length,
              itemBuilder: (context, index) {
                String favorite = favouriteItems[index];
               return  FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("complete-flutter-app")
                      .doc(favorite)
                      .get(),
                  builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting) {
                     return Center(
                      child: CircularProgressIndicator(),
                    );
                   
                 }
                 if(snapshot.hasData || snapshot.hasError){
                    return Center(
                      child: Text("Error Loading Favorites"),
                    );
                  }
                  var favoriteItem = snapshot.data!;
                  return Stack(
                    children: [
                      Padding(padding: EdgeInsets.all(15),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(image: NetworkImage(favoriteItem["image"] ?? "",),),
                              ),
                            )
                          ],
                        ),
                      ),
                      )
                    ],
                  );
                  },
                  
                );
              },
            ),
    );
  }
}
