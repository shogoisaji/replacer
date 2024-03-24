import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:replacer/states/loading_state.dart';
import 'package:replacer/states/replace_format_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';
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
    final imageSizeConvertRate =
        pickImage != null ? pickImage.image.width / size.width : 1.0; // pickImage width / display width

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

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        convert();
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: const Color(MyColors.light),
      appBar: AppBar(
        backgroundColor: const Color(MyColors.orange1),
        title: Text('Converted Image', style: MyTextStyles.subtitle),
        leading: const SizedBox(),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            imageMemory.value != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.memory(
                          imageMemory.value!,
                          width: size.width,
                        ),
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
                    if (result == true && context.mounted) {
                      context.go('/');
                      showDialog(
                        barrierColor: Colors.black.withOpacity(0.3),
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return customDialog(context);
                        },
                      );

                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(const SnackBar(content: Text('Successfully saved image')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save image')));
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.orange1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(MyColors.light), width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('Save', style: MyTextStyles.largeBodyLight),
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
                        color: const Color(MyColors.light),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(MyColors.orange1), width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('Back', style: MyTextStyles.largeBodyOrange),
                        ],
                      )),
                )),
          ],
        ),
      ),
    );
  }

  Widget customDialog(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    void handleSaveFormat() {
      // Save format
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: w * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(MyColors.light),
          border: Border.all(color: const Color(MyColors.orange1), width: 3),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '🎉Image saved🎉',
              style: MyTextStyles.largeBodyOrange,
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
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.light),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(MyColors.orange1), width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('NoSave', style: MyTextStyles.largeBodyOrange),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    handleSaveFormat();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(MyColors.orange1),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(MyColors.light), width: 2),
                      ),
                      child: Column(
                        children: [
                          Text('Save', style: MyTextStyles.largeBodyLight),
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
