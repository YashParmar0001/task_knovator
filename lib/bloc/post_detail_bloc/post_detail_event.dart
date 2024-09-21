part of 'post_detail_bloc.dart';

sealed class PostDetailEvent {}

class FetchPostDetail extends PostDetailEvent {
  FetchPostDetail({required this.postId});

  final int postId;
}
