import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/states/capture_screen_state.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:replacer/states/replace_format_state.dart';
import 'package:replacer/use_case/image_replace_convert_usecase.dart';
import 'package:replacer/use_case/image_save_usecase.dart';

class ExportPage extends HookConsumerWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final replaceFormat = ref.watch(replaceFormatStateProvider);
    final pickImage = ref.watch(pickImageStateProvider);
    final imageMemory = useState<Uint8List?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            imageMemory.value != null
                ? Image.memory(
                    imageMemory.value!,
                  )
                : const SizedBox(),
            Positioned(
              bottom: 0,
              left: 0,
              child: ElevatedButton(
                onPressed: () {
                  if (pickImage == null) return;
                  ImageReplaceConvertUseCase()
                      .convertImage(
                    pickImage.image,
                    replaceFormat,
                    size.width,
                  )
                      .then((value) {
                    imageMemory.value = value;
                  });
                },
                child: const Text('convert'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () async {
                  if (imageMemory.value == null) return;
                  final result = await ImageSaveUseCase().saveImage(imageMemory.value!);
                  if (result == true) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Successfully saved image')));
                    context.go('/');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save image')));
                  }
                },
                child: const Text('save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
