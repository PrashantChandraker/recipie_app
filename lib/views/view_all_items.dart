import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
    // for view all section
  final CollectionReference categoriesItems =
      FirebaseFirestore.instance.collection("complete-flutter-app");
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}