import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = "正在下载数据...";

  void download() async {
    try {
      http.Response response =
          await http.get("http://www.ysts8.com/index_hot.html");
      String data = gbk.decode(response.bodyBytes);
      setState(() {
        _text = data;
      });
    } catch (e) {
      setState(() {
        _text = "网络异常，请检查";
      });
    }
  }

  @override
  void initState() {
    download();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SingleChildScrollView(
        child: new Text(_text),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
