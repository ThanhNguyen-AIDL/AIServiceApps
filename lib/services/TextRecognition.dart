import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:tesseract_ocr/tesseract_ocr.dart';

// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TextRecognition {
  String textResult;
  dynamic preProcessing;
  Image ImageProcessed;

  // File file;
  File newImage;
  String imagePath;
  PickedFile imageInput;
  String optionImageProcessing;
  String verifyOpenCV;
  String language;

  TextRecognition({this.language, this.imageInput, this.optionImageProcessing});

  Future<void> initialOpenCV() async {
    try {
      verifyOpenCV = await OpenCV.platformVersion;
    } on PlatformException {
      verifyOpenCV = 'Failed to initial OpenCV';
    }
  }

  Future<dynamic> ImageProcessing() async {
    try {
      final File file = File(imageInput.path);
      switch (optionImageProcessing) {
        case 'grayscale':
          preProcessing = await ImgProc.cvtColor(
              await file.readAsBytes(), ImgProc.colorRGB2GRAY);
          break;
        case 'blur':
          preProcessing = await ImgProc.blur(
              await file.readAsBytes(), [45, 45], [20, 30], Core.borderReflect);
          break;
        case 'GaussianBlur':
          preProcessing =
              await ImgProc.gaussianBlur(await file.readAsBytes(), [45, 45], 0);
          break;
        case 'medianBlur':
          preProcessing =
              await ImgProc.medianBlur(await file.readAsBytes(), 45);
          break;
        case 'bilateralFilter':
          preProcessing = await ImgProc.bilateralFilter(
              await file.readAsBytes(), 15, 80, 80, Core.borderConstant);
          break;
        case 'boxFilter':
          preProcessing = await ImgProc.boxFilter(await file.readAsBytes(), 50,
              [45, 45], [-1, -1], true, Core.borderConstant);
          break;
        case 'sqrBoxFilter':
          preProcessing =
              await ImgProc.sqrBoxFilter(await file.readAsBytes(), -1, [1, 1]);
          break;
        case 'filter2D':
          preProcessing =
              await ImgProc.filter2D(await file.readAsBytes(), -1, [2, 2]);
          break;
        case 'dilate':
          preProcessing =
              await ImgProc.dilate(await file.readAsBytes(), [2, 2]);
          break;
        case 'erode':
          preProcessing = await ImgProc.erode(await file.readAsBytes(), [2, 2]);
          break;
        case 'morphologyEx':
          preProcessing = await ImgProc.morphologyEx(
              await file.readAsBytes(), ImgProc.morphTopHat, [5, 5]);
          break;
        case 'pyrUp':
          preProcessing = await ImgProc.pyrUp(
              await file.readAsBytes(), [563 * 2, 375 * 2], Core.borderDefault);
          break;
        case 'pyrDown':
          preProcessing = await ImgProc.pyrDown(await file.readAsBytes(),
              [563 ~/ 2.toInt(), 375 ~/ 2.toInt()], Core.borderDefault);
          break;
        case 'pyrMeanShiftFiltering':
          preProcessing = await ImgProc.pyrMeanShiftFiltering(
              await file.readAsBytes(), 10, 15);
          break;
        case 'threshold':
          preProcessing = await ImgProc.threshold(
              await file.readAsBytes(), 80, 255, ImgProc.threshBinary);
          break;
        case 'adaptiveThreshold':
          preProcessing = await ImgProc.adaptiveThreshold(
              await file.readAsBytes(),
              125,
              ImgProc.adaptiveThreshMeanC,
              ImgProc.threshBinary,
              11,
              12);
          break;
        case 'copyMakeBorder':
          preProcessing = await ImgProc.copyMakeBorder(
              await file.readAsBytes(), 20, 20, 20, 20, Core.borderConstant);
          break;
        case 'sobel':
          preProcessing =
              await ImgProc.sobel(await file.readAsBytes(), -1, 1, 1);
          break;
        case 'scharr':
          preProcessing = await ImgProc.scharr(
              await file.readAsBytes(), ImgProc.cvSCHARR, 0, 1);
          break;
        case 'laplacian':
          preProcessing = await ImgProc.laplacian(await file.readAsBytes(), 10);
          break;
        case 'distanceTransform':
          preProcessing = await ImgProc.threshold(
              await file.readAsBytes(), 80, 255, ImgProc.threshBinary);
          preProcessing = await ImgProc.distanceTransform(
              await preProcessing, ImgProc.distC, 3);
          break;
        case 'resize':
          preProcessing = await ImgProc.resize(
              await file.readAsBytes(), [500, 500], 0, 0, ImgProc.interArea);
          break;
        case 'applyColorMap':
          preProcessing = await ImgProc.applyColorMap(
              await file.readAsBytes(), ImgProc.colorMapHot);
          break;
        case 'houghLines':
          preProcessing =
              await ImgProc.canny(await file.readAsBytes(), 50, 200);
          preProcessing = await ImgProc.houghLines(await preProcessing,
              threshold: 300, lineColor: "#ff0000");
          break;
        case 'houghLinesProbabilistic':
          preProcessing =
              await ImgProc.canny(await file.readAsBytes(), 50, 200);
          preProcessing = await ImgProc.houghLinesProbabilistic(
              await preProcessing,
              threshold: 50,
              minLineLength: 50,
              maxLineGap: 10,
              lineColor: "#ff0000");
          break;
        case 'houghCircles':
          preProcessing = await ImgProc.cvtColor(await file.readAsBytes(), 6);
          preProcessing = await ImgProc.houghCircles(await preProcessing,
              method: 3,
              dp: 2.1,
              minDist: 0.1,
              param1: 150,
              param2: 100,
              minRadius: 0,
              maxRadius: 0);
          break;
        case 'warpPerspectiveTransform':
          // 4 points are reppreProcessingented as:
          // P1         P2
          //
          //
          // P3         P4
          // and stored in a linear array as:
          // sourcePoints = [P1.x, P1.y, P2.x, P2.y, P3.x, P3.y, P4.x, P4.y]
          preProcessing = await ImgProc.warpPerspectiveTransform(
              await file.readAsBytes(),
              sourcePoints: [113, 137, 260, 137, 138, 379, 271, 340],
              destinationPoints: [0, 0, 612, 0, 0, 459, 612, 459],
              outputSize: [612, 459]);
          break;
        case 'grabCut':
          preProcessing = await ImgProc.grabCut(await file.readAsBytes(),
              px: 0, py: 0, qx: 400, qy: 400, itercount: 1);
          break;
        default:
          print("No function selected");
          break;
      }
      Directory tempDir = await getApplicationDocumentsDirectory();
      final String tempPath = tempDir.path + '/tempImage';
      File('$tempPath').writeAsBytes(preProcessing);
      imagePath  = tempPath;
    } on PlatformException {
      verifyOpenCV = 'can not preprocessing image';
    }
  }

  Future<String> extractText() async {
    print('start extracting');
    textResult =
        await FlutterTesseractOcr.extractText(imagePath, language: language,  args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
        });
  }
}
