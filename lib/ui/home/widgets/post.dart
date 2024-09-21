import 'dart:async';
import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_knovator/bloc/post_bloc/post_bloc.dart';
import 'package:task_knovator/model/post_model.dart';
import 'package:task_knovator/model/timer_model.dart';
import 'package:task_knovator/theme/app_colors.dart';
import 'package:task_knovator/theme/app_texts.dart';
import 'package:task_knovator/ui/home/screens/post_detail_screen.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  int remainingSeconds = 0;
  Timer? timer;

  @override
  void initState() {
    final list = context.read<PostBloc>().timers;
    final posts =
        list.where((timer) => timer.postId == widget.post.id).toList();
    if (posts.isEmpty) {
      context.read<PostBloc>().addTimer(
            TimerModel(
              postId: widget.post.id,
              seconds: Random().nextInt(50),
            ),
          );
    }

    remainingSeconds =
        list.firstWhere((timer) => timer.postId == widget.post.id).seconds;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      d.log('Seconds: $remainingSeconds');
      if (remainingSeconds == 0) {
        return;
      }else {
        setState(() {
          remainingSeconds--;
          context.read<PostBloc>().updateTimer(widget.post.id, remainingSeconds);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.post.id == 1) {
      d.log('Disposing id: ${widget.post.id}');
    }
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    d.log('Building post: ${widget.post.id}');
    return GestureDetector(
      onTap: () {
        timer?.cancel();
        context.read<PostBloc>().currentlyOpenId = widget.post.id;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return PostDetailScreen(postId: widget.post.id);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Card(
          color: widget.post.isRead ? null : AppColors.lightYellow,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      remainingSeconds.toString(),
                      style: AppTexts.timerStyle,
                    ),
                    const Text(' Seconds'),
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Title: ${widget.post.title}',
                    style: AppTexts.titleStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
