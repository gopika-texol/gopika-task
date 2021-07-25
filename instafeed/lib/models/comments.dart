class Comments {
  final String username;
  final String comments;

  Comments({required this.username, required this.comments});
  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      username: json['username'],
      comments: json['comments'],
    );
  }
}
