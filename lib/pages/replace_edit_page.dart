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

class ReplaceEditPage extends HookConsumerWidget {
  const ReplaceEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final temporaryFirstPoint = useState<Offset?>(null);
    final movedPosition = useState<Offset>(Offset.zero);
    final temporaryArea = useState<AreaModel?>(null); // before move
    final selectedArea = useState<AreaModel?>(null); // after move
    final lottieController = useAnimationController(duration: const Duration(milliseconds: 2000), initialValue: 1);
    final currentMode = ref.watch(replaceEditStateProvider);
    final pickImage = ref.watch(pickImageStateProvider);
    final captureImage = ref.watch(captureScreenStateProvider);
    final replaceFormatData = ref.watch(replaceFormatStateProvider);
    final replaceCheckData = ref.watch(checkReplaceDataStateProvider);
    final displaySizeRate = useState(1.0); // 画像が画面がへoverflowした場合に小さくする用
    final imageSizeConvertRate = useState(1.0); // pickImage width / display width

    final Offset imageArea =
        pickImage != null ? Offset(w, pickImage.image.height / pickImage.image.width * w) : Offset.zero;

    void resetToNextArea() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movedPosition.value = Offset.zero;
      ref.read(checkReplaceDataStateProvider.notifier).clear();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
      ref.read(captureScreenStateProvider.notifier).clear();
    }

    void resetAll() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movedPosition.value = Offset.zero;
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
      temporaryFirstPoint.value = details.localPosition * imageSizeConvertRate.value;
    }

    void handleAreaSelect(details) {
      if (currentMode == ReplaceEditMode.moveSelect) return;
      temporaryArea.value = AreaModel(
        firstPointX: temporaryFirstPoint.value!.dx,
        firstPointY: temporaryFirstPoint.value!.dy,
        secondPointX: details.localPosition.dx * imageSizeConvertRate.value,
        secondPointY: details.localPosition.dy * imageSizeConvertRate.value,
      );
    }

    void handlePickImage() async {
      final result = await ref.read(imagePickUseCaseProvider).pickImage();
      if (!result) return;
      resetAll();
    }

    /// pick imageが画面より縦長の場合、imageを小さくする
    void setPickImageAspectRatio() {
      if (pickImage == null) return;
      final mediaQuery = MediaQuery.of(context);

      final pickImageAspectRatio = pickImage.image.width / pickImage.image.height;
      final displayEffectiveRange = h - (mediaQuery.padding.top + kToolbarHeight + mediaQuery.padding.bottom);
      final displayAspectRatio = w / displayEffectiveRange;

      /// pick imageが画面より縦長の場合
      if (pickImageAspectRatio < displayAspectRatio) {
        final convertedHeight = w / pickImage.image.width * pickImage.image.height;
        final rate = displayEffectiveRange / convertedHeight;
        displaySizeRate.value = rate;
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        resetAll();
      });

      return null;
    }, []);
    useEffect(() {
      if (pickImage == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setPickImageAspectRatio();
      });

      imageSizeConvertRate.value = pickImage.image.width / w / displaySizeRate.value;

      return null;
    }, [pickImage]);

    void handleOnPanUpdate(details) {
      temporaryArea.value = AreaModel(
        firstPointX: temporaryArea.value!.firstPointX + details.delta.dx * imageSizeConvertRate.value,
        firstPointY: temporaryArea.value!.firstPointY + details.delta.dy * imageSizeConvertRate.value,
        secondPointX: temporaryArea.value!.secondPointX + details.delta.dx * imageSizeConvertRate.value,
        secondPointY: temporaryArea.value!.secondPointY + details.delta.dy * imageSizeConvertRate.value,
      );
    }

    void handleChangeMode() {
      if (currentMode == ReplaceEditMode.moveSelect) {
        ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
        resetToNextArea();
      } else {
        ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.moveSelect);
        selectedArea.value = temporaryArea.value;
        movedPosition.value = Offset(
          min(temporaryArea.value!.firstPointX, temporaryArea.value!.secondPointX),
          min(temporaryArea.value!.firstPointY, temporaryArea.value!.secondPointY),
        );

        if (pickImage == null) return;
        final Rect rect = Rect.fromPoints(Offset(selectedArea.value!.firstPointX, selectedArea.value!.firstPointY),
            Offset(selectedArea.value!.secondPointX, selectedArea.value!.secondPointY));

        ref.read(captureScreenStateProvider.notifier).clipImage(pickImage.image, rect);
      }
    }

    MoveDelta? convertDeltaAreaModel() {
      if (temporaryArea.value == null || selectedArea.value == null) {
        print('convertDeltaAreaModel args null');
        return null;
      }
      final deltaX = movedPosition.value.dx - min(selectedArea.value!.firstPointX, selectedArea.value!.secondPointX);
      final deltaY = movedPosition.value.dy - min(selectedArea.value!.firstPointY, selectedArea.value!.secondPointY);

      return MoveDelta(
        dx: deltaX,
        dy: deltaY,
      );
    }

    Future<void> handleMovedSave() async {
      if (movedPosition.value == Offset.zero) {
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
            backHome(context);
          },
        ),
        actions: [
          replaceFormatData.replaceDataList.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    context.push('/export_page');
                  },
                  padding: const EdgeInsets.only(right: 12),
                  icon: FaIcon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    color: Theme.of(context).primaryColor,
                  ))
              : const SizedBox(),
        ],
        title: Text('Replace Edit', style: MyTextStyles.subtitle.copyWith(color: Theme.of(context).primaryColor)),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            pickImage == null
                ? const SizedBox()
                : Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      color: Colors.red,
                      width: w * displaySizeRate.value,
                      height: pickImage.image.height / pickImage.image.width * w * displaySizeRate.value,
                      child: CustomPaint(
                        painter: ImagePainter(pickImage.image),
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

            /// replace date check widget
            replaceCheckData != null
                ? AreaSelectWidget(
                    area: replaceCheckData.area,
                    color: Colors.green,
                    isSelected: false,
                    resizeRate: imageSizeConvertRate.value,
                  )
                : const SizedBox(),
            replaceCheckData != null
                ? AreaSelectWidget(
                    area: convertMovedAreaForCheck(), // TODO
                    color: Colors.green,
                    isSelected: true,
                    resizeRate: imageSizeConvertRate.value,
                  )
                : const SizedBox(),

            /// selectable area
            GestureDetector(
              onPanUpdate: (details) {
                handleOnPanUpdate(details);
              },
              child: AreaSelectWidget(
                area: temporaryArea.value ?? const AreaModel(),
                color: const Color(MyColors.orange1),
                isSelected: currentMode == ReplaceEditMode.moveSelect,
                resizeRate: imageSizeConvertRate.value,
              ),
            ),

            /// キャプチャした画像
            captureImage != null && pickImage != null && selectedArea.value != null
                ? Positioned(
                    top: movedPosition.value.dy / imageSizeConvertRate.value,
                    left: movedPosition.value.dx / imageSizeConvertRate.value,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        movedPosition.value = Offset(
                          movedPosition.value.dx + details.delta.dx * imageSizeConvertRate.value,
                          movedPosition.value.dy + details.delta.dy * imageSizeConvertRate.value,
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
                        width: (selectedArea.value!.secondPointX - selectedArea.value!.firstPointX).abs() /
                            imageSizeConvertRate.value,
                        height: (selectedArea.value!.secondPointY - selectedArea.value!.firstPointY).abs() /
                            imageSizeConvertRate.value,
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
                    bottom: 50,
                    right: 50,
                    child: GestureDetector(
                      onTap: () {
                        handlePickImage();
                      },
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Lottie.asset(
                            'assets/lottie/add.json',
                            repeat: true,
                            addRepaintBoundary: true,
                          )),
                    ))
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
                              icon: FaIcon(
                                FontAwesomeIcons.check,
                                color: Theme.of(context).primaryColor,
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
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Select Area',
                                  style: MyTextStyles.body.copyWith(color: Theme.of(context).primaryColor),
                                ),
                                Text(
                                  'Mode',
                                  style: MyTextStyles.small.copyWith(color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(height: 3),
                              ],
                            ))
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: const Color(MyColors.orange1), width: 2.5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Move Area',
                                  style: MyTextStyles.body.copyWith(color: const Color(MyColors.orange1)),
                                ),
                                Text(
                                  'Mode',
                                  style: MyTextStyles.small.copyWith(color: const Color(MyColors.orange1)),
                                ),
                                const SizedBox(height: 3),
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

/// ui.Imageの画像を描画するためのCustomPainter
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
                                          color: Theme.of(context).primaryColor,
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
                                            color: Theme.of(context).primaryColor,
                                            border: Border.all(color: const Color(MyColors.orange1), width: 2)),
                                        child: Text(list.length.toString(),
                                            style: MyTextStyles.small.copyWith(color: const Color(MyColors.orange1)))),
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
                                            color: Theme.of(context).primaryColor,
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
                                          color: Theme.of(context).primaryColor,
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
