import 'dart:convert';

import 'package:gpbproj/models/postmodel.dart';

class PostModelClass{
  static  List<PostModel> postList = [];
  
  static String encode(List<String> idList) => json.encode(idList);

  static List<String> decode(String idEncoded) =>
      json.decode(idEncoded).toList().cast<String>();
}