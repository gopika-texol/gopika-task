import 'dart:convert';

import 'package:gpbproj/models/postmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../staticClasses.dart';

class SharedPrefernceClass {
  //
  static Future saveBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'bookmark',
        PostModelClass.encode(PostModelClass.postList
            .where((element) => element.bookmarked == true)
            .toList()
            .cast<PostModel>()
            .map((e) => e.id)
            .toList()));
  }

  static Future<List<String>> getBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bookMarkString = (prefs.getString('bookmark') ?? "['fdsdf']");
    print("json.decode " +
        json.decode(bookMarkString).toList().cast<String>().length.toString());
   
    return PostModelClass.decode(bookMarkString).toList().cast<String>();
  }
}
