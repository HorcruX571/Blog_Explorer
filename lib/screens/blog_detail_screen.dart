import 'package:flutter/material.dart';
import '../models/blog.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({required this.blog, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color:
              Colors.black, // Black background behind the top.png in light mode
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            'assets/top.png', // Path to the top image in the assets folder
            height: 40.0, // Adjust the height as needed
            fit: BoxFit
                .cover, // Adjusts how the image should be fitted into the AppBar
          ),
        ),
        centerTitle: true, // Centers the top image in the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              blog.imageUrl.isNotEmpty
                  ? Image.network(
                      blog.imageUrl,
                      width: double.infinity,
                      height: 200.0,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 200.0,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[700],
                        size: 100,
                      ),
                    ),
              SizedBox(height: 16),
              Text(
                blog.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  blog.content,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
