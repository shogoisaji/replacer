import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:replacer/models/replace_format/replace_format.dart';
import 'package:replacer/repositories/sqflite/sqflite_repository.dart';
import 'package:replacer/states/saved_format_list_state.dart';
import 'package:replacer/string.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';
import 'package:replacer/widgets/custom_snack_bar.dart';

class FormatPreviewPage extends HookConsumerWidget {
  final String? formatId;
  const FormatPreviewPage({super.key, this.formatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final canvasAspectRatio = useState<double>(0.0);
    final format = useState<ReplaceFormat?>(null);
    final textEditingController = useTextEditingController();
    final titleFocusNode = useFocusNode();

    void handleDeleteFormat(String id) async {
      final sqfliteRepository = SqfliteRepository.instance;
      final result = await sqfliteRepository.deleteRow(id);
      print('delete result: $result');
    }

    void handleTextUpdate(String value) async {
      if (textEditingController.text == format.value!.formatName) return;
      final result = await SqfliteRepository.instance.updateFormatName(formatId!, value);
      print('update result: $result');
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

    useEffect(() {
      void onFocusChange() {
        print('Focus: ${titleFocusNode.hasFocus}');
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
          body: SafeArea(
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
                        _contentWidget('Date', format.value!.createdAt.toIso8601String().toYMDString()),
                        const SizedBox(height: 16.0),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: const Color(MyColors.orange1), width: 2.0),
                            ),
                            child: Row(
                              children: [
                                Text('Title', style: MyTextStyles.middleOrange),
                                const SizedBox(width: 16.0),
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
                                    style: MyTextStyles.middleOrange,
                                    onEditingComplete: () {
                                      handleTextUpdate(textEditingController.text);
                                    },
                                  ),
                                  //  Text(format!.formatName, style: MyTextStyles.middleOrange),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //
                                    titleFocusNode.requestFocus();
                                    print('edit title');
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    color: Color(MyColors.orange1),
                                  ),
                                )
                              ],
                            )),
                        const SizedBox(height: 20.0),
                        Container(
                          width: size.width * 0.8,
                          height: size.width * 0.8 / canvasAspectRatio.value,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: const Color(MyColors.orange1), width: 2.0),
                          ),
                          // child: format.value!.thumbnailImage != null
                          //     ? Image.memory(format.value!.thumbnailImage!)
                          //     : const Center(
                          //         child: Text('No Image'),
                          //       ),
                        ),
                        const SizedBox(height: 20.0),
                        format.value!.thumbnailImage != null
                            ? Image.memory(format.value!.thumbnailImage!)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return customDialog(context, ref); // ここでcustomDialogを呼び出す
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
              ],
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

  Widget _contentWidget(String contentName, String content) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: const Color(MyColors.orange1), width: 2.0),
        ),
        child: Row(
          children: [
            Text(contentName, style: MyTextStyles.middleOrange),
            const SizedBox(width: 16.0),
            Expanded(child: Text(content, style: MyTextStyles.middleOrange)),
          ],
        ));
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
        width: w * 0.8,
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
