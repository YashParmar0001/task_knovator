import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_knovator/bloc/post_detail_bloc/post_detail_bloc.dart';
import 'package:task_knovator/core/widgets/exception_widget.dart';

import '../../../bloc/post_bloc/post_bloc.dart';
import '../../../theme/app_texts.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostDetailBloc(id: postId)
        ..add(
          FetchPostDetail(
            postId: postId,
          ),
        ),
      child: PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            context.read<PostBloc>().add(Refresh());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Post Detail'),
          ),
          body: BlocBuilder<PostDetailBloc, PostDetailState>(
            builder: (context, state) {
              if (state is PostDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostDetailLoaded) {
                context.read<PostBloc>().add(MarkAsRead(state.post.id));

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          'Title: ${state.post.title}',
                          style: AppTexts.titleStyle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Post Description: \n\n${state.post.body}',
                          style: AppTexts.bodyStyle,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is PostDetailError) {
                return Center(
                  child: ExceptionWidget(
                    message: state.message,
                    onTryAgain: () {
                      context.read<PostDetailBloc>().add(
                            FetchPostDetail(
                              postId: postId,
                            ),
                          );
                    },
                  ),
                );
              } else {
                return const Text('Unknown State');
              }
            },
          ),
        ),
      ),
    );
  }
}
