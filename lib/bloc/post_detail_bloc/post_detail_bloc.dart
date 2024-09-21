import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:task_knovator/model/post_model.dart';
import 'package:task_knovator/repositories/post_api.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc({required this.id}) : super(PostDetailInitial()) {
    on<FetchPostDetail>(_onFetchPostDetail);
  }

  final int id;
  final PostApi postApi = PostApi();

  Future<void> _onFetchPostDetail(FetchPostDetail event, Emitter<PostDetailState> emit,) async {
    emit(PostDetailLoading());
    try {
      final response = await postApi.fetchPostDetail(id);
      emit(PostDetailLoaded(post: response));
    }catch(e) {
      if (e is SocketException) {
        emit(PostDetailError('Please check your internet connection!'));
      } else {
        emit(PostDetailError('Something went wrong!'));
      }
    }
  }
}
