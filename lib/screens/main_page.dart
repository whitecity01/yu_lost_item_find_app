import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              const SizedBox(height: 50.0),
              Image.asset(
                // 로고
                'assets/yu_logo.png',
                width: 261,
                height: 220,
              ),
              const SizedBox(height: 25.0),
              buildButton(context, "분실물 신고", MainPage()),
              const SizedBox(height: 50.0),
              buildButton(context, "분실물 찾기", MainPage()),
            ],
          ),
        ),
      ),
    );
  }
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
      padding: const EdgeInsets.fromLTRB(40, 35, 40, 35),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 25),
      ),
    ),
  );
}