import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 100),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
