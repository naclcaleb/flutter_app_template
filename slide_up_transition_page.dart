import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideUpTransitionPage extends CustomTransitionPage {

  SlideUpTransitionPage({required super.child}) : super(
    transitionDuration: const Duration(milliseconds: 200), 
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    reverseTransitionDuration: const Duration(milliseconds: 200), 
  );

}