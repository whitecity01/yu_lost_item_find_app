import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yu_lost_item/src/Week1.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final pwController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/yu_logo.png',
                width: 261,
                height: 220,
              ),
              const Text(
                "영남대 분실물 찾기 앱",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'Id',
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
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: pwController,
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
                ),
              ]),
              GestureDetector(
                onTap: () async {
                  // 컨트롤러를 사용하여 텍스트 필드의 텍스트를 가져옵니다.
                  final id = idController.text;
                  final pw = pwController.text;
                  // DTO를 만듭니다.
                  final loginData = jsonEncode({
                    'id': id,
                    'pw': pw,
                  });

                  // 서버에 DTO를 보냅니다.
                  final result = await sendToServer(loginData);
                  if (result == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Week1()),
                    );
                  } else {
                    print('Login failed.');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                  child: const Text(
                    "로그인",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<int> sendToServer(Object loginData) async {
  print(loginData);
  final response = await http.post(
    Uri.parse("https://example.com/login"),
    headers: {'Content-Type': 'application/json'},
    body: loginData,
  );

  // 응답 상태 코드를 반환합니다.
  return response.statusCode;
}
