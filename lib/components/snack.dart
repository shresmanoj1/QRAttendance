import 'package:flutter/material.dart';

void snackThis({required BuildContext context, Widget content = const Text("Something Happened. Please try again."), int duration=3, Color color=Colors.green, SnackBarBehavior behavior= SnackBarBehavior.floating}){
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: behavior,
      content: content,
      backgroundColor: color,
      duration: Duration(seconds: duration),
    ));
  });
}

