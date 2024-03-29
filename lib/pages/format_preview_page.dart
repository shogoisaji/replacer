import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:replacer/repositories/sqflite/sqflite_repository.dart';
import 'package:replacer/states/replace_format_state.dart';
import 'package:replacer/states/saved_format_list_state.dart';
import 'package:replacer/string.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';
import 'package:replacer/use_case/image_pick_usecase.dart';
import 'package:replacer/widgets/custom_snack_bar.dart';

class FormatPreviewPage extends HookConsumerWidget {
  final String? formatId;
  const FormatPreviewPage({super.key, this.formatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final canvasAspectRatio = useState<double>(0.0);
    final format = useState<ReplaceFormat?>(null);
    final isFocused = useState<bool>(false);
    final textEditingController = useTextEditingController();
    final titleFocusNode = useFocusNode();

    void handleTextUpdate(String value) async {
      if (textEditingController.text == format.value!.formatName) return;
      await SqfliteRepository.instance.updateFormatName(formatId!, value);
      ref.read(savedFormatListStateProvider.notifier).fetchFormatList();
    }

    void fetchFormatData() async {
      if (formatId == null) return;
      final sqfliteRepository = SqfliteRepository.instance;
      format.value = await sqfliteRepository.findFormatById(formatId!);
      if (format.value == null) return;

      /// canvas areaのアスペクト比を計算
      canvasAspectRatio.value = (format.value!.canvasArea!.firstPointX - format.value!.canvasArea!.secondPointX).abs() /
          (format.value!.canvasArea!.firstPointY - format.value!.canvasArea!.secondPointY).abs();

      /// TextFieldに初期値をセット
      textEditingController.value = TextEditingValue(text: format.value!.formatName);
    }

    void handlePickImage() async {
      if (format.value == null) return;
      await ref.read(imagePickUseCaseProvider).pickImage();
      ref.read(replaceFormatStateProvider.notifier).setReplaceFormat(format.value!);
      Future.delayed(const Duration(milliseconds: 0), () {
        context.push('/export_page', extra: true);
      });
    }

    useEffect(() {
      void onFocusChange() {
        isFocused.value = titleFocusNode.hasFocus;
        if (titleFocusNode.hasFocus) return;
        handleTextUpdate(textEditingController.text);
      }

      titleFocusNode.addListener(onFocusChange);

      return () => titleFocusNode.removeListener(onFocusChange);
    }, [titleFocusNode]);

    useEffect(() {
      fetchFormatData();
      return null;
    }, []);

    if (format.value != null) {
      return GestureDetector(
        onTap: () {
          if (FocusScope.of(context).hasFocus) return;

          textEditingController.value = TextEditingValue(text: format.value!.formatName);
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: const Color(MyColors.orange1),
            leading: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
              onPressed: () {
                context.go('/');
              },
            ),
            title: Text('FormatPreview', style: MyTextStyles.subtitle.copyWith(color: Theme.of(context).primaryColor)),
          ),
          body: GestureDetector(
            onTap: () {
              if (FocusScope.of(context).hasFocus) {
                primaryFocus?.unfocus();
              }
            },
            child: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                format.value!.createdAt.toIso8601String().toYMDString(),
                                style: MyTextStyles.middleOrange,
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: const Color(MyColors.orange1), width: 2.0),
                              ),
                              child: Row(
                                children: [
                                  Text('Title', style: MyTextStyles.middleOrange),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextField(
                                      focusNode: titleFocusNode,
                                      cursorColor: const Color(MyColors.orange1),
                                      controller: textEditingController,
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(bottom: 4.0),
                                      ),
                                      style: MyTextStyles.body
                                          .copyWith(color: const Color(MyColors.orange1), fontWeight: FontWeight.w700),
                                      onEditingComplete: () {
                                        handleTextUpdate(textEditingController.text);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  const FaIcon(FontAwesomeIcons.penToSquare, color: Color(MyColors.orange1))
                                ],
                              )),
                          const SizedBox(height: 20.0),
                          Container(
                            // width: size.width * 0.8,
                            // height: size.width * 0.8 / canvasAspectRatio.value,
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(MyColors.orange1), width: 2.0),
                            ),
                            child: format.value!.thumbnailImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.memory(format.value!.thumbnailImage!, fit: BoxFit.fill))
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: FloatingActionButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return customDialog(context, ref);
                            },
                          );
                        },
                        elevation: 2,
                        backgroundColor: const Color(MyColors.orange1),
                        child: FaIcon(
                          FontAwesomeIcons.trashCan,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        handlePickImage();
                      },
                      child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(MyColors.orange1),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text('UseFormat',
                                style: MyTextStyles.largeBody.copyWith(color: Theme.of(context).primaryColor)),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: const Color(MyColors.orange1),
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Theme.of(context).primaryColor,
            size: 32,
          ),
          onPressed: () {
            context.go('/');
          },
        ),
        title: Text('FormatPreview', style: MyTextStyles.subtitle.copyWith(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget customDialog(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;

    Future<void> handleDeleteFormat() async {
      if (formatId == null) return;
      final sqfliteRepository = SqfliteRepository.instance;
      final result = await sqfliteRepository.deleteRow(formatId!);

      if (result > 0) {
        await ref.read(savedFormatListStateProvider.notifier).fetchFormatList();
        if (context.mounted) {
          context.go('/');
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(customSnackBar('Failed to delete format', true, context));
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
              'Delete this format ?',
              style: MyTextStyles.largeBody.copyWith(color: const Color(MyColors.orange1)),
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
                    handleDeleteFormat();
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
                          Text('Delete', style: MyTextStyles.largeBody.copyWith(color: Theme.of(context).primaryColor)),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
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
                          Text('Cancel', style: MyTextStyles.largeBody.copyWith(color: const Color(MyColors.orange1))),
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
