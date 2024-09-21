import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:task_knovator/constants/api_constants.dart';
import 'package:task_knovator/model/post_model.dart';

class PostApi {
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(ApiConstants.postsUrl));

    log('Response: $response');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final list = data.map((e) => Post.fromMap(e)).toList();
      return list;
    }else {
      throw Exception('Something went wrong!');
    }
  }

  Future<Post> fetchPostDetail(int id) async {
    final response = await http.get(Uri.parse('${ApiConstants.postsUrl}/$id'));
    log(response.body);
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final data = Post.fromMap(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Something went wrong!');
    }
  }
}