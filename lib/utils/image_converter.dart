import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageConverter {
  /// XFile -> ui.Imageの変換とリサイズ
  Future<ui.Image?> convertXFileToImage(XFile file) async {
    final pngBytes = await compute(convertUint, file);
    if (pngBytes == null) return null;
    final coded = await ui.instantiateImageCodec(Uint8List.fromList(pngBytes));
    final ui.Image convertedImage = await coded.getNextFrame().then((value) => value.image);
    return convertedImage;
  }

  /// この処理が重いのでcomputeで別スレッドで実行
  Future<Uint8List?> convertUint(XFile file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return null;
    final pngBytes = img.encodePng(image);
    return pngBytes;
  }

  /// 画像がかなり荒くなるので今回はリサイズしない
  /// resize image
  img.Image resizeImage(img.Image inputImage, double convertWidth) {
    final convertRate = convertWidth / inputImage.width;
    final resizeImage =
        img.copyResize(inputImage, width: convertWidth.toInt(), height: (inputImage.height * convertRate).toInt());
    return resizeImage;
  }
}
