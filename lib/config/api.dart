import 'package:flutter_dotenv/flutter_dotenv.dart';

String? serverIp;
void getEnv() async {
  await dotenv.load();
  serverIp = dotenv.get("SERVER_IP");
}
