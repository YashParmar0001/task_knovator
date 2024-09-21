part of 'post_detail_bloc.dart';

sealed class PostDetailState {}

final class PostDetailInitial extends PostDetailState {}

final class PostDetailLoading extends PostDetailState {}

final class PostDetailLoaded extends PostDetailState {
  PostDetailLoaded({required this.post});

  final Post post;
}

final class PostDetailError extends PostDetailState {
  PostDetailError(this.message);

  final String message;
}
