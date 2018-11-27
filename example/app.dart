import 'package:flutter/material.dart';
import 'package:flutter_paging/flutter_paging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: MainScreen(),
    );
  }
}

class DataSource with PagedDataSource {

  List<String> data = [];

  @override
  Future loadInitial() async {
    await Future.delayed(Duration(seconds: 5));

    data.addAll(List.generate(30, (index) => "Text $index"));

    return Future.value(data);
  }

  @override
  Future loadAfter() async {
    await Future.delayed(Duration(seconds: 3));

    data.addAll(List.generate(30, (index) => "Text $index"));

    return Future.value(data);
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  DataSource dataSource = DataSource();

  @override
  Widget build(BuildContext context) {

    print(dataSource.data.length);

    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Reddit"),
      ),
      body: Container(
        child: PagedList(
          list: () => Sliver
          loadingIndicator: CircularProgressIndicator(),
          pagedDataSource: dataSource,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text("Feed"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            title: Text("Subreddits"),
          ),
        ],
      ),
    );
  }
}

