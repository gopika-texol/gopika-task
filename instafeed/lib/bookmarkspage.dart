import 'package:flutter/material.dart';
import 'package:gpbproj/staticClasses.dart';

import 'models/postmodel.dart';
import 'newscreen.dart';

class BookMarksPage extends StatefulWidget {
  @override
  _BookMarksPageState createState() => _BookMarksPageState();
}

class _BookMarksPageState extends State<BookMarksPage> {
  List<PostModel> bookmarkList = [];
  @override
  void initState() {
    bookmarkList = PostModelClass.postList
        .where((element) => element.bookmarked == true)
        .toList()
        .cast<PostModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: bookmarkList.length,
        itemBuilder: (BuildContext context, int index) {
          return SingleListItem(postModel: bookmarkList[index]);
        },
      ),
    );
  }
}
