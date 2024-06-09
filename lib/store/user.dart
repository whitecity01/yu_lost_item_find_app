import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserId(String id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_id', id);
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}
