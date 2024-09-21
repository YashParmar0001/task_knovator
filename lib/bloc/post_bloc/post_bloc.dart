import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_knovator/model/timer_model.dart';
import 'package:task_knovator/repositories/post_api.dart';
import 'package:task_knovator/repositories/sqlite_db.dart';

import '../../model/post_model.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<MarkAsRead>(_onMarkAsRead);
    on<Refresh>(_onRefresh);
  }

  final PostApi postApi = PostApi();
  final SqliteDb localDb = SqliteDb();

  final List<TimerModel> timers = [];

  int? currentlyOpenId;

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostsLoading());

    List<Post> localResult = [];
    try {
      localResult = await localDb.getPosts();
      if (localResult.isNotEmpty) {
        emit(PostsLoaded(posts: localResult));
      }

      final networkResult = await postApi.fetchPosts();
      // emit(PostsLoaded(posts: networkResult));

      // Store data to local
      // log('Storing data to local');
      localDb.storeToLocal(networkResult);

      localResult = await localDb.getPosts();
      emit(PostsLoaded(posts: localResult));
    } catch (e) {
      log('Got error: $e');
      if (localResult.isEmpty) {
        if (e is SocketException) {
          emit(const PostsError('Please check your internet connection!'));
        } else {
          emit(const PostsError('Something went wrong!'));
        }
      }
    }
  }

  void _onMarkAsRead(MarkAsRead event, Emitter<PostState> emit) {
    final posts = (state as PostsLoaded).posts;

    try {
      final postIndex = posts.indexWhere((post) => post.id == event.id);
      posts[postIndex] = posts[postIndex].copyWith(isRead: true);
      log('Updated post: $posts');
      emit(PostsLoading());
      emit(PostsLoaded(posts: List.from(posts)));

      localDb.markAsRead(event.id);
    } catch (e) {
      log('No post found!');
    }
  }

  void addTimer(TimerModel timer) {
    timers.add(timer);
  }

  void updateTimer(int postId, int seconds) {
    final timerIndex = timers.indexWhere((e) => e.postId == postId);
    final timer = timers[timerIndex].copyWith(seconds: seconds);
    timers[timerIndex] = timer;
  }

  Future<void> _onRefresh(Refresh event, Emitter<PostState> emit) async {
    final list = (state as PostsLoaded).posts;
    emit(PostsLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(PostsLoaded(posts: list));
  }

  @override
  void onTransition(Transition<PostEvent, PostState> transition) {
    log(transition.toString(), name: 'PostBloc');
    super.onTransition(transition);
  }
}
