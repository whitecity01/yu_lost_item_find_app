import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yu_lost_item/config/api.dart';
import 'package:yu_lost_item/widgets/success_alert.dart';
import 'package:yu_lost_item/widgets/warning_alert.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFAFDFB),
        leading: Tooltip(
          message: 'Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)}, // 눌렀을 때 이벤트
            color: Colors.black, // 버튼 색
          ),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // 로그인 입력
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: nameController,
                    decoration: getInputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: emailController,
                    decoration: getInputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: phoneController,
                    decoration: getInputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: passwordController,
                    decoration: getInputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    controller: passwordCheckController,
                    decoration: getInputDecoration(labelText: 'Password Check'),
                  ),
                  const SizedBox(height: 25.0),
                ]),
                ElevatedButton(
                  onPressed: () async {
                    // 비밀번호 일치 확인
                    if (passwordController.text !=
                        passwordCheckController.text) {
                      warningAlert(context, "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                      return;
                    }

                    final signupDto = jsonEncode({
                      // signup DTO 생성
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'password': passwordController.text,
                    });

                    final res = await sendToServer(signupDto); // 로그인 요청
                    print(res);
                    if (res == 200 && context.mounted) {
                      Navigator.pop(context);
                      successAlert(context, "회원가입이 정상적으로 완료되었습니다.");
                    } else {
                      print('회원가입 실패');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: const Text(
                      "회원가입",
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

Future<int> sendToServer(Object signupDto) async {
  final res = await http.post(
    Uri.parse("$serverIp/auth/signup"),
    headers: {'Content-Type': 'application/json'},
    body: signupDto,
  );

  return res.statusCode;
}

InputDecoration getInputDecoration({required String labelText}) {
  return InputDecoration(
    labelText: labelText,
    hintText: "Input your $labelText",
    labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    filled: true,
    fillColor: const Color.fromARGB(255, 255, 255, 255),
    border: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
  );
}
