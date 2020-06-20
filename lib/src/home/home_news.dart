import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indian_news/src/detail/news_detail.dart';
import 'package:indian_news/src/home/news_model.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List<News> newsHeadlines = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future fetchNews() async {
    var now = new DateTime.now();
    var currentDate = "${now.day}-${now.month}-${now.year}";
    const newsAPI =
        "http://newsapi.org/v2/everything?q=apple&from=2020-06-19&to=2020-06-19&sortBy=popularity&apiKey=5c66f9ee9171404f9adb600b107c71e0";
    var response = await http.get(newsAPI);
    if (response.statusCode == 200) {
      var newsHeadlines = json.decode(response.body);
      List articles = newsHeadlines["articles"];
      articles.forEach((article) {
        article = News.fromJson(article);
        setState(() {
          this.newsHeadlines.add(article);
        });
      });
    } else {
      setState(() {
        loading = false;
        return showError();
      });
    }

    setState(() {
      loading = false;
    });
    return this.newsHeadlines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Good Morning\n21-06-2020 (Monday)',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold, fontSize: 17)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Shailesh's Briefing",
              style:
                  GoogleFonts.lato(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Top 5 stories at the moment...",
              style:
                  GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 100,
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.amber, shape: BoxShape.circle),
                          child: Center(
                              child: Text(
                            "$index",
                            style: GoogleFonts.lato(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    );
                  }),
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlue,
                  strokeWidth: 3,
                ))
              : Expanded(
                  child: Container(
                      child: ListView.builder(
                          itemCount: newsHeadlines.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: newsHeadlines[
                                                            index]
                                                        .urlToImage ==
                                                    null
                                                ? NetworkImage(
                                                    'https://via.placeholder.com/150')
                                                : NetworkImage(
                                                    newsHeadlines[index]
                                                        .urlToImage),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          title: Text(
                                            newsHeadlines[index].title,
                                            maxLines: 1,
                                            style: GoogleFonts.lato(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              newsHeadlines[index]
                                                          .description !=
                                                      null
                                                  ? Text(
                                                      newsHeadlines[index]
                                                          .description,
                                                      style: GoogleFonts.lato(
                                                          fontSize: 12,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                      maxLines: 3)
                                                  : Container(),
                                            ],
                                          ),
                                          //contentPadding: EdgeInsets.all(4),

                                          onTap: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsDetails(
                                                        news: newsHeadlines[
                                                            index],
                                                      )),
                                            )
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.radio,
                                                  size: 20,
                                                  color: Colors.grey.shade500,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  newsHeadlines[index].name,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.grey.shade500,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  newsHeadlines[index]
                                                      .publishedAt
                                                      .split("T")[0],
                                                  style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                  maxLines: 2,
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    )));
                          })),
                ),
        ]));
  }
}

Widget showError() {
  return Container(
    child: Center(
      child: Text(
        "Not News Found, Hope world is safe",
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
    ),
  );
}
