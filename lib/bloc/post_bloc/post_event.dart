part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostEvent {}

class Refresh extends PostEvent {}

class MarkAsRead extends PostEvent {
  const MarkAsRead(this.id);

  final int id;
}
