import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { width, height, color, opacity, translate }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final FadeDirection fadeDirection;
  final Duration duration;

  const FadeAnimation(
      {Key? key,
      required this.delay,
      required this.child,
      required this.fadeDirection,
      required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween(begin: 0.0, end: 1.0), 0.5.seconds)
      ..add(AniProps.translate, Tween(begin: -30.0, end: 0.0), 0.5.seconds,
          Curves.easeOut);

    return CustomAnimation(
      delay: (500 * delay / 1000).seconds,
      duration: tween.duration,
      tween: tween,
      builder: (BuildContext context, Widget? child,
          MultiTweenValues<AniProps> value) {
        return Opacity(
            opacity: value.get(AniProps.opacity),
            child: Transform.translate(
                offset: Offset(
                  (fadeDirection == FadeDirection.top ||
                          fadeDirection == FadeDirection.bottom ||
                          fadeDirection == FadeDirection.none)
                      ? 0
                      : value.get(AniProps.translate) *
                          (fadeDirection == FadeDirection.left ? -1 : 1),
                  (fadeDirection == FadeDirection.left ||
                          fadeDirection == FadeDirection.right ||
                          fadeDirection == FadeDirection.none)
                      ? 0
                      : value.get(AniProps.translate) *
                          (fadeDirection == FadeDirection.top ? -1 : 1),
                ),
                child: child));
      },
      child: child,
    );
  }
}

enum FadeDirection { top, bottom, right, left, none }
