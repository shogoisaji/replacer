import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:go_router/go_router.dart';

final backHomeUseCase = Provider((ref) => BackHomePageUseCase(ref: ref));

class BackHomePageUseCase {
  final Ref ref;
  BackHomePageUseCase({required this.ref});
  void backHome(BuildContext context) {
    context.go('/');
    ref.read(pickImageStateProvider.notifier).clear();
  }
}
