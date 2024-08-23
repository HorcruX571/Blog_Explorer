import 'package:blog_explorer/bloc/blog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blog_bloc.dart';
import '../bloc/blog_event.dart';
import '../cubit/theme_cubit.dart';
import '../models/blog.dart';
import '../widgets/blog_card.dart';
import 'blog_detail_screen.dart';
import 'search_screen.dart';

class BlogListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = ['ALL', 'MERCHANTS', 'BUSINESS', 'TUTORIAL'];
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            'assets/top.png',
            height: 40.0,
            fit: BoxFit.cover,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final query = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
              if (query != null && query.isNotEmpty) {
                context.read<BlogBloc>().add(SearchBlogs(query));
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogDetailScreen(
                      blog: Blog(
                        id: 'privacy-id',
                        title: 'Privacy Policy',
                        imageUrl: '',
                        category: 'OTHER',
                        content:
                            'This is the privacy policy of our application.',
                      ),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Toggle Theme'),
              trailing: Switch(
                value: isLightTheme,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ),
            Divider(), // Adds a line between items
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Refresh Data'),
              onTap: () {
                // Trigger a refresh of the data
                context.read<BlogBloc>().add(RefreshBlogs());
                Navigator.pop(context); // Close the drawer after tapping
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    context.read<BlogBloc>().add(FilterBlogs(category));
                  },
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: BlocBuilder<BlogBloc, BlogState>(
              builder: (context, state) {
                if (state is BlogLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is BlogError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is BlogLoaded) {
                  if (state.blogs.isEmpty) {
                    return Center(
                        child: Text('No blogs available for this category.'));
                  }

                  final filteredBlogs = state.blogs.where((blog) {
                    return blog.title.toLowerCase() != 'privacy policy';
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredBlogs.length,
                    itemBuilder: (context, index) {
                      final blog = filteredBlogs[index];
                      return BlogCard(
                        blog: blog,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlogDetailScreen(blog: blog),
                            ),
                          );
                        },
                        onFavoriteTap: () {
                          context.read<BlogBloc>().add(FavoriteBlog(blog));
                        },
                      );
                    },
                  );
                }
                return Center(child: Text('No blogs available.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
