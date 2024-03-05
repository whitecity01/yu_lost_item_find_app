import 'package:flutter/material.dart';
import 'package:yu_lost_item/screens/home/report_item/report_form_widget.dart';
import 'package:yu_lost_item/widgets/my_app_bar.dart';

class ReportItemPage extends StatelessWidget {
  const ReportItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '분실물 신고',
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.65,
            color: const Color.fromARGB(255, 212, 219, 225),
            child: ReportFormWidget(),
          ),
        ),
      ),
    );
  }
}
