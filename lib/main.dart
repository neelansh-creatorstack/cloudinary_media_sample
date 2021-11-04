import 'package:cloudinary_media_sample/video_feed_post_widget.dart';
import 'package:flutter/material.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          //original url, WORKING FINE
          Text(
              'WORKING URL: https://res.cloudinary.com/creatorstack/video/upload/creatorstack-static-staging/a64ed2f2-67be-4e4e-ab82-ceb9011834b6.mp4'),
          VideoFeedPostWidget(
              videoUrl:
                  'https://res.cloudinary.com/creatorstack/video/upload/creatorstack-static-staging/a64ed2f2-67be-4e4e-ab82-ceb9011834b6.mp4'),
          SizedBox(
            height: 16,
          ),
          Text(
              'NOT WORKING URL: https://res.cloudinary.com/creatorstack/video/upload/w_1080/creatorstack-static-staging/a64ed2f2-67be-4e4e-ab82-ceb9011834b6.m3u8'),
          //transformed url, NOT WORKING
          VideoFeedPostWidget(
              videoUrl:
                  'https://res.cloudinary.com/creatorstack/video/upload/w_1080/creatorstack-static-staging/a64ed2f2-67be-4e4e-ab82-ceb9011834b6.m3u8')
        ],
      ),
    );
  }
}
