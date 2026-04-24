/// ===============================
/// FILE: lib/screens/search_screen.dart
/// ===============================
library;

import 'package:flutter/material.dart';
import '../services/search_service.dart';

class SearchScreen extends StatefulWidget {
const SearchScreen({super.key});

@override
State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

final SearchService _searchService = SearchService();
final TextEditingController _controller = TextEditingController();

List<String> results = [];

void onSearch(String query) {
setState(() {
results = _searchService.search(query);
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,

  appBar: AppBar(
    backgroundColor: Colors.black,
    title: TextField(
      controller: _controller,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: "Search user, video, product...",
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
      onChanged: onSearch,
    ),
  ),

  body: results.isEmpty
      ? const Center(
          child: Text(
            "Search something...",
            style: TextStyle(color: Colors.grey),
          ),
        )
      : ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                results[index],
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
);

}
}