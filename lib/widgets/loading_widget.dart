import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:replacer/states/loading_state.dart';
import 'package:replacer/theme/color_theme.dart';

class LoadingWidget extends HookConsumerWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lottieController = useAnimationController(duration: const Duration(milliseconds: 1000));
    final Animation<double> animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 1),
    ]).animate(lottieController);
    final isShow = ref.watch(loadingStateProvider);

    useEffect(() {
      lottieController.reset();
      return null;
    }, [isShow]);

    return isShow
        ? AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Opacity(
              opacity: animation.value,
              child: Container(
                color: const Color(MyColors.light),
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    // controller: lottieController, repeat: true,
                    //     onLoaded: (composition) {
                    //   lottieController
                    //     ..duration = composition.duration
                    //     ..forward();
                    // }
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
