import 'package:equatable/equatable.dart';
import '../models/blog.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class FetchBlogs extends BlogEvent {}

class FetchBlogDetails extends BlogEvent {
  final String id;

  const FetchBlogDetails(this.id);

  @override
  List<Object> get props => [id];
}

class FavoriteBlog extends BlogEvent {
  final Blog blog;

  const FavoriteBlog(this.blog);

  @override
  List<Object> get props => [blog];
}

class FilterBlogs extends BlogEvent {
  final String category;

  const FilterBlogs(this.category);

  @override
  List<Object> get props => [category];
}

class SearchBlogs extends BlogEvent {
  final String query;

  const SearchBlogs(this.query);

  @override
  List<Object> get props => [query];
}

class RefreshBlogs extends BlogEvent {} // New event for refreshing data
