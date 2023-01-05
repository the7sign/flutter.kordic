import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _SearchResult();
  }

}

class _SearchResult extends State<SearchResult> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.title),
      ),
    );
  }

}
