part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostsLoading extends PostState {}

final class PostsLoaded extends PostState {
  const PostsLoaded({required this.posts});

  final List<Post> posts;

  @override
  List<Object> get props => [posts];
}

final class PostsError extends PostState {
  const PostsError(this.message);

  final String message;
}
