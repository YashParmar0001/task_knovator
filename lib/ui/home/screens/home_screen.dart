import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_knovator/bloc/post_bloc/post_bloc.dart';
import 'package:task_knovator/ui/home/widgets/post.dart';

import '../../../core/widgets/exception_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return PostWidget(post: state.posts[index]);
              },
            );
          } else if (state is PostsError) {
            return Center(
              child: ExceptionWidget(
                message: state.message,
                onTryAgain: () {
                  context.read<PostBloc>().add(FetchPosts());
                },
              ),
            );
          } else {
            return const Text('Unknown state');
          }
        },
      ),
    );
  }
}
