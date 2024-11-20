import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class Download {
  static Future<String?> downloadAndSaveImage(String url, String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$fileName';

      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final file = File(filePath);
      await file.writeAsBytes(response.data);
      debugPrint('Image downloaded and saved to: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error downloading or saving image: $e');
      return null;
    }
  }
}
