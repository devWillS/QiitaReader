import 'package:flutter/material.dart';
import 'package:qiitareader/entity/Article.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/QiitaClient.dart';
import 'assets/QiitaColors.dart';
import 'extensions/DateExtension.dart';

List<Article> itemList = [];
ScrollController _scrollController;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF55C500, QiitaColors.primaryColor),
      ),
      home: MyHomePage(title: 'Qiita Reader'),
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
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
      ),
      body: new RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  _launchURL(itemList[index].url);
                },
                child: Container(
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            alignment: Alignment(1.0, 1.0),
                            child: Text(
                              itemList[index].createdAt.formatDate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          new Container(
                            child: Text(
                              itemList[index].title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.only(
                                top: 5,
                                bottom: 5
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.only(
                                  right: 5,
                                ),
                                child: Image.network(
                                  itemList[index].user.iconUrl,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              Text(
                                "@" + itemList[index].user.id,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            );
            },
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    if (QiitaClient.loading) {
      return;
    }
    QiitaClient.refresh().then((articles) {
      setState(() {
        itemList = articles;
      });
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _scrollListener() async {
    await new Future.delayed(new Duration(milliseconds: 500));
    double positionRate =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    const threshold = 0.99;
    if (positionRate > threshold) {
      if (QiitaClient.loading) {
        return;
      }
      QiitaClient.next().then((articles) {
        setState(() {
          itemList += articles;
        });
      });
    }
  }
}
