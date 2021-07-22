import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'PDF View'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url =
      "https://www.au-sonpo.co.jp/corporate/upload/article/89/article_89_1.pdf";

  void _refresh() {
    setState(() {
      // other _url
      _url =
          "https://www.au-sonpo.co.jp/corporate/upload/article/90/article_90_1.pdf";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Uint8List>(
        future: _fetchPdfContent(_url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PdfPreview(
              allowPrinting: false,
              allowSharing: false,
              canChangePageFormat: false,
              initialPageFormat:
                  PdfPageFormat(100 * PdfPageFormat.mm, 120 * PdfPageFormat.mm),
              build: (format) => snapshot.data,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refesh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<Uint8List> _fetchPdfContent(final String url) async {
    try {
      final Response<List<int>> response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
