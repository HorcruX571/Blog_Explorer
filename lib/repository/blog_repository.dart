import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blog.dart';
import 'database_helper.dart';

class BlogRepository {
  final String apiUrl = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final String adminSecret =
      '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Blog>> fetchBlogs() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'x-hasura-admin-secret': adminSecret},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> blogsJson = jsonData['blogs'];

        // Exclude the Terms and Conditions entry
        final List<Blog> blogs = blogsJson
            .map((blog) => Blog.fromJson(blog))
            .where((blog) => blog.title.toLowerCase() != 'terms and conditions')
            .toList();

        await databaseHelper.deleteAllBlogs();
        for (var blog in blogs) {
          await databaseHelper.insertBlog(blog);
        }

        return blogs;
      } else {
        throw Exception('Failed to load blogs');
      }
    } catch (e) {
      final List<Blog> cachedBlogs = await databaseHelper.fetchBlogs();
      if (cachedBlogs.isNotEmpty) {
        return cachedBlogs;
      } else {
        throw Exception('Failed to load blogs and no cached data available');
      }
    }
  }

  Future<Blog> fetchBlogDetails(String id) async {
    try {
      final url = '$apiUrl/$id';
      final response = await http.get(
        Uri.parse(url),
        headers: {'x-hasura-admin-secret': adminSecret},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Blog.fromJson(jsonData[
            'blog']); // Adjust according to your API response structure
      } else {
        throw Exception('Failed to load blog content');
      }
    } catch (e) {
      throw Exception('Failed to load blog content: $e');
    }
  }
}
