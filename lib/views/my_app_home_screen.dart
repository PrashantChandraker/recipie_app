import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipie_app/constants/constants.dart';
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  //for category
                  StreamBuilder(
                    stream: categoriesItems.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              streamSnapshot.data!.docs.length,
                              (index) => GestureDetector(
                                onTap: () {
                                    
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: category == streamSnapshot.data!.docs[index]["name"] ? kPrimaryColor : Colors.white,

                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    margin: EdgeInsets.only(right: 20),
                                    child: Text(streamSnapshot.data!.docs[index]["name"], 
                                    style: TextStyle(fontWeight: FontWeight.w600) ,),
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
                  )
                ],
              ),
            ),
          ],
        ),
      )),
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
