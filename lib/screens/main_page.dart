import 'package:flutter/material.dart';
import 'package:yu_lost_item/screens/home/find_item/find_item_page.dart';
import 'package:yu_lost_item/screens/home/profile/profile_page.dart';
import 'package:yu_lost_item/screens/home/report_item/report_item_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "분실물 찾기 앱",
        ),
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/yu_logo.png',
                width: 200,
                height: 180,
              ),
              const SizedBox(height: 30.0),
              buildButton(
                  context, "분실물 신고", const ReportItemPage(), Icons.report),
              const SizedBox(height: 40.0),
              buildButton(
                  context, "분실물 찾기", const FindItemPage(), Icons.search),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildButton(
      BuildContext context, String text, Widget page, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 16, 77, 184),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
