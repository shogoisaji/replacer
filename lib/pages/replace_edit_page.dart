import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:replacer/states/replace_edit_state.dart';
import 'package:replacer/states/replace_format_state.dart';
import 'package:replacer/states/replace_thumbnail_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';
import 'package:replacer/use_case/image_pick_usecase.dart';
import 'package:replacer/use_case/refresh_cache_usecase.dart';
import 'package:replacer/utils/area_to_rectangle.dart';
import 'package:replacer/utils/thumbnail_resize_converter.dart';
import 'package:replacer/widgets/area_select_widget.dart';
import 'package:replacer/widgets/canvas_area_mask_widget.dart';

enum PointerPosition { topLeft, topRight, bottomLeft, bottomRight }

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
    final isDetailAvailable = useState(false);
    final pointerAnimationController = useAnimationController(duration: const Duration(milliseconds: 800));
    final lottieEffectController =
        useAnimationController(duration: const Duration(milliseconds: 2000), initialValue: 1);
    final lottieSelectorController =
        useAnimationController(duration: const Duration(milliseconds: 2000), initialValue: 1);
    final currentMode = ref.watch(replaceEditStateProvider);
    final pickImage = ref.watch(pickImageStateProvider);
    final captureImage = ref.watch(captureScreenStateProvider);
    final replaceFormatData = ref.watch(replaceFormatStateProvider);
    final replaceCheckData = ref.watch(checkReplaceDataStateProvider);
    final displaySizeRate = useState(1.0); // 画像が画面がへoverflowした場合に小さくする用
    final imageSizeConvertRate = useState(1.0); // pickImage width / display width
    final double minSize = 30 * imageSizeConvertRate.value;

    final TweenSequence<double> pointerAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 0.9), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 0.8), weight: 0.6),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2), weight: 0.7),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 0.8),
    ]);

    void resetToNextArea() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movedPosition.value = Offset.zero;
      isDetailAvailable.value = false;
      ref.read(checkReplaceDataStateProvider.notifier).clear();
      ref.read(captureScreenStateProvider.notifier).clear();
      lottieEffectController.reset();
    }

    void resetAll() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movedPosition.value = Offset.zero;
      ref.read(refreshCacheUseCaseProvider.notifier).execute();
    }

    void handlePickImage() async {
      final pickImageSize = await ref.read(imagePickUseCaseProvider).pickImage();
      if (pickImageSize == null) return;
      if (replaceFormatData.canvasArea == null) {
        final area = AreaModel(
            firstPointX: 0,
            firstPointY: 0,
            secondPointX: pickImageSize.width.toDouble(),
            secondPointY: pickImageSize.height.toDouble());
        ref.read(replaceFormatStateProvider.notifier).setCanvasArea(area);
      }
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

    void handleFirstPointSelect(details) {
      if (currentMode == ReplaceEditMode.moveSelect || currentMode == ReplaceEditMode.areaDetailSelect) return;
      ref.read(checkReplaceDataStateProvider.notifier).clear();
      lottieEffectController.reset();
      temporaryArea.value = null;
      temporaryFirstPoint.value = details.localPosition * imageSizeConvertRate.value;
    }

    void handleSecondPointSelect(details) {
      if (currentMode == ReplaceEditMode.moveSelect || currentMode == ReplaceEditMode.areaDetailSelect) return;
      final nextSecondPointX = details.localPosition.dx * imageSizeConvertRate.value;
      final nextSecondPointY = details.localPosition.dy * imageSizeConvertRate.value;
      if (nextSecondPointX > pickImage!.image.width || nextSecondPointY > pickImage.image.height) return;
      final w = (temporaryFirstPoint.value!.dx - nextSecondPointX).abs();
      final h = (temporaryFirstPoint.value!.dy - nextSecondPointY).abs();

      if (w > minSize || h > minSize) {
        isDetailAvailable.value = true;
        lottieEffectController.repeat();
      } else {
        isDetailAvailable.value = false;
        lottieEffectController.reset();
      }

      if (w < minSize || h < minSize) return;
      if (currentMode == ReplaceEditMode.areaSelect) {
        temporaryArea.value = AreaModel(
          firstPointX: temporaryFirstPoint.value!.dx,
          firstPointY: temporaryFirstPoint.value!.dy,
          secondPointX: nextSecondPointX,
          secondPointY: nextSecondPointY,
        );
      }
    }

    void handleMoveUpdate(details) {
      if (!lottieEffectController.isAnimating) lottieEffectController.repeat();
      movedPosition.value = Offset(
        movedPosition.value.dx + details.delta.dx * imageSizeConvertRate.value,
        movedPosition.value.dy + details.delta.dy * imageSizeConvertRate.value,
      );
    }

    MoveDelta? convertDeltaAreaModel() {
      if (temporaryArea.value == null || selectedArea.value == null) {
        return null;
      }
      final deltaX = movedPosition.value.dx - min(selectedArea.value!.firstPointX, selectedArea.value!.secondPointX);
      final deltaY = movedPosition.value.dy - min(selectedArea.value!.firstPointY, selectedArea.value!.secondPointY);

      return MoveDelta(
        dx: deltaX,
        dy: deltaY,
      );
    }

    void handleCancelMove() {
      resetToNextArea();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
    }

    Future<void> handleMovedSave() async {
      if (!lottieEffectController.isAnimating) return; // select areaが動いていれば
      if (selectedArea.value == null) {
        return;
      }

      if (captureImage == null) return;
      final convertedThumbnail = await ThumbnailResizeUint8ListConverter().convertThumbnail(captureImage, 100, 100);
      ref.read(replaceThumbnailStateProvider.notifier).addThumbnail(convertedThumbnail);

      final replaceDataId = (replaceFormatData.replaceDataList.length + 1).toString();
      final delta = convertDeltaAreaModel();
      if (delta == null) {
        return;
      }
      final addData = ReplaceData(
          replaceDataId: replaceDataId, area: selectedArea.value!, moveDelta: MoveDelta(dx: delta.dx, dy: delta.dy));
      ref.read(replaceFormatStateProvider.notifier).addReplaceData(addData);
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
      resetToNextArea();
    }

    bool updateValidate(AreaModel area) {
      if (area.secondPointX > pickImage!.image.width) return false;
      if (area.secondPointY > pickImage.image.height) return false;
      if (area.firstPointX < 0) return false;
      if (area.firstPointY < 0) return false;
      if ((area.firstPointX - area.secondPointX).abs() < minSize) return false;
      if ((area.firstPointY - area.secondPointY).abs() < minSize) return false;
      return true;
    }

    void handleAreaDetailSelect(DragUpdateDetails details, PointerPosition position) {
      if (temporaryArea.value == null) return;

      final organizedCurrentArea = AreaModel(
          firstPointX: min(temporaryArea.value!.firstPointX, temporaryArea.value!.secondPointX),
          firstPointY: min(temporaryArea.value!.firstPointY, temporaryArea.value!.secondPointY),
          secondPointX: max(temporaryArea.value!.firstPointX, temporaryArea.value!.secondPointX),
          secondPointY: max(temporaryArea.value!.firstPointY, temporaryArea.value!.secondPointY));

      switch (position) {
        case PointerPosition.topLeft:
          final nextFirstPointX = organizedCurrentArea.firstPointX + details.delta.dx * imageSizeConvertRate.value;
          final nextFirstPointY = organizedCurrentArea.firstPointY + details.delta.dy * imageSizeConvertRate.value;
          final nextSecondPointX = organizedCurrentArea.secondPointX;
          final nextSecondPointY = organizedCurrentArea.secondPointY;
          final nextArea = AreaModel(
            firstPointX: nextFirstPointX,
            firstPointY: nextFirstPointY,
            secondPointX: nextSecondPointX,
            secondPointY: nextSecondPointY,
          );
          if (!updateValidate(nextArea)) return;
          temporaryArea.value = nextArea;
          break;
        case PointerPosition.topRight:
          final nextFirstPointX = organizedCurrentArea.firstPointX;
          final nextFirstPointY = organizedCurrentArea.firstPointY + details.delta.dy * imageSizeConvertRate.value;
          final nextSecondPointX = organizedCurrentArea.secondPointX + details.delta.dx * imageSizeConvertRate.value;
          final nextSecondPointY = organizedCurrentArea.secondPointY;
          final nextArea = AreaModel(
            firstPointX: nextFirstPointX,
            firstPointY: nextFirstPointY,
            secondPointX: nextSecondPointX,
            secondPointY: nextSecondPointY,
          );
          if (!updateValidate(nextArea)) return;
          temporaryArea.value = nextArea;
          break;
        case PointerPosition.bottomLeft:
          final nextFirstPointX = organizedCurrentArea.firstPointX + details.delta.dx * imageSizeConvertRate.value;
          final nextFirstPointY = organizedCurrentArea.firstPointY;
          final nextSecondPointX = organizedCurrentArea.secondPointX;
          final nextSecondPointY = organizedCurrentArea.secondPointY + details.delta.dy * imageSizeConvertRate.value;
          final nextArea = AreaModel(
            firstPointX: nextFirstPointX,
            firstPointY: nextFirstPointY,
            secondPointX: nextSecondPointX,
            secondPointY: nextSecondPointY,
          );
          if (!updateValidate(nextArea)) return;
          temporaryArea.value = nextArea;
          break;
        case PointerPosition.bottomRight:
          final nextFirstPointX = organizedCurrentArea.firstPointX;
          final nextFirstPointY = organizedCurrentArea.firstPointY;
          final nextSecondPointX = organizedCurrentArea.secondPointX + details.delta.dx * imageSizeConvertRate.value;
          final nextSecondPointY = organizedCurrentArea.secondPointY + details.delta.dy * imageSizeConvertRate.value;
          final nextArea = AreaModel(
            firstPointX: nextFirstPointX,
            firstPointY: nextFirstPointY,
            secondPointX: nextSecondPointX,
            secondPointY: nextSecondPointY,
          );
          if (!updateValidate(nextArea)) return;
          temporaryArea.value = nextArea;
          break;
        default:
          break;
      }
    }

    void handleAreaDetailMode() {
      pointerAnimationController.reset();
      pointerAnimationController.forward();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaDetailSelect);
    }

    void handleAreaSelect() {
      if (!isDetailAvailable.value) {
        return;
      }
      lottieEffectController.reset();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.moveSelect);

      /// 選択したAreaを保存
      selectedArea.value = temporaryArea.value;

      /// 移動前の初期値を代入
      movedPosition.value = Offset(
        min(temporaryArea.value!.firstPointX, temporaryArea.value!.secondPointX),
        min(temporaryArea.value!.firstPointY, temporaryArea.value!.secondPointY),
      );

      /// 一時的なClipImageの範囲を設定
      final rect = AreaToRectangle().convert(selectedArea.value!);
      if (pickImage == null) return;
      ref.read(captureScreenStateProvider.notifier).clipImage(pickImage.image, rect);
    }

    void handleChangeCanvasSelectMode() {
      if (pickImage == null) return;
      pointerAnimationController.reset();
      pointerAnimationController.forward();
      ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.canvasSelect);
      resetToNextArea();
    }

    AreaModel convertMovedAreaForCheck() {
      if (replaceCheckData == null) {
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

    useEffect(() {
      if (pickImage == null) return;
      lottieSelectorController.reset();
      lottieSelectorController.forward();

      return null;
    }, [currentMode, pickImage]);

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
        imageSizeConvertRate.value = pickImage.image.width / w / displaySizeRate.value;
      });

      return null;
    }, [pickImage]);

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
                    context.push('/export_page', extra: false);
                  },
                  padding: const EdgeInsets.only(right: 20),
                  icon: FaIcon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ))
              : const SizedBox(),
        ],
        title: Text('ReplaceEdit', style: MyTextStyles.subtitle.copyWith(color: Theme.of(context).primaryColor)),
      ),

      /// イメージがある場合はデバイスのバックを無効化
      body: PopScope(
        canPop: pickImage != null ? false : true,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              pickImage == null
                  ? const SizedBox.shrink()
                  : Positioned(
                      top: 0,
                      left: 0,
                      child: RepaintBoundary(
                        child: SizedBox(
                          width: w * displaySizeRate.value,
                          height: pickImage.image.height / pickImage.image.width * w * displaySizeRate.value,
                          child: CustomPaint(
                            painter: ImagePainter(pickImage.image),
                          ),
                        ),
                      ),
                    ),
              pickImage == null
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onPanStart: (details) {
                        handleFirstPointSelect(details);
                      },
                      onPanUpdate: (details) {
                        handleSecondPointSelect(details);
                      },
                      child: Container(
                        width: w * displaySizeRate.value,
                        height: pickImage.image.height / pickImage.image.width * w * displaySizeRate.value,
                        color: Colors.transparent,
                      ),
                    ),

              /// replace date check widget
              replaceCheckData != null
                  ? IgnorePointer(
                      child: AreaSelectWidget(
                        area: replaceCheckData.area,
                        isRed: false,
                        isSelected: false,
                        resizeRate: imageSizeConvertRate.value,
                      ),
                    )
                  : const SizedBox(),
              replaceCheckData != null
                  ? IgnorePointer(
                      child: AreaSelectWidget(
                        area: convertMovedAreaForCheck(), // TODO
                        isRed: false,
                        isSelected: true,
                        resizeRate: imageSizeConvertRate.value,
                      ),
                    )
                  : const SizedBox(),

              /// selectable area
              AreaSelectWidget(
                area: temporaryArea.value ?? const AreaModel(),
                isRed: true,
                isSelected: currentMode == ReplaceEditMode.moveSelect,
                resizeRate: imageSizeConvertRate.value,
              ),

              /// キャプチャした画像
              captureImage != null && pickImage != null && selectedArea.value != null
                  ? Positioned(
                      top: movedPosition.value.dy / imageSizeConvertRate.value,
                      left: movedPosition.value.dx / imageSizeConvertRate.value,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          handleMoveUpdate(details);
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.6),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 2),
                                  ),
                                  const BoxShadow(
                                    color: Color(MyColors.orange1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              width: (selectedArea.value!.secondPointX - selectedArea.value!.firstPointX).abs() /
                                  imageSizeConvertRate.value,
                              height: (selectedArea.value!.secondPointY - selectedArea.value!.firstPointY).abs() /
                                  imageSizeConvertRate.value,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width:
                                          (selectedArea.value!.secondPointX - selectedArea.value!.firstPointX).abs() /
                                              imageSizeConvertRate.value,
                                      height:
                                          (selectedArea.value!.secondPointY - selectedArea.value!.firstPointY).abs() /
                                              imageSizeConvertRate.value,
                                      child: RepaintBoundary(
                                        child: CustomPaint(
                                          painter: ImagePainter(captureImage),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Lottie.asset('assets/lottie/move_arrow.json',
                                          addRepaintBoundary: true, repeat: true, width: 54, height: 54)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),

              // canvas size mask
              pickImage != null
                  ? IgnorePointer(
                      child: CanvasAreaMaskWidget(
                          area: replaceFormatData.canvasArea ?? const AreaModel(),
                          resizeRate: imageSizeConvertRate.value,
                          imageSize: Size(pickImage.image.width.toDouble(), pickImage.image.height.toDouble())),
                    )
                  : const SizedBox.shrink(),

              pickImage != null && currentMode == ReplaceEditMode.canvasSelect
                  ? CanvasAreaSelector(
                      resizeRate: imageSizeConvertRate.value,
                      imageSize: Size(pickImage.image.width.toDouble(), pickImage.image.height.toDouble()),
                      animation: pointerAnimation.animate(pointerAnimationController))
                  : const SizedBox.shrink(),

              currentMode == ReplaceEditMode.canvasSelect || currentMode == ReplaceEditMode.areaDetailSelect
                  ? Positioned(
                      top: h / 2 - 70 / 2,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          ref.read(replaceEditStateProvider.notifier).changeMode(ReplaceEditMode.areaSelect);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(MyColors.orange1), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Align(
                              child: Lottie.asset('assets/lottie/done.json',
                                  addRepaintBoundary: true, repeat: false, width: 50, height: 50)),
                        ),
                      ))
                  : Stack(fit: StackFit.expand, children: [
                      /// replace data list
                      replaceFormatData.replaceDataList.isNotEmpty
                          ? Positioned(
                              bottom: 100, left: 0, child: ReplaceDataListView(list: replaceFormatData.replaceDataList))
                          : const SizedBox(),

                      /// 下のプラスボタン
                      pickImage == null
                          ? Positioned(
                              bottom: 70,
                              right: 55,
                              child: GestureDetector(
                                onTap: () {
                                  handlePickImage();
                                },
                                child: SizedBox(
                                    width: 65,
                                    height: 65,
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
                              bottom: 15,
                              right: 15,
                              child: Row(
                                children: [
                                  currentMode == ReplaceEditMode.areaSelect && isDetailAvailable.value
                                      ? GestureDetector(
                                          onTap: () {
                                            handleAreaDetailMode();
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            margin: const EdgeInsets.only(right: 8),
                                            // padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: const Color(MyColors.orange1), width: 3),
                                            ),
                                            child: Center(
                                              child: Lottie.asset('assets/lottie/detail.json',
                                                  addRepaintBoundary: true, repeat: false, width: 30, height: 30),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  currentMode == ReplaceEditMode.moveSelect
                                      ? GestureDetector(
                                          onTap: () {
                                            handleCancelMove();
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            margin: const EdgeInsets.only(right: 8),
                                            decoration: const BoxDecoration(
                                              color: Color(MyColors.orange1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.clear,
                                              color: Theme.of(context).primaryColor,
                                              size: 30,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(width: 6),
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Center(
                                          child: Lottie.asset('assets/lottie/loop.json',
                                              controller: lottieEffectController,
                                              addRepaintBoundary: true,
                                              width: 120,
                                              height: 120),
                                        ),
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(MyColors.orange1),
                                              border: Border.all(color: const Color(MyColors.orange1), width: 3),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: currentMode == ReplaceEditMode.areaSelect
                                                ? GestureDetector(
                                                    onTap: () {
                                                      if (temporaryArea.value == null) return;
                                                      lottieEffectController.reset();
                                                      lottieEffectController.repeat();
                                                      handleAreaSelect();
                                                    },
                                                    child: Lottie.asset(
                                                        Theme.of(context).primaryColor == const Color(MyColors.light)
                                                            ? 'assets/lottie/area.json'
                                                            : 'assets/lottie/area_dark.json',
                                                        controller: lottieSelectorController,
                                                        addRepaintBoundary: true,
                                                        repeat: false,
                                                        width: 50,
                                                        height: 50))
                                                : GestureDetector(
                                                    onTap: () {
                                                      handleMovedSave();
                                                    },
                                                    child: Lottie.asset(
                                                        Theme.of(context).primaryColor == const Color(MyColors.light)
                                                            ? 'assets/lottie/move.json'
                                                            : 'assets/lottie/move_dark.json',
                                                        controller: lottieSelectorController,
                                                        addRepaintBoundary: true,
                                                        repeat: false,
                                                        width: 50,
                                                        height: 50)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),

                      /// canvas area select button
                      pickImage != null
                          ? Positioned(
                              bottom: 25,
                              left: 25,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(MyColors.orange1), width: 3),
                                  ),
                                  child: GestureDetector(
                                      onTap: () {
                                        handleChangeCanvasSelectMode();
                                      },
                                      child: Lottie.asset('assets/lottie/resize.json',
                                          addRepaintBoundary: true, repeat: false, width: 50, height: 50))),
                            )
                          : const SizedBox.shrink(),

                      /// current mode label
                      pickImage != null
                          ? Positioned(
                              top: 15,
                              right: 12,
                              child: currentMode != ReplaceEditMode.areaSelect
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: const Color(MyColors.orange1), width: 3),
                                      ),
                                      child: Text(
                                        "Move a Selected Area",
                                        style: MyTextStyles.middleOrange,
                                      ))
                                  : Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(MyColors.orange1),
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                                      ),
                                      child: Text(
                                        "Select an Area",
                                        style:
                                            MyTextStyles.middleOrange.copyWith(color: Theme.of(context).primaryColor),
                                      )),
                            )
                          : const SizedBox.shrink(),
                    ]),

              /// detail area select
              currentMode == ReplaceEditMode.areaDetailSelect
                  ? Stack(
                      children: [
                        Positioned(
                            top: 50,
                            left: 50,
                            child: GestureDetector(
                                onPanUpdate: (details) {
                                  handleAreaDetailSelect(details, PointerPosition.topLeft);
                                },
                                child: AreaSelectPointer(pointerAnimation.animate(pointerAnimationController)))),
                        Positioned(
                            top: 50,
                            right: 50,
                            child: GestureDetector(
                                onPanUpdate: (details) {
                                  handleAreaDetailSelect(details, PointerPosition.topRight);
                                },
                                child: AreaSelectPointer(pointerAnimation.animate(pointerAnimationController)))),
                        Positioned(
                            bottom: 70,
                            left: 50,
                            child: GestureDetector(
                                onPanUpdate: (details) {
                                  handleAreaDetailSelect(details, PointerPosition.bottomLeft);
                                },
                                child: AreaSelectPointer(pointerAnimation.animate(pointerAnimationController)))),
                        Positioned(
                            bottom: 70,
                            right: 50,
                            child: GestureDetector(
                                onPanUpdate: (details) {
                                  handleAreaDetailSelect(details, PointerPosition.bottomRight);
                                },
                                child: AreaSelectPointer(pointerAnimation.animate(pointerAnimationController)))),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
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
    paintImage(canvas: canvas, rect: Rect.fromLTWH(0, 0, size.width, size.height), image: image, fit: BoxFit.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CanvasAreaSelector extends HookConsumerWidget {
  final double resizeRate;
  final Size imageSize;
  final Animation animation;
  const CanvasAreaSelector({
    super.key,
    required this.resizeRate,
    required this.imageSize,
    required this.animation,
  });

  double get minSize => 100 * resizeRate;

  bool updateValidate(AreaModel area) {
    if (area.secondPointX > imageSize.width) return false;
    if (area.secondPointY > imageSize.height) return false;
    if (area.firstPointX < 0) return false;
    if (area.firstPointY < 0) return false;
    if ((area.firstPointX - area.secondPointX).abs() < minSize) return false;
    if ((area.firstPointY - area.secondPointY).abs() < minSize) return false;
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replaceFormat = ref.watch(replaceFormatStateProvider);

    return replaceFormat.canvasArea != null
        ? Container(
            color: Colors.transparent,
            width: imageSize.width / resizeRate,
            height: imageSize.height / resizeRate,
            child: Stack(
              children: [
                Positioned(
                  top: replaceFormat.canvasArea!.firstPointY / resizeRate,
                  left: replaceFormat.canvasArea!.firstPointX / resizeRate,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: const Color(MyColors.red1), width: 3),
                    ),
                    width: replaceFormat.canvasArea!.secondPointX / resizeRate -
                        replaceFormat.canvasArea!.firstPointX / resizeRate,
                    height: replaceFormat.canvasArea!.secondPointY / resizeRate -
                        replaceFormat.canvasArea!.firstPointY / resizeRate,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: GestureDetector(
                            onPanUpdate: (detail) {
                              final scale = Platform.isAndroid ? 3.0 : 1.0;
                              final dx = detail.delta.dx * scale;
                              final dy = detail.delta.dy * scale;
                              final updateArea = AreaModel(
                                firstPointX: replaceFormat.canvasArea!.firstPointX + dx * resizeRate,
                                firstPointY: replaceFormat.canvasArea!.firstPointY + dy * resizeRate,
                                secondPointX: replaceFormat.canvasArea!.secondPointX,
                                secondPointY: replaceFormat.canvasArea!.secondPointY,
                              );
                              if (!updateValidate(updateArea)) return;
                              ref.read(replaceFormatStateProvider.notifier).setCanvasArea(updateArea);
                            },
                            child: AreaSelectPointer(animation),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onPanUpdate: (detail) {
                              final scale = Platform.isAndroid ? 3.0 : 1.0;
                              final dx = detail.delta.dx * scale;
                              final dy = detail.delta.dy * scale;
                              final updateArea = AreaModel(
                                firstPointX: replaceFormat.canvasArea!.firstPointX,
                                firstPointY: replaceFormat.canvasArea!.firstPointY + dy * resizeRate,
                                secondPointX: replaceFormat.canvasArea!.secondPointX + dx * resizeRate,
                                secondPointY: replaceFormat.canvasArea!.secondPointY,
                              );
                              if (!updateValidate(updateArea)) return;
                              ref.read(replaceFormatStateProvider.notifier).setCanvasArea(updateArea);
                            },
                            child: AreaSelectPointer(animation),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: GestureDetector(
                            onPanUpdate: (detail) {
                              final scale = Platform.isAndroid ? 3.0 : 1.0;
                              final dx = detail.delta.dx * scale;
                              final dy = detail.delta.dy * scale;
                              final updateArea = AreaModel(
                                firstPointX: replaceFormat.canvasArea!.firstPointX + dx * resizeRate,
                                firstPointY: replaceFormat.canvasArea!.firstPointY,
                                secondPointX: replaceFormat.canvasArea!.secondPointX,
                                secondPointY: replaceFormat.canvasArea!.secondPointY + dy * resizeRate,
                              );
                              if (!updateValidate(updateArea)) return;
                              ref.read(replaceFormatStateProvider.notifier).setCanvasArea(updateArea);
                            },
                            child: AreaSelectPointer(animation),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onPanUpdate: (detail) {
                              final scale = Platform.isAndroid ? 3.0 : 1.0;
                              final dx = detail.delta.dx * scale;
                              final dy = detail.delta.dy * scale;
                              final updateArea = AreaModel(
                                firstPointX: replaceFormat.canvasArea!.firstPointX,
                                firstPointY: replaceFormat.canvasArea!.firstPointY,
                                secondPointX: replaceFormat.canvasArea!.secondPointX + dx * resizeRate,
                                secondPointY: replaceFormat.canvasArea!.secondPointY + dy * resizeRate,
                              );
                              if (!updateValidate(updateArea)) return;
                              ref.read(replaceFormatStateProvider.notifier).setCanvasArea(updateArea);
                            },
                            child: AreaSelectPointer(animation),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
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

    useEffect(() {
      if (thumbnailList.length == 1) {
        slideAnimationController.forward();
      }

      return null;
    }, [thumbnailList]);

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

class AreaSelectPointer extends StatelessWidget {
  final Animation animation;
  const AreaSelectPointer(this.animation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(8),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(MyColors.red1), width: 3),
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
