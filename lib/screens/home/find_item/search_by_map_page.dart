import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yu_lost_item/config/api.dart';
import 'package:yu_lost_item/screens/home/find_item/kakao_map_page.dart';
import 'package:yu_lost_item/screens/home/find_item/report_item_detail_page.dart';

class SearchByMapPage extends StatefulWidget {
  const SearchByMapPage({super.key});
  @override
  _SearchByMapPageState createState() => _SearchByMapPageState();
}

class _SearchByMapPageState extends State<SearchByMapPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic>? _searchResults;
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  final GlobalKey<KakaoMapPageState> _kakaoMapKey =
      GlobalKey<KakaoMapPageState>();

  @override
  void initState() {
    super.initState();
    _latitude = 35.8314265;
    _longitude = 128.7536594;
  }

  Future<void> _searchItems() async {
    setState(() {
      _isLoading = true;
      _searchResults = null;
    });

    final String searchQuery = _searchController.text.trim();
    final String apiUrl = '$serverIp/searchItems?query=$searchQuery';

    try {
      Response response = await Dio().get(apiUrl);
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _searchResults = response.data;

          if (_searchResults != null && _searchResults!.isNotEmpty) {
            final firstResult = _searchResults![0];
            final double newLatitude =
                double.tryParse(firstResult['latitude'].toString()) ?? 1.0;
            final double newLongitude =
                double.tryParse(firstResult['longitude'].toString()) ?? 1.0;

            _latitude = newLatitude;
            _longitude = newLongitude;

            _kakaoMapKey.currentState
                ?.updateLocation(newLatitude, newLongitude);
            _kakaoMapKey.currentState?.addMarker(newLatitude, newLongitude);
          }
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
        title: const Text("지도로 검색"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                if (_latitude != null && _longitude != null)
                  KakaoMapPage(
                    key: _kakaoMapKey,
                    latitude: _latitude,
                    longitude: _longitude,
                  ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: '제목 검색',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _searchItems,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _searchResults != null && _searchResults!.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults!.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults![index];
                      final title = item['title'] ?? '제목 없음';
                      final location = item['assignLocation'] ?? '장소 정보 없음';
                      final findDate = item['findDate'] ?? '날짜 정보 없음';

                      return ListTile(
                        title: Text(title),
                        subtitle: Text("맡긴 장소: $location"),
                        trailing: Text(findDate),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportItemDetailPage(
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
    );
  }
}
