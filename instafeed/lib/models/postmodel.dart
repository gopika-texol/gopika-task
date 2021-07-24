import 'dart:convert';

class PostModel {
  late String id;
  late String channelname;
  late String title;
  late String highThumbnail;
  late String lowThumbnail;
  late String mediumThumbnail;
  int maxLines = 1;
  bool bookmarked = false;

  PostModel(
      {required this.id,
      required this.channelname,
      required this.title,
      required this.highThumbnail,
      required this.lowThumbnail,
      required this.mediumThumbnail,
      this.maxLines: 1,
      this.bookmarked: false});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelname = json['channelname'];
    title = json['title'];
    highThumbnail = json['high thumbnail'];
    lowThumbnail = json['low thumbnail'];
    mediumThumbnail = json['medium thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channelname'] = this.channelname;
    data['title'] = this.title;
    data['high thumbnail'] = this.highThumbnail;
    data['low thumbnail'] = this.lowThumbnail;
    data['medium thumbnail'] = this.mediumThumbnail;
    return data;
  }

  
}
