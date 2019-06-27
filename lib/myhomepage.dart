import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:news_app/model/NewsItem.dart';
import 'package:news_app/ui/listnews.dart';
import 'DetailNews.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var responseListData;
  bool loading;
  String isiResponse = '';

  Future<List<Article>> getData(String newsType) async {
    List<Article> list;
    String link =
        "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=980d8d512d494e2393504db4809c0d25";
    var res = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["articles"] as List;
      print(rest);
      list = rest.map<Article>((json) => Article.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  Widget listViewWidget(List<Article> article) {
    return Container(
      child: ListView.builder(
          itemCount: article.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  var pindahHalaman = MaterialPageRoute(
                      builder: (context) => DetailNews(
                            title: '${article[position].title}',
                            urlToImage: '${article[position].urlToImage}',
                            content: '${article[position].content}',
                            publishedAt: '${article[position].publishedAt}',
                          ));
                  Navigator.push(context, pindahHalaman);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Image.network(
                            '${article[position].urlToImage}',
                            fit: BoxFit.fill,
                            width: 300,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${article[position].title}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 15),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  '${article[position].author}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10, right: 15),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  '${article[position].publishedAt}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[400]),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: getData(widget.title),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
