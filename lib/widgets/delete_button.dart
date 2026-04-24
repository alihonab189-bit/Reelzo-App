import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteButton extends StatelessWidget {
  final String collection;
  final String docId;

  const DeleteButton({
    super.key,
    required this.collection,
    required this.docId,
  });

  Future<void> delete(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deleted ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () => delete(context),
    );
  }
}