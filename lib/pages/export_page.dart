import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/repositories/sqflite/sqflite_repository.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:replacer/states/loading_state.dart';
import 'package:replacer/states/replace_format_state.dart';
import 'package:replacer/states/saved_format_list_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';
import 'package:replacer/use_case/image_replace_convert_usecase.dart';
import 'package:replacer/use_case/image_save_usecase.dart';
import 'package:replacer/utils/thumbnail_resize_converter.dart';
import 'package:replacer/widgets/custom_snack_bar.dart';

class ExportPage extends HookConsumerWidget {
  final bool isUseFormat;
  const ExportPage({super.key, required this.isUseFormat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final replaceFormat = ref.watch(replaceFormatStateProvider);
    final pickImage = ref.watch(pickImageStateProvider);
    final imageMemory = useState<Uint8List?>(null);

    void convert() async {
      if (pickImage == null || replaceFormat.replaceDataList.isEmpty) return;
      ref.read(loadingStateProvider.notifier).show();
      imageMemory.value = await ImageReplaceConvertUseCase().convertImage(
        pickImage.image,
        replaceFormat,
        size.width,
      );
      ref.read(loadingStateProvider.notifier).hide();
    }

    double calculateConvertedImageAspectRatio() {
      if (replaceFormat.canvasArea == null) {
        final aspectRation = (pickImage!.image.width) / (pickImage.image.height);
        return aspectRation;
      }
      final aspectRation = (replaceFormat.canvasArea!.firstPointX - replaceFormat.canvasArea!.secondPointX).abs() /
          (replaceFormat.canvasArea!.firstPointY - replaceFormat.canvasArea!.secondPointY).abs();
      return aspectRation;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        convert();
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: const Color(MyColors.orange1),
        title: Text('Replaced Image', style: MyTextStyles.subtitle.copyWith(color: Theme.of(context).primaryColor)),
        leading: const SizedBox(),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            imageMemory.value != null
                ? SingleChildScrollView(
                    child: Stack(
                      children: [
                        Container(
                            width: size.width,
                            height: size.width / calculateConvertedImageAspectRatio(),
                            color: Colors.white,
                            child: Image.memory(
                              imageMemory.value!,
                              fit: BoxFit.fill,
                            )),
                        const SizedBox(height: 100),
                      ],
                    ),
                  )
                : const SizedBox(),
            Positioned(
                bottom: 30,
                right: 40,
                child: GestureDetector(
                  onTap: () async {
                    if (imageMemory.value == null) return;
                    final result = await ImageSaveUseCase().saveImage(imageMemory.value!);
                    if (isUseFormat && context.mounted) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(customSnackBar('Successfully saved Image', false, context));
                      context.go('/');
                      return;
                    }
                    if (result == true && context.mounted) {
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.3),
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return customDialog(context, ref, imageMemory.value!, calculateConvertedImageAspectRatio());
                        },
                      );
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(customSnackBar('Failed to save image', false, context));
                      }
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.orange1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('Save', style: MyTextStyles.largeBody.copyWith(color: Theme.of(context).primaryColor)),
                        ],
                      )),
                )),
            Positioned(
                bottom: 30,
                left: 40,
                child: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(MyColors.orange1), width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('Back', style: MyTextStyles.largeBody.copyWith(color: const Color(MyColors.orange1))),
                        ],
                      )),
                )),
          ],
        ),
      ),
    );
  }

  Widget customDialog(BuildContext context, WidgetRef ref, Uint8List imageMemory, double aspectRatio) {
    final w = MediaQuery.sizeOf(context).width;

    Future<void> handleSaveFormat() async {
      final formatThumbnail =
          await ThumbnailResizeUint8ListConverter().convertFormatThumbnail(imageMemory, 500, 500 ~/ aspectRatio);
      ref.read(replaceFormatStateProvider.notifier).setThumbnailImage(formatThumbnail);
      final currentFormat = ref.watch(replaceFormatStateProvider);
      final sqfliteRepository = SqfliteRepository.instance;
      final result = await sqfliteRepository.insertFormat(currentFormat);
      if (result > 0) {
        if (context.mounted) {
          ref.read(savedFormatListStateProvider.notifier).fetchFormatList();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar('Successfully saved Format', false, context));
          context.go('/');
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar('Error saving Format', true, context));
        }
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: (w * 0.8).clamp(300.0, 500.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(color: const Color(MyColors.orange1), width: 3),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '🎉Image saved🎉',
              style: MyTextStyles.largeBody.copyWith(color: const Color(MyColors.orange1)),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Save this format ?',
              style: MyTextStyles.middleOrange,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/');
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(MyColors.orange1), width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('NoSave', style: MyTextStyles.largeBody.copyWith(color: const Color(MyColors.orange1))),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () async {
                    handleSaveFormat();
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.orange1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('Save', style: MyTextStyles.largeBody.copyWith(color: Theme.of(context).primaryColor)),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}
