import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yu_lost_item/config/api.dart';
import 'package:yu_lost_item/screens/main_page.dart';
import 'package:yu_lost_item/screens/signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  // 로고
                  'assets/yu_logo.png',
                  width: 261,
                  height: 220,
                ),
                const Text(
                  // 앱 제목
                  "영남대 분실물 찾기 앱",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // 로그인 입력
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Your email address',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                ]),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: const Text('회원가입'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final loginDto = jsonEncode({
                      // login DTO 생성
                      'email': emailController.text,
                      'password': passwordController.text,
                    });

                    final res = await sendToServer(loginDto); // 로그인 요청
                    print(res);
                    if (context.mounted) {
                      // res == 200 추가 해야함
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      );
                    } else {
                      print('로그인 실패');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: const Text(
                      "로그인",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<int> sendToServer(Object loginDto) async {
  print(loginDto);
  final res = await http.post(
    Uri.parse("$serverIp/auth/signin"),
    headers: {'Content-Type': 'application/json'},
    body: loginDto,
  );

  return res.statusCode;
}
