import 'package:flutter/material.dart';
import 'detail_info.dart';
import 'search_result.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'constants.dart';
import 'model/recently_viewed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '우리말 국어 사전',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/search_result': (context) => const SearchResult(searchWord: ''),
        '/detail_info': (context) => const DetailInfo()
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  searchGo(searchWord) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchResult(searchWord: searchWord))
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Platform.isAndroid : ${Platform.isAndroid}');
    print('Platform.isIOS : ${Platform.isIOS}');
    TextEditingController searchControl = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              textInputAction: TextInputAction.go,
              onSubmitted: (value) async {
                searchGo(value);
              },
              controller: searchControl,
              style: TextStyle(color: kDarkGreenColor),
              cursorColor: kDarkGreenColor,
              decoration: InputDecoration(
                filled: true,
                fillColor: kGinColor,
                hintText: '검색어를 입력하세요',
                hintStyle: TextStyle(color: kGreyColor),
                prefixIcon: Icon(
                  Icons.search,
                  color: kDarkGreenColor,
                  size: 26.0,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: kGinColor),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kGinColor),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kGinColor),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: kDarkGreenColor,
                size: 26.0,
              ),
              iconSize: 50,
              onPressed: () {
                searchGo(searchControl.value.text);
              },
            ),
            Row(
              children: <Widget>[
                Text(
                  '최근 검색어',
                  style: TextStyle(
                    color: kDarkGreenColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('검색어 삭제')
              ],
            ),
            Padding(
              padding:
              const EdgeInsets.only(top: 20.0, bottom: 16.0),
              child: Text(
                '최근 검색어',
                style: TextStyle(
                  color: kDarkGreenColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 60.0,
              child: ListView.separated(
                itemCount: viewed.length,
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return RecentlyViewedCard(
                    plantName: viewed[index].plantName,
                    plantInfo: viewed[index].plantInfo
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 20.0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentlyViewedCard extends StatelessWidget {
  const RecentlyViewedCard({
    required this.plantName,
    required this.plantInfo,
    Key? key,
  }) : super(key: key);

  final String plantName;
  final String plantInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              plantName,
              style: GoogleFonts.poppins(
                color: kDarkGreenColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              plantInfo,
              style: GoogleFonts.poppins(
                color: kGreyColor,
              ),
            )
          ],
        ),
      ],
    );
  }
}

List<ViewHistory> viewed = [
  ViewHistory('Calathea', 'It\'s spines don\'t grow.'),
  ViewHistory('Cactus', 'It has spines.'),
  ViewHistory('Stephine', 'It\'s spines do grow.'),
];
