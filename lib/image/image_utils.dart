/// Created by @RealCradle on 2021/9/28

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as Graphics show instantiateImageCodec, Codec, Image, TextStyle;

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_utils/uri/uri_utils.dart';
import 'package:http/http.dart' as http;

class ImageUtils {
  // static ImagePicker? _imagePicker;

  static Future<Graphics.Image> loadImageFromFile(String path, {Size? size}) async {
    final data = await File(path).readAsBytes();
    Graphics.Codec codec = await Graphics.instantiateImageCodec(data, targetWidth: size?.width.toInt(), targetHeight: size?.height.toInt());
    FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  static Future<Graphics.Image> loadImageFromAsset(String path, {Size? size}) async {
    final data = await rootBundle.load(path);
    Graphics.Codec codec =
        await Graphics.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: size?.width.toInt(), targetHeight: size?.height.toInt());
    FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  static Future<Graphics.Image> loadImageFromHttp(String url, {Size? size}) async {
    Graphics.Codec codec = await http
        .get(Uri.parse(url))
        .then((data) => Graphics.instantiateImageCodec(data.bodyBytes, targetWidth: size?.width.toInt(), targetHeight: size?.height.toInt()));
    FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  static Future<Graphics.Image> loadImage(String uri, {Size? size}) async {
    if (UriUtils.isAssetsPath(uri)) {
      return await loadImageFromAsset(uri, size: size);
    } else if (UriUtils.isNetworkPath(uri)) {
      return await loadImageFromHttp(uri, size: size);
    } else if (UriUtils.isFilePath(uri)) {
      return await loadImageFromFile(uri, size: size);
    } else {
      throw ArgumentError("load image error! invalid uri:$uri");
    }
  }
}
