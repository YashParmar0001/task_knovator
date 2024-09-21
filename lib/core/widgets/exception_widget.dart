import 'package:flutter/material.dart';

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({
    super.key,
    required this.message,
    required this.onTryAgain,
  });

  final String message;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed: onTryAgain,
          child: const Text('Try Again'),
        ),
      ],
    );
  }
}
