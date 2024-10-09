// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:recipie_app/constants/constants.dart';
// import 'package:recipie_app/provider/favrouite_provider.dart';

// class FavouriteScreen extends StatefulWidget {
//   const FavouriteScreen({super.key});

//   @override
//   State<FavouriteScreen> createState() => _FavouriteScreenState();
// }

// class _FavouriteScreenState extends State<FavouriteScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final provider = FavoruiteProvider.of(context);
//     final favoriteItems = provider.favorites;
//     return Scaffold(
//         backgroundColor: kBackgroundColor,
//         appBar: AppBar(
//           backgroundColor: kBackgroundColor,
//           title: const Text(
//             "Favorite",
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: favoriteItems.isEmpty
//             ? Center(
//                 child: Text(
//                   "No Favorites yet",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               )
//             : ListView.builder(
//               itemCount: favoriteItems.length,
//               itemBuilder: (context, index) {
//                 FutureBuilder<DocumentSnapshot>(future: , builder: builder)
//             }));
//   }
// }
