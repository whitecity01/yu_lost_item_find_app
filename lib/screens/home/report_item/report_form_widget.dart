import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yu_lost_item/config/api.dart';
import 'package:yu_lost_item/widgets/success_alert.dart';

class ReportFormWidget extends StatefulWidget {
  const ReportFormWidget({super.key});

  @override
  State<ReportFormWidget> createState() => _ReportFormWidgetState();
}

class _ReportFormWidgetState extends State<ReportFormWidget> {
  final titleController = TextEditingController();
  final assignLocationController = TextEditingController();
  double latitude = 0;
  double longitude = 0;
  String findDate = "";
  XFile? _image; // 이미지 저장
  String selectedItem = "etc";

  final Map<String, String> items = {
    '전자제품': 'electro_goods',
    '액세서리': 'accessory',
    '의류': 'clothes',
    '가방': 'bag',
    '금품': 'cash',
    '책': 'book',
    '기타': 'etc',
  };

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    try {
      // 갤러리에서 사진 선택
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      switch (e.code.toLowerCase()) {
        case 'photo_access_denied':
          print(e.code);
          break;
        default:
          print(e.code);
          break;
      }
    } catch (e) {
      print(e);
    }

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      readExifData();
    }
  }

  double convertToDecimal(List values) {
    double degrees = values[0] is Ratio
        ? values[0].numerator / values[0].denominator
        : values[0];
    double minutes = values[1] is Ratio
        ? values[1].numerator / values[1].denominator
        : values[1];
    double seconds = values[2] is Ratio
        ? values[2].numerator / values[2].denominator
        : values[2];

    return degrees + (minutes / 60) + (seconds / 3600);
  }

  readExifData() async {
    if (_image != null) {
      final fileBytes = File(_image!.path).readAsBytesSync();
      final data = await readExifFromBytes(fileBytes);

      if (data.isEmpty) {
        print("No EXIF information found");
        return;
      }

      if (data.containsKey('EXIF DateTimeOriginal')) {
        IfdTag? imageDateTime = data['EXIF DateTimeOriginal'];
        if (imageDateTime != null) {
          // imageDateTime.values.toList()가 Uint8List 타입을 반환한다고 가정
          List byteData = imageDateTime.values.toList();
          // 바이트 데이터를 문자열로 변환
          findDate = String.fromCharCodes(byteData as Iterable<int>);
          print(findDate);
        } else {
          print("EXIF DateTimeOriginal not found");
        }
      } else {
        print("?");
      }

      print('Path : ${_image!.path}');
      if (data.containsKey('GPS GPSLatitude') &&
          data.containsKey('GPS GPSLongitude')) {
        IfdTag? latitudeTag = data['GPS GPSLatitude'];
        IfdTag? longitudeTag = data['GPS GPSLongitude'];

        List latitudeValues = latitudeTag!.values.toList();
        List longitudeValues = longitudeTag!.values.toList();

        latitude = convertToDecimal(latitudeValues);
        longitude = convertToDecimal(longitudeValues);

        print(latitude);
        print(longitude);
      } else {
        print("No GPS information found");
      }
    }
  }

  Future<void> _reportItem() async {
    final Map<String, dynamic> reportItemDto = {
      'title': titleController.text,
      'assignLocation': assignLocationController.text,
      'findDate': findDate,
      'latitude': latitude,
      'longitude': longitude,
      'itemCategory': selectedItem,
    };

    String reportItemDtoJson = jsonEncode(reportItemDto);

// reportItemDtoJson을 MultipartFile로 변환
    MultipartFile reportItemDtoFile = MultipartFile.fromString(
      reportItemDtoJson,
      filename: 'reportItemDto.json', // 필요한 경우 적절한 파일명 지정
      contentType: MediaType('application', 'json'), // MIME 타입 지정
    );

    FormData formData = FormData();
    formData.files.addAll([
      MapEntry(
        "image",
        await MultipartFile.fromFile(_image!.path, filename: 'myImage.jpg'),
      ),
      MapEntry(
        "reportItemDto",
        reportItemDtoFile,
      ),
    ]);
    //print(formData)

    Dio dio = Dio();
    await dio.post("$serverIp/reportItem", data: formData);
    print(dio);

    if (dio == 200 && context.mounted) {
      //Navigator.pop(context);
      successAlert(context, "회원가입이 정상적으로 완료되었습니다.");
    } else {
      print('회원가입 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: getInputDecoration(labelText: '제목'),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: assignLocationController,
          decoration: getInputDecoration(labelText: '맡긴 장소'),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '카테고리',
                  labelStyle: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 0, 0, 0)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                value: selectedItem,
                hint: const Text('항목을 선택하세요'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue!;
                  });
                },
                items: items.entries.map<DropdownMenuItem<String>>(
                    (MapEntry<String, String> entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: () => _pickImage(),
            child: const Text("이미지 업로드"),
          ),
        ),
        const SizedBox(
          height: 110,
        ),
        ElevatedButton(
          onPressed: () => _reportItem(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: const Text(
              "분실물 신고",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

// 커스텀 InputDecoration
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
    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
  );
}
