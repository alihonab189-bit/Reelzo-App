import 'package:flutter/material.dart';
import '../services/relationship_service.dart';

class RelationshipScreen extends StatelessWidget {
const RelationshipScreen({super.key});

@override
Widget build(BuildContext context) {

String myId = "user_1"; // replace later

return Scaffold(
  appBar: AppBar(title: const Text("Relationship")),
  body: Column(
    children: [

      ElevatedButton(
        onPressed: () {
          RelationshipService.sendRequest(myId, "user_2");
        },
        child: const Text("Send Love Request ❤️"),
      ),

      ElevatedButton(
        onPressed: () {
          RelationshipService.breakUp("doc_id");
        },
        child: const Text("Break Up 💔"),
      ),
    ],
  ),
);

}
}