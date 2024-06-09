import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yu_lost_item/config/api.dart';

class ReportItemDetailPage extends StatelessWidget {
  final int itemId;

  const ReportItemDetailPage({super.key, required this.itemId});

  Future<Map<String, dynamic>> _fetchItemDetail() async {
    final String apiUrl = '$serverIp/reportItem/$itemId';
    try {
      Response response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load item detail');
      }
    } catch (e) {
      throw Exception('Failed to load item detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("분실물 상세 정보"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchItemDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('데이터가 없습니다.'));
          } else {
            final item = snapshot.data!['reportItem'];
            final imageUrl = snapshot.data!['s3Url'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '제목 없음',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8),
                      Text(
                        '맡긴 위치: ${item['assignLocation'] ?? '정보 없음'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                        '찾은 날짜: ${item['findDate'] ?? '정보 없음'}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '카테고리: ${item['itemCategory'] ?? '정보 없음'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  imageUrl != null
                      ? Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                            maxHeight: 400,
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Text('이미지 없음'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
