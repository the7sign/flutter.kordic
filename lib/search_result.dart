import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kordic/const_key.dart';
import 'package:http/http.dart' as http;

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, required this.searchWord});

  final String searchWord;

  @override
  State<StatefulWidget> createState() {
    return _SearchResult();
  }

}

class _SearchResult extends State<SearchResult> {

  void _callApi() async {
    String sword = widget.searchWord;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    };
    Map<String, String> data = {"searchWord" : sword, "page" : "1", "pageCnt": "15" };
    final url = Uri.https(ConstKey.apiServer, ConstKey.searchKorUrl, data);
    final response = await http.post(url, headers: headers);

    print(utf8.decode(response.bodyBytes));
  }

  @override
  Widget build(BuildContext context) {
    _callApi();
    return Scaffold(
      body: Center(
        child: Text(widget.searchWord),
      ),
    );
  }

}
