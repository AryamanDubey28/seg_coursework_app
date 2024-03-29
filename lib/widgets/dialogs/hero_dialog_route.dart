import 'package:flutter/material.dart';

/// Custom [PageRoute] that creates an overlay dialog (popup effect).
/// taken from: https://youtu.be/Bxs8Zy2O4wk

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pageWidth = screenWidth * 0.7;

    return Transform.scale(
      scale: 1,
      child: Center(
        child: SizedBox(
          width: pageWidth,
          child: _builder(context),
        ),
      ),
    );
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
