import 'dart:convert';

import 'package:blog/page.dart';
import 'package:blog/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final String apiUrl = "https://robertrobinson.in/wp-json/wp/v2/";
  final String apiUrl = "https://www.hthirukkumaran.com/wp-json/wp/v2/";

  var assetsImage = new AssetImage('assets/640x360.png');

  List posts;
  List pages;

  @override
  void initState() {
    super.initState();
    this.getPosts();
    this.getPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blog'),
        ),
        drawer: Drawer(
          child: pages == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: pages == null ? 0 : pages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        pages[index]["title"]["rendered"],
                        style: new TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) =>
                                new PageScreen(url: pages[index]),
                          ),
                        );
                      },
                    );
                  }),
        ),
        body: posts == null
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: posts == null ? 0 : posts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Card(
                        child: Column(
                          children: <Widget>[
                            posts[index]["featured_media"] == 0
                                ? new Image(image: assetsImage)
                                : FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: posts[index]["_embedded"]
                                        ["wp:featuredmedia"][0]["source_url"],
                                  ),
                            new Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new ListTile(
                                  title: new Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: new Text(
                                          posts[index]["title"]["rendered"])),
                                  subtitle: new Text(posts[index]["excerpt"]
                                          ["rendered"]
                                      .replaceAll(new RegExp(r'<[^>]*>'), '')),
                                )),
                            new ButtonBar(
                              children: <Widget>[
                                new FlatButton(
                                  child: const Text('READ MORE'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => new PostScreen(
                                            post: posts[index],
                                            pimg: assetsImage),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ));
  }

  Future<String> getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });

    return "Success!";
  }

  Future<String> getPages() async {
    var pageres = await http.get(Uri.encodeFull(apiUrl + "pages"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resPageBody = json.decode(pageres.body);
      pages = resPageBody;
    });
    return "Success!";
  }
}
