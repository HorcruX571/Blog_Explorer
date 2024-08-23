import 'package:flutter/material.dart';
import '../models/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const BlogCard({
    Key? key,
    required this.blog,
    required this.onTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: theme.cardColor,
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              blog.imageUrl,
              width: double.infinity,
              height: 150.0,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                blog.title,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    blog.category,
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      blog.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          blog.isFavorite ? Colors.red : theme.iconTheme.color,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
