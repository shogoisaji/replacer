import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/states/image_pick_state.dart';
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

    void convert() async {
      if (pickImage == null || replaceFormat.replaceDataList.isEmpty) return;
      ImageReplaceConvertUseCase()
          .convertImage(
        pickImage.image,
        replaceFormat,
        size.width,
      )
          .then((value) {
        imageMemory.value = value;
      });
    }

    useEffect(() {
      convert();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: const Color(MyColors.light),
      appBar: AppBar(
        backgroundColor: const Color(MyColors.orange1),
        title: Text('Export', style: MyTextStyles.subtitle),
        leading: const SizedBox(),
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            imageMemory.value != null
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: Image.memory(
                      imageMemory.value!,
                      width: size.width,
                    ),
                  )
                : const SizedBox(),
            Positioned(
                bottom: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () async {
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
                bottom: 20,
                left: 20,
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
                          Text('Cancel', style: MyTextStyles.largeBodyOrange),
                        ],
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
