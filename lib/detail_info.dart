import 'package:flutter/material.dart';

class DetailInfo extends StatefulWidget {
  const DetailInfo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailInfo();
  }

}

class _DetailInfo extends State<DetailInfo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('SEARCH RESULT'),
      ),
    );
  }

}
