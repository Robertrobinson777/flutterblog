import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PostScreen extends StatefulWidget {
  final post;
  final pimg;

  PostScreen({Key key, @required this.post, this.pimg}) : super(key: key);
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.post['title']['rendered']),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: widget.post["featured_media"] == 0
                      ? new Image(image: widget.pimg)
                      : new FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.post["_embedded"]["wp:featuredmedia"][0]
                              ["source_url"],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    widget.post['content']['rendered'],
                    webView: true,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
