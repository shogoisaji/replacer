import 'dart:math';
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
import 'package:replacer/states/check_replace_data_state.dart';
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
import 'package:replacer/widgets/capture_area_widget.dart';

class ReplaceEditPage extends HookConsumerWidget {
  const ReplaceEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final temporaryFirstPoint = useState<Offset?>(null);
    final movePosition = useState<Offset>(Offset.zero);
    final temporaryArea = useState<AreaModel?>(null); // before move
    final selectedArea = useState<AreaModel?>(null); // after move
    final lottieController = useAnimationController(duration: const Duration(milliseconds: 2000), initialValue: 1);
    final currentMode = ref.watch(replaceEditStateProvider);
    final pickImage = ref.watch(pickImageStateProvider);
    final captureImage = ref.watch(captureScreenStateProvider);
    final replaceFormatData = ref.watch(replaceFormatStateProvider);
    final replaceCheckData = ref.watch(checkReplaceDataStateProvider);

    final Offset imageArea =
        pickImage != null ? Offset(w, pickImage.image.height / pickImage.image.width * w) : Offset.zero;

    void resetToNextArea() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movePosition.value = Offset.zero;
      ref.read(checkReplaceDataStateProvider.notifier).clear();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
      ref.read(captureScreenStateProvider.notifier).clear();
    }

    void resetAll() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movePosition.value = Offset.zero;
      ref.read(checkReplaceDataStateProvider.notifier).clear();
      ref.read(replaceThumbnailStateProvider.notifier).clear();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
      ref.read(replaceEditPageStateProvider.notifier).clear();
      ref.read(captureScreenStateProvider.notifier).clear();
      ref.read(replaceFormatStateProvider.notifier).replaceDataReset();
    }

    void handleFirstTapImage(details) {
      ref.read(checkReplaceDataStateProvider.notifier).clear();
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
          min(temporaryArea.value!.firstPointX, temporaryArea.value!.secondPointX),
          min(temporaryArea.value!.firstPointY, temporaryArea.value!.secondPointY),
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

    MoveDelta? convertDeltaAreaModel() {
      if (temporaryArea.value == null || selectedArea.value == null) {
        print('convertDeltaAreaModel args null');
        return null;
      }
      final deltaX = movePosition.value.dx - min(selectedArea.value!.firstPointX, selectedArea.value!.secondPointX);
      final deltaY = movePosition.value.dy - min(selectedArea.value!.firstPointY, selectedArea.value!.secondPointY);

      return MoveDelta(
        dx: deltaX,
        dy: deltaY,
      );
    }

    Future<void> handleMovedSave() async {
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
      final delta = convertDeltaAreaModel();
      if (delta == null) {
        print('delta null');
        return;
      }
      final addData = ReplaceData(
          replaceDataId: replaceDataId, area: selectedArea.value!, moveDelta: MoveDelta(dx: delta.dx, dy: delta.dy));
      ref.read(replaceFormatStateProvider.notifier).addReplaceData(addData);
      resetToNextArea();
    }

    AreaModel convertMovedAreaForCheck() {
      if (replaceCheckData == null) {
        print('replaceCheckData null');
        return const AreaModel();
      }

      return AreaModel(
        firstPointX: replaceCheckData.area.firstPointX + replaceCheckData.moveDelta.dx,
        firstPointY: replaceCheckData.area.firstPointY + replaceCheckData.moveDelta.dy,
        secondPointX: replaceCheckData.area.secondPointX + replaceCheckData.moveDelta.dx,
        secondPointY: replaceCheckData.area.secondPointY + replaceCheckData.moveDelta.dy,
      );
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
          replaceFormatData.replaceDataList.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    print('export');
                    context.push('/export_page');
                  },
                  padding: const EdgeInsets.only(right: 12),
                  icon: const FaIcon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    color: Color(MyColors.light),
                  ))
              : const SizedBox(),
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
                ? CaptureAreaWidget(
                    area: selectedArea.value ?? const AreaModel(),
                    color: Colors.red,
                  )
                : const SizedBox(),

            /// replace date check widget
            replaceCheckData != null
                ? AreaSelectWidget(
                    area: replaceCheckData.area,
                    color: Colors.green,
                    isSelected: false,
                  )
                : const SizedBox(),
            replaceCheckData != null
                ? AreaSelectWidget(
                    area: convertMovedAreaForCheck(), // TODO
                    color: Colors.green,
                    isSelected: true,
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

            /// キャプチャした画像
            captureImage != null && pickImage != null && selectedArea.value != null
                ? Positioned(
                    top: movePosition.value.dy,
                    left: movePosition.value.dx,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        movePosition.value = Offset(
                          movePosition.value.dx + details.delta.dx,
                          movePosition.value.dy + details.delta.dy,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        width: (selectedArea.value!.secondPointX - selectedArea.value!.firstPointX).abs(),
                        height: (selectedArea.value!.secondPointY - selectedArea.value!.firstPointY).abs(),
                        child: CustomPaint(
                          painter: ImagePainter(captureImage),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),

            /// replace data list
            replaceFormatData.replaceDataList.isNotEmpty
                ? Positioned(bottom: 100, left: 0, child: ReplaceDataListView(list: replaceFormatData.replaceDataList))
                : const SizedBox(),

            /// 下のプラスボタン
            pickImage == null
                ? Positioned(
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
                  )
                : const SizedBox(),

            /// 下のモードチェンジボタン
            pickImage != null
                ? Positioned(
                    bottom: 20,
                    right: 20,
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
                                handleMovedSave();
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
                  )
                : const SizedBox(),

            /// current mode label
            pickImage != null
                ? Positioned(
                    bottom: 20,
                    left: 20,
                    child: currentMode == ReplaceEditMode.areaSelect
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(MyColors.orange1),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: const Color(MyColors.light), width: 2),
                            ),
                            child: Column(
                              children: [
                                Text('Select Area', style: MyTextStyles.bodyLight),
                                Text('Mode', style: MyTextStyles.smallLight),
                                const SizedBox(height: 2),
                              ],
                            ))
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(MyColors.light),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: const Color(MyColors.orange1), width: 2.5),
                            ),
                            child: Column(
                              children: [
                                Text('Move Area', style: MyTextStyles.bodyOrange),
                                Text('Mode', style: MyTextStyles.smallOrange),
                                const SizedBox(height: 2),
                              ],
                            )),
                  )
                : const SizedBox(),
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
    print('custom painter paint too many ?');
    paintImage(canvas: canvas, rect: Rect.fromLTWH(0, 0, size.width, size.height), image: image);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ReplaceDataListView extends HookConsumerWidget {
  final List<ReplaceData?> list;
  const ReplaceDataListView({super.key, required this.list});

  static const double _innerWidgetHeight = 70;
  static const double _arrowButtonWidth = 70;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final thumbnailList = ref.watch(replaceThumbnailStateProvider);
    final slideAnimationController = useAnimationController(duration: const Duration(milliseconds: 400));
    final sliderAnimation = CurvedAnimation(parent: slideAnimationController, curve: Curves.easeInOut);

    void handleDelete(int index) {
      ref.read(checkReplaceDataStateProvider.notifier).clear();
      ref.read(replaceFormatStateProvider.notifier).removeReplaceData(index);
      ref.read(replaceThumbnailStateProvider.notifier).removeThumbnail(index);
    }

    void handleTapThumbnail(int index) {
      ref.read(checkReplaceDataStateProvider.notifier).setData(list[index]!);
    }

    return SizedBox(
      width: w,
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: sliderAnimation,
            builder: (context, child) {
              return Positioned(
                left: (1 - sliderAnimation.value) * (w - _arrowButtonWidth),
                child: SizedBox(
                  width: w,
                  height: 150,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (slideAnimationController.isCompleted) {
                            slideAnimationController.reverse();
                          } else {
                            slideAnimationController.forward();
                          }
                        },
                        child: Center(
                          child: Container(
                              width: _arrowButtonWidth,
                              height: _arrowButtonWidth,
                              padding: const EdgeInsets.all(8),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(MyColors.light),
                                          border: Border.all(color: const Color(MyColors.orange1), width: 2)),
                                      child: slideAnimationController.isCompleted
                                          ? const Icon(Icons.arrow_forward, color: Color(MyColors.orange1), size: 32)
                                          : const Icon(Icons.arrow_back, color: Color(MyColors.orange1), size: 32),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(MyColors.light),
                                            border: Border.all(color: const Color(MyColors.orange1), width: 2)),
                                        child: Text(list.length.toString(), style: MyTextStyles.smallOrange)),
                                  )
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                          width: w - _arrowButtonWidth,
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Align(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(MyColors.orange1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      GestureDetector(
                                        onTap: () {
                                          handleDelete(index);
                                        },
                                        child: Container(
                                          height: _innerWidgetHeight,
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
                                        width: _innerWidgetHeight,
                                        height: _innerWidgetHeight,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: const Color(MyColors.light),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: thumbnailList.length > index
                                            ? GestureDetector(
                                                onTap: () {
                                                  handleTapThumbnail(index);
                                                },
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(6),
                                                    child: Image.memory(thumbnailList[index])),
                                              )
                                            : const SizedBox(),
                                      )
                                    ])
                                  ]),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
