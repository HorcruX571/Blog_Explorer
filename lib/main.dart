import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/blog_bloc.dart';
import 'bloc/blog_event.dart';
import 'cubit/theme_cubit.dart';
import 'repository/blog_repository.dart';
import 'screens/blog_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BlogRepository blogRepository = BlogRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BlogBloc(blogRepository)..add(FetchBlogs()),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'Blog Explorer',
            theme: theme,
            home: BlogListScreen(),
          );
        },
      ),
    );
  }
}
