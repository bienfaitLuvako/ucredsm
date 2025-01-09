import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:excel_reader/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Controller {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Controller() {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    storage = FlutterSecureStorage(aOptions: getAndroidOptions());
  }

  Future<void> saveFilePath(String filePath) async {
    await storage.write(key: "file_path", value: filePath);
  }

  Future<String?> getFilePath() async {
    return await storage.read(key: "file_path");
  }

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      String filePath = result.files.single.path!;
      saveFilePath(filePath);
      return filePath;
    } else {
      return null;
    }
  }

  List<User> getUsersFromExcel(String filePath) {
    Uint8List bytes = File(filePath).readAsBytesSync();
    Excel excel = Excel.decodeBytes(bytes);
    Sheet sheet = excel.tables.values.first;

    List<User> users = [];
    for (var row in sheet.rows) {
      users.add(
        User(
          username: row[0] == null ? "-----" : row[0]!.value.toString(),
          password: row[1] == null ? "-----" : row[1]!.value.toString(),
        ),
      );
    }
    return users;
  }
}
