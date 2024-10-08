import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipie_app/constants/constants.dart';
import 'package:recipie_app/widgets/food_items_display.dart';
import 'package:recipie_app/widgets/my_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/banner.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String category = "All";
  // for category
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("Add-Category");

  // for all items display
  Query get filteredRecipies => FirebaseFirestore.instance.collection("complete-flutter-app").where('category', isEqualTo: category);
  Query get allRecipies => FirebaseFirestore.instance.collection("complete-flutter-app");
  Query get selectedRecipes => category == "All" ? allRecipies : filteredRecipies;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    headerParts(),
                    mySearchBar(),

                    //for banner
                    const BannerToExplore(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                    //for category
                    selectedCategory(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Quick & Easy",
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 0.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // I will make this function later
                      },
                      child: const Text(
                        "view all",
                        style: TextStyle(
                            color: kBannerColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: selectedRecipes.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> recipies = snapshot.data?.docs ?? [];
                    return Padding(
                      padding: const EdgeInsets.only(top:5.0, left: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: recipies.map((e)=> FoodItemsDisplay(documentSnapshot: e)).toList(),
                        ),
                      ),
                    );
                  }
                  // If snapshot dont have data then circular progress indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
      stream: categoriesItems.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                streamSnapshot.data!.docs.length,
                (index) => GestureDetector(
                  onTap: () {
                    //if the data will be avilabe then it will work
                    setState(() {
                      category == streamSnapshot.data!.docs[index]["name"];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          category == streamSnapshot.data!.docs[index]["name"]
                              ? kPrimaryColor
                              : Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      streamSnapshot.data!.docs[index]["name"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        // If snapshot dont have data then circular progress indicator
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Row headerParts() {
    return Row(
      children: [
        const Text(
          "What are you \ncooking today",
          style:
              TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1),
        ),
        const Spacer(),
        MyIconButton(icon: Iconsax.notification, pressed: () {}),
      ],
    );
  }

  Padding mySearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: const Icon(Iconsax.search_normal),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: "Search any recipes",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
