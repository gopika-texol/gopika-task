import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:gpbproj/services/sharedPreferences.dart';
import 'package:gpbproj/staticClasses.dart';
import 'commentscreen.dart';
import 'models/postmodel.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url =
      "https://hiit.ria.rocks/videos_api/cdn/com.rstream.crafts?versionCode=40&lurl=Canvas%20painting%20ideas";

  List<String> bookMarkedList = [];
  @override
  void initState() {
    SharedPrefernceClass.getBookmark().then((value) => bookMarkedList = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: this._fetchData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      DioError error = snapshot.error as DioError;
                      String message = error.message;
                      if (error.type == DioErrorType.connectTimeout)
                        message = 'Connection Timeout';
                      else if (error.type == DioErrorType.receiveTimeout)
                        message = 'Receive Timeout';
                      else if (error.type == DioErrorType.response)
                        message =
                            '404 server not found ${error.response!.statusCode}';
                      return Text('Error: ${message}');
                    }

                    Response response = snapshot.data as Response;
                    PostModelClass.postList = List.generate(
                        response.data!.length,
                        (index) => PostModel.fromJson(response.data![index]));
                    bookMarkedList.forEach((element) {
                      PostModelClass.postList
                          .firstWhere((post) => post.id == element,
                              orElse: () => PostModel(
                                  id: "",
                                  channelname: "",
                                  bookmarked: false,
                                  highThumbnail: '',
                                  lowThumbnail: '',
                                  mediumThumbnail: '',
                                  title: ''))
                          .bookmarked = true;
                    });
                    return Expanded(
                        child: ListView.builder(
                      itemCount: PostModelClass.postList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleListItem(
                            postModel: PostModelClass.postList[index]);
                      },
                    ));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _fetchData() async {
    Dio dio = new Dio();
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 30000;
    Response response = await dio.get(url);

    return response;
  }
}

class SingleListItem extends StatefulWidget {
  const SingleListItem({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  final PostModel postModel;

  @override
  _SingleListItemState createState() => _SingleListItemState();
}

class _SingleListItemState extends State<SingleListItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              new NetworkImage(widget.postModel.lowThumbnail)),
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Text(
                    widget.postModel.channelname,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              new IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: null,
              )
            ],
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: new Image.network(
            widget.postModel.highThumbnail,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.heart,
                    size: 30,
                    color: Colors.black,
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentScreen()),
                      );
                    },
                    child: new Icon(
                      FontAwesomeIcons.comment,
                      size: 30,
                    ),
                  ),
                  new SizedBox(
                    width: 16.0,
                  ),
                  new Icon(
                    FontAwesomeIcons.paperPlane,
                    size: 30,
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  print("bookmark");
                  setState(() {
                    widget.postModel.bookmarked = !widget.postModel.bookmarked;
                  });
                  await SharedPrefernceClass.saveBookmark();
                },
                icon: new Icon(
                  widget.postModel.bookmarked
                      ? FontAwesomeIcons.solidBookmark
                      : FontAwesomeIcons.bookmark,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                      maxLines: widget.postModel.maxLines,
                      text: TextSpan(children: [
                        TextSpan(
                            text: widget.postModel.channelname + " ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.postModel.title,
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      ])),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.postModel.maxLines = 10;
                    });
                  },
                  child: Text(" More",
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                )
              ],
            )),
        SizedBox(height: 10),
      ],
    );
  }
}
