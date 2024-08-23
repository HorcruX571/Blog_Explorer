import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/blog_repository.dart';
import '../models/blog.dart';
import 'blog_event.dart';
import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository blogRepository;

  List<Blog> allBlogs = [];

  BlogBloc(this.blogRepository) : super(BlogInitial()) {
    on<FetchBlogs>((event, emit) async {
      emit(BlogLoading());
      try {
        allBlogs = await blogRepository.fetchBlogs();
        emit(BlogLoaded(allBlogs));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    });

    on<FetchBlogDetails>((event, emit) async {
      emit(BlogLoading());
      try {
        final blog = await blogRepository.fetchBlogDetails(event.id);
        emit(BlogDetailsLoaded(blog));
      } catch (e) {
        emit(BlogError(e.toString()));
      }
    });

    on<FavoriteBlog>((event, emit) {
      if (state is BlogLoaded) {
        final updatedBlogs = (state as BlogLoaded).blogs.map((blog) {
          return blog.id == event.blog.id
              ? blog.copyWith(isFavorite: !blog.isFavorite)
              : blog;
        }).toList();
        emit(BlogLoaded(updatedBlogs));
      }
    });

    on<FilterBlogs>((event, emit) {
      if (allBlogs.isNotEmpty) {
        final filteredBlogs = event.category == 'ALL'
            ? allBlogs
            : allBlogs.where((blog) {
                return blog.category.toLowerCase() ==
                    event.category.toLowerCase();
              }).toList();
        emit(BlogLoaded(filteredBlogs));
      }
    });

    on<SearchBlogs>((event, emit) {
      if (allBlogs.isNotEmpty) {
        final searchedBlogs = allBlogs.where((blog) {
          return blog.title.toLowerCase().contains(event.query.toLowerCase());
        }).toList();
        emit(BlogLoaded(searchedBlogs));
      }
    });
  }
}
