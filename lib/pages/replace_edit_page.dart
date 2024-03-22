import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:replacer/models/area_model/area_model.dart';
import 'package:replacer/models/move_delta/move_delta.dart';
import 'package:replacer/models/replace_data/replace_data.dart';
import 'package:replacer/states/capture_screen_state.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:replacer/states/replace_edit_page_state.dart';
import 'package:replacer/states/replace_edit_state.dart';
import 'package:replacer/states/replace_format_state.dart';
import 'package:replacer/states/replace_thumbnail_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';
import 'package:replacer/use_case/image_pick_usecase.dart';
import 'package:replacer/utils/thumbnail_resize_converter.dart';
import 'package:replacer/widgets/area_select_widget.dart';
import 'package:replacer/widgets/capture_widget.dart';

class ReplaceEditPage extends HookConsumerWidget {
  const ReplaceEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final temporaryFirstPoint = useState<Offset?>(null);
    final movePosition = useState<Offset>(Offset.zero);
    final temporaryArea = useState<AreaModel?>(null);
    final selectedArea = useState<AreaModel?>(null);
    final lottieController = useAnimationController(duration: const Duration(milliseconds: 2000), initialValue: 1);
    final currentMode = ref.watch(replaceEditStateProvider);
    final pickImage = ref.watch(pickImageStateProvider);
    final captureImage = ref.watch(captureScreenStateProvider);
    final replaceFormatData = ref.watch(replaceFormatStateProvider);

    final Offset imageArea =
        pickImage != null ? Offset(w, pickImage.image.height / pickImage.image.width * w) : Offset.zero;

    void resetToNextArea() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movePosition.value = Offset.zero;
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
      ref.read(captureScreenStateProvider.notifier).clear();
    }

    void resetAll() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movePosition.value = Offset.zero;
      ref.read(replaceThumbnailStateProvider.notifier).clear();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
      ref.read(replaceEditPageStateProvider.notifier).clear();
      ref.read(captureScreenStateProvider.notifier).clear();
      ref.read(replaceFormatStateProvider.notifier).replaceDataReset();
    }

    void handleFirstTapImage(details) {
      if (currentMode == ReplaceEditMode.moveSelect) return;
      temporaryFirstPoint.value = details.localPosition;
    }

    void handleAreaSelect(details) {
      if (currentMode == ReplaceEditMode.moveSelect) return;
      temporaryArea.value = AreaModel(
        firstPointX: temporaryFirstPoint.value!.dx,
        firstPointY: temporaryFirstPoint.value!.dy,
        secondPointX: details.localPosition.dx,
        secondPointY: details.localPosition.dy,
      );
    }

    void handlePickImage() async {
      final result = await ref.read(imagePickUseCaseProvider).pickImage();
      if (!result) return;
      resetAll();
    }

    void handleOnPanUpdate(details) {
      temporaryArea.value = AreaModel(
        firstPointX: temporaryArea.value!.firstPointX + details.delta.dx,
        firstPointY: temporaryArea.value!.firstPointY + details.delta.dy,
        secondPointX: temporaryArea.value!.secondPointX + details.delta.dx,
        secondPointY: temporaryArea.value!.secondPointY + details.delta.dy,
      );
    }

    void handleChangeMode() {
      if (currentMode == ReplaceEditMode.moveSelect) {
        ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
        resetToNextArea();
      } else {
        ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.moveSelect);
        selectedArea.value = temporaryArea.value;
        movePosition.value = Offset(
          temporaryArea.value!.firstPointX > temporaryArea.value!.secondPointX
              ? temporaryArea.value!.secondPointX
              : temporaryArea.value!.firstPointX,
          temporaryArea.value!.firstPointY > temporaryArea.value!.secondPointY
              ? temporaryArea.value!.secondPointY
              : temporaryArea.value!.firstPointY,
        );

        if (pickImage == null) return;
        final sizeConvertRate = pickImage.image.width / w;
        final Rect rect = Rect.fromPoints(
            Offset(
                selectedArea.value!.firstPointX * sizeConvertRate, selectedArea.value!.firstPointY * sizeConvertRate),
            Offset(selectedArea.value!.secondPointX * sizeConvertRate,
                selectedArea.value!.secondPointY * sizeConvertRate));

        ref.read(captureScreenStateProvider.notifier).clipImage(pickImage.image, rect);
      }
    }

    Future<void> handleSelectMoved() async {
      if (movePosition.value == Offset.zero) {
        print('not move');
        return;
      }
      if (selectedArea.value == null) {
        print('not selected area');
        return;
      }

      if (captureImage == null) return;
      final convertedThumbnail = await ThumbnailResizeUint8ListConverter().convertThumbnail(captureImage, 100, 100);
      ref.read(replaceThumbnailStateProvider.notifier).addThumbnail(convertedThumbnail);

      final replaceDataId = (replaceFormatData.replaceDataList.length + 1).toString();
      final addData = ReplaceData(
          replaceDataId: replaceDataId,
          area: selectedArea.value!,
          moveDelta: MoveDelta(dx: movePosition.value.dx, dy: movePosition.value.dy));

      ref.read(replaceFormatStateProvider.notifier).addReplaceData(addData);
      resetToNextArea();
    }

    void backHome(BuildContext context) {
      resetAll();
      context.go('/');
    }

    return Scaffold(
      backgroundColor: const Color(MyColors.light),
      appBar: AppBar(
        backgroundColor: const Color(MyColors.orange1),
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Color(MyColors.light),
            size: 32,
          ),
          onPressed: () {
            backHome(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                print('export');
                context.push('/export_page');
              },
              icon: const FaIcon(
                FontAwesomeIcons.arrowUpRightFromSquare,
                color: Color(MyColors.light),
              ))
        ],
        title: Text('Replace Edit', style: MyTextStyles.subtitle),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            pickImage == null
                ? const SizedBox()
                : Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: w,
                      height: pickImage.image.height / pickImage.image.width * w,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: ImagePainter(pickImage.image),
                          // size: Size(pickImage.image.width.toDouble(), pickImage.image.height.toDouble()),
                        ),
                      ),
                    ),
                  ),
            GestureDetector(
              onPanStart: (details) {
                handleFirstTapImage(details);
              },
              onPanUpdate: (details) {
                handleAreaSelect(details);
              },
              child: Container(
                width: w,
                height: imageArea.dy,
                color: Colors.transparent,
              ),
            ),

            /// selected area
            selectedArea.value != null
                ? CaptureWidget(
                    area: selectedArea.value ?? const AreaModel(),
                    color: Colors.red,
                  )
                : const SizedBox(),

            /// selectable area
            GestureDetector(
              onPanUpdate: (details) {
                handleOnPanUpdate(details);
              },
              child: AreaSelectWidget(
                area: temporaryArea.value ?? const AreaModel(),
                color: Colors.red,
                isSelected: currentMode == ReplaceEditMode.moveSelect,
              ),
            ),

            //// キャプチャした画像 move select mode
            captureImage != null && pickImage != null && selectedArea.value != null
                ? Positioned(
                    top: movePosition.value.dy,
                    left: movePosition.value.dx,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        print('move');
                        movePosition.value = Offset(
                          movePosition.value.dx + details.delta.dx,
                          movePosition.value.dy + details.delta.dy,
                        );
                      },
                      child: Container(
                        color: Colors.blue.withOpacity(0.5),
                        width: (selectedArea.value!.secondPointX - selectedArea.value!.firstPointX).abs(),
                        height: (selectedArea.value!.secondPointY - selectedArea.value!.firstPointY).abs(),
                        // width: (temporaryArea.value!.secondPointX - temporaryArea.value!.firstPointX).abs(),
                        // height: (temporaryArea.value!.secondPointY - temporaryArea.value!.firstPointY).abs(),
                        child: CustomPaint(
                          painter: ImagePainter(captureImage),
                          // size: Size(captureImage.width.toDouble() * w / (pickImage.image.width),
                          //     captureImage.height.toDouble() * w / (pickImage.image.width)),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Positioned(
              bottom: 100,
              left: 0,
              child:
                  SizedBox(width: w, height: 150, child: MoveSelectListView(list: replaceFormatData.replaceDataList)),
            ),

            /// 右下のプラスボタン
            Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                onPressed: () {
                  handlePickImage();
                },
                icon: const FaIcon(
                  FontAwesomeIcons.plus,
                  color: Color(MyColors.orange1),
                  size: 50,
                ),
              ),
            ),

            /// 左下のモードチェンジボタン
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(MyColors.orange1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    currentMode == ReplaceEditMode.areaSelect
                        ? GestureDetector(
                            onTap: () {
                              if (temporaryArea.value == null) return;
                              lottieController.reset();
                              lottieController.forward();
                              handleChangeMode();
                            },
                            child: Lottie.asset('assets/lottie/area.json',
                                controller: lottieController,
                                addRepaintBoundary: true,
                                repeat: false,
                                width: 50,
                                height: 50))
                        : GestureDetector(
                            onTap: () {
                              lottieController.reset();
                              lottieController.forward();
                              handleChangeMode();
                            },
                            child: Lottie.asset('assets/lottie/move.json',
                                controller: lottieController,
                                addRepaintBoundary: true,
                                repeat: false,
                                width: 50,
                                height: 50)),
                    const SizedBox(width: 24),
                    IconButton(
                        onPressed: () {
                          handleSelectMoved();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.check,
                          color: Color(
                            MyColors.light,
                          ),
                          size: 40,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 画像を描画するためのCustomPainter ui.Imageを使用しているため
class ImagePainter extends CustomPainter {
  final ui.Image image;
  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    print('paint$size');
    paintImage(canvas: canvas, rect: Rect.fromLTWH(0, 0, size.width, size.height), image: image);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MoveSelectListView extends ConsumerWidget {
  final List<ReplaceData?> list;
  const MoveSelectListView({super.key, required this.list});

  static const double _height = 70;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnailList = ref.watch(replaceThumbnailStateProvider);

    void handleDelete(int index) {
      ref.read(replaceFormatStateProvider.notifier).removeReplaceData(index);
      ref.read(replaceThumbnailStateProvider.notifier).removeThumbnail(index);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print('tapped');
          },
          child: Align(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(MyColors.orange1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          handleDelete(index);
                        },
                        child: Container(
                          height: _height,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(MyColors.light),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.trash,
                            color: Color(MyColors.orange1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: _height,
                        height: _height,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(MyColors.light),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: thumbnailList.length > index
                            ? GestureDetector(
                                onTap: () {
                                  print('tapped $index');
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6), child: Image.memory(thumbnailList[index])),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
