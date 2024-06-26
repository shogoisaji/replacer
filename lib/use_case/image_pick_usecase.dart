import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replacer/states/image_pick_state.dart';
import 'package:image/image.dart' as img;
import 'package:replacer/states/loading_state.dart';
import 'package:replacer/utils/image_converter.dart';

final imagePickUseCaseProvider = Provider((ref) => ImagePickUseCase(ref: ref));

class ImagePickUseCase {
  final Ref ref;
  ImagePickUseCase({required this.ref});

  Future<Size?> pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      ref.read(loadingStateProvider.notifier).show();
      final ui.Image? convertedImage = await ImageConverter().convertXFileToImage(image);
      if (convertedImage == null) return null;
      ref.read(pickImageStateProvider.notifier).setPickImage(convertedImage);
      ref.read(loadingStateProvider.notifier).hide();
      return Size(convertedImage.width.toDouble(), convertedImage.height.toDouble());
    } on PlatformException catch (_) {
      return null;
    }
  }

  /// ui.Imageから画像サイズが取れるので今回は使わないかも
  Future<Size?> getImageSize(XFile file) async {
    Uint8List? imageData = await file.readAsBytes();
    img.Image? image = img.decodeImage(imageData);
    if (image != null) {
      int width = image.width;
      int height = image.height;
      return Size(width.toDouble(), height.toDouble());
    } else {}
    return null;
  }
}
