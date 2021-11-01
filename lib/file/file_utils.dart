import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';

/// Created by @RealCradle on 2021/7/22
///

class FileUtils {
  static Directory? appFileDirectory;

  static Future<Directory> getFileDirectory() async {
    if (appFileDirectory == null) {
      appFileDirectory = await (Platform.isIOS ? getApplicationDocumentsDirectory() : getApplicationSupportDirectory());
    }
    return appFileDirectory!;
  }

  static Future<Directory> getCacheDir({bool recursive = true}) async {
    return getTemporaryDirectory().then((dir) => Directory("${dir.path}").create(recursive: recursive));
  }

  static File joinPathSegments(List<String> paths) {
    return File(path.joinAll(paths));
  }

  static File createFile(Directory directory, name) {
    return File(path.join(directory.path, name));
  }

  static Future<File> downloadFile(String url, File file) async {
    final data = await http.get(Uri.parse(url));
    return await file.writeAsBytes(data.bodyBytes); // 需要使用与图片格式对应的encode方法
  }

  static Future<bool> checkFileExists(File file) async {
    return file.exists();
  }

  static Future<File> copyFile(File srcFile, File dstFile, {bool deleteSrc = false}) async {
    if (!dstFile.existsSync()) {
      dstFile.createSync();
    }
    srcFile.copySync(dstFile.path);
    if (deleteSrc) {
      srcFile.deleteSync();
    }
    return dstFile;
  }

  static void deleteFile(File file, {bool recursive: false}) {
    file.deleteSync(recursive: recursive);
  }

  static Future<bool> unzipFile(File zipFile, String unzipPath) async {
    try {
      List<int> bytes = zipFile.readAsBytesSync();
      Archive archive = ZipDecoder().decodeBytes(bytes);
      for (ArchiveFile file in archive) {
        if (file.isFile) {
          List<int> data = file.content;
          File(unzipPath + "/" + file.name)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(unzipPath + "/" + file.name)
            ..create(recursive: true);
        }
      }
      print("unzip success");
      return true;
    } catch (error) {
      print("unzip error=${error}");
      return false;
    }
  }

  static Future<bool> unzipTo(Uint8List data, String unzipPath, {String? password}) async {
    try {
      Archive archive = ZipDecoder().decodeBytes(data, password: password);
      for (ArchiveFile file in archive) {
        if (file.isFile) {
          List<int> data = file.content;
          File(unzipPath + "/" + file.name)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(unzipPath + "/" + file.name)
            ..create(recursive: true);
        }
      }
      print("unzip success");
      return true;
    } catch (error) {
      print("unzip error:$error");
    }
    return false;
  }

  static void zipFile(String zipName, String zipPath) {
    var encoder = ZipFileEncoder();
    encoder.zipDirectory(Directory(zipPath));
    encoder.create(zipName);
    encoder.addDirectory(Directory(zipPath));
    encoder.addFile(File(zipName));
    encoder.close();
  }

  static String getFileName(File file, {bool withoutExtension = false}) {
    if (!file.existsSync()) {
      return "";
    }
    if (withoutExtension) {
      return path.basenameWithoutExtension(file.path);
    } else {
      return path.basename(file.path);
    }
  }
}
