import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:replacer/models/area_model/area_model.dart';
import 'package:replacer/states/capture_screen_key_state.dart';
import 'package:replacer/states/capture_screen_state.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:replacer/states/loading_state.dart';
import 'package:replacer/states/replace_edit_page_state.dart';
import 'package:replacer/states/replace_edit_state.dart';
import 'package:replacer/theme/color_theme.dart';
import 'package:replacer/theme/text_style.dart';
import 'package:replacer/use_case/back_home_usecase.dart';
import 'package:replacer/use_case/capture_area_screen_usecase.dart';
import 'package:replacer/use_case/image_pick_usecase.dart';
import 'package:replacer/widgets/area_select_widget.dart';
import 'package:replacer/widgets/capture_widget.dart';

class ReplaceEditPage extends HookConsumerWidget {
  const ReplaceEditPage({super.key});

  static final GlobalKey _clipKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temporaryFirstPoint = useState<Offset?>(null);
    final movePosition = useState<Offset>(Offset.zero);
    final temporaryArea = useState<AreaModel?>(null);
    final selectedArea = useState<AreaModel?>(null);
    final w = MediaQuery.sizeOf(context).width;
    final lottieController = useAnimationController(duration: const Duration(milliseconds: 2000), initialValue: 1);
    final currentMode = ref.watch(replaceEditStateProvider);
    final pickImage = ref.watch(pickImageStateProvider);
    final captureImage = ref.watch(captureScreenStateProvider);
    final isPicked = ref.watch(replaceEditPageStateProvider).isPicked;

    void setGlobalKey() {
      ref.watch(captureScreenKeyStateProvider.notifier).setKey(_clipKey);
    }

    useEffect(() {
      Future.delayed(Duration.zero, () {
        setGlobalKey();
      });
      return;
    }, [currentMode]);

    final Offset imageArea =
        pickImage != null ? Offset(w, pickImage.image.height / pickImage.image.width * w) : Offset.zero;

    void resetArea() {
      temporaryFirstPoint.value = null;
      temporaryArea.value = null;
      selectedArea.value = null;
      movePosition.value = Offset.zero;
      ref.read(replaceEditPageStateProvider.notifier).clear();
      ref.read(captureScreenStateProvider.notifier).clear();
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
      await ref.read(imagePickUseCaseProvider).pickImage();
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
        resetArea();
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

        /// TODO:delayが必要な理由を解明する
        Future.delayed(const Duration(milliseconds: 300), () {
          ref.read(captureAreaScreenUseCaseProvider);
        });
      }
    }

    void backHome(BuildContext context) {
      ref.read(backHomeUseCase).backHome(context);
    }

    void showLoading() {
      Future.delayed(const Duration(seconds: 0), () {
        ref.read(loadingStateProvider.notifier).show();
      });
      Future.delayed(const Duration(seconds: 1), () {
        ref.read(loadingStateProvider.notifier).hide();
      });
    }

    // void setPageWidth() {
    //   final ReplaceEditPageStateModel model = ReplaceEditPageStateModel(width: w);
    //   Future.delayed(Duration.zero, () {
    //     ref.read(replaceEditPageStateProvider.notifier).setPageState(model);
    //   });
    // }

    // useEffect(() {
    //   setPageWidth();
    //   return null;
    // }, [w]);
    // useEffect(() {
    //   showLoading();
    //   return null;
    // }, []);
    // useEffect(() {
    //   if (isPicked) {
    //     showLoading();
    //   }
    //   return null;
    // }, [isPicked]);

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
                      child: CustomPaint(
                        painter: ImagePainter(pickImage.image),
                        // size: Size(pickImage.image.width.toDouble(), pickImage.image.height.toDouble()),
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
                // decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2) //確認用,
                //     ),
              ),
            ),

            /// selected area
            selectedArea.value != null
                ? CaptureWidget(
                    clipKey: _clipKey,
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
                  ],
                ),
              ),
            ),

            //// キャプチャした画像 move select mode
            captureImage != null
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
                      child: SizedBox(
                        width: (temporaryArea.value!.secondPointX - temporaryArea.value!.firstPointX).abs(),
                        height: (temporaryArea.value!.secondPointY - temporaryArea.value!.firstPointY).abs(),
                        child: CustomPaint(
                          painter: ImagePainter(captureImage),
                          size: Size(captureImage.width.toDouble() * w / (pickImage!.image.width),
                              captureImage.height.toDouble() * w / (pickImage.image.width)),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),

            // 確認用
            captureImage != null
                ? Align(
                    alignment: Alignment(0, 0.6),
                    child: Container(
                      color: Colors.blue.withOpacity(0.2),
                      width: captureImage.width.toDouble() * w / (pickImage!.image.width),
                      height: captureImage.height.toDouble() * w / (pickImage.image.width),
                      child: CustomPaint(
                        painter: ImagePainter(captureImage),
                      ),
                    ),
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
    print('paint$size');
    paintImage(canvas: canvas, rect: Rect.fromLTWH(0, 0, size.width, size.height), image: image);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
