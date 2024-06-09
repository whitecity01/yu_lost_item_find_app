import 'package:flutter/material.dart';
import 'package:yu_lost_item/screens/home/find_item/search_by_map_page.dart';
import 'package:yu_lost_item/screens/home/find_item/search_item_page.dart';

class FindItemPage extends StatelessWidget {
  const FindItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("분실물 찾기"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, "지도로 검색", const SearchByMapPage()),
            const SizedBox(height: 50.0),
            buildButton(context, "분실물 검색", const SearchItemsPage()),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildButton(BuildContext context, String text, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 40),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
    );
  }
}
