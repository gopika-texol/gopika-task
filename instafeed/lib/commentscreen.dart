import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/comments.dart';
import 'package:http/http.dart' as http;

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late Future<List<Comments>> futreComments;
  Future<List<Comments>> fetchComments() async {
    final response =
        await http.get(Uri.parse('http://cookbookrecipes.in/test.php'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return parseComments(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  List<Comments> parseComments(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Comments>((json) => Comments.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    futreComments = fetchComments();
  }

  Widget _showComment() {
    return FutureBuilder<List<Comments>>(
      future: futreComments,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? _listComments(snapshot.data!)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _listComments(List<Comments> comments) {
    return ListView(children: comments.map((e) => _buildTile(e)).toList());
  }

  Widget _buildTile(Comments comment) {
    return ListTile(
      title: Text(comment.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),
      subtitle: Text(comment.comments,
          style: const TextStyle(
            fontSize: 14,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          //   height: 300,
          child: _showComment(),
        ),
      ),
    );
  }
}
