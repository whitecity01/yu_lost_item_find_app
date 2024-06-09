import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class KakaoMapPage extends StatefulWidget {
  const KakaoMapPage({super.key, this.latitude, this.longitude});

  final double? latitude;
  final double? longitude;

  @override
  State<KakaoMapPage> createState() => KakaoMapPageState();
}

class KakaoMapPageState extends State<KakaoMapPage> {
  late KakaoMapController mapController;

  void updateLocation(double latitude, double longitude) {
    setState(() {
      mapController.setCenter(LatLng(latitude, longitude));
      addMarker(latitude, longitude);
    });
  }

  void addMarker(double latitude, double longitude) {
    final marker = Marker(
      markerId: 'marker_${latitude}_$longitude',
      latLng: LatLng(latitude, longitude),
      width: 40,
      height: 40,
      markerImageSrc: '',
      infoWindowContent: '이곳입니다',
    );
    mapController.addMarker(markers: [marker]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KakaoMap(
        onMapCreated: (controller) {
          mapController = controller;
          if (widget.latitude != null && widget.longitude != null) {
            mapController
                .setCenter(LatLng(widget.latitude!, widget.longitude!));
            addMarker(widget.latitude!, widget.longitude!);
          }
        },
        onMapTap: (latLng) {
          debugPrint('***** [JHC_DEBUG] ${latLng.toString()}');
        },
      ),
    );
  }
}
