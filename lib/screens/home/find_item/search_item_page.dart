import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yu_lost_item/config/api.dart';
import 'package:yu_lost_item/screens/home/find_item/report_item_detail_page.dart';

class SearchItemsPage extends StatefulWidget {
  const SearchItemsPage({super.key});

  @override
  _SearchItemsPageState createState() => _SearchItemsPageState();
}

class _SearchItemsPageState extends State<SearchItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchItems() async {
    setState(() {
      _isLoading = true;
    });

    final String searchQuery = _searchController.text.trim();
    final String apiUrl = '$serverIp/searchItems?query=$searchQuery';

    try {
      Response response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        setState(() {
          _searchResults = response.data;
        });
      } else {
        print('검색 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('검색 요청 에러: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("분실물 검색"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '검색어를 입력하세요',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchItems,
                ),
              ),
              onSubmitted: (_) => _searchItems(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: _searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final item = _searchResults[index];
                              return ListTile(
                                title: Text(item['title'] ?? '제목 없음'),
                                subtitle: Text(
                                    '맡긴 장소: ${item['assignLocation'] ?? '장소 정보 없음'}'),
                                trailing: Text(
                                    '찾은시각 :  ${item['findDate'] ?? '날짜 정보 없음'}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ReportItemDetailPage(
                                        itemId: item['id'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const Center(
                            child: Text('검색 결과가 없습니다.'),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
