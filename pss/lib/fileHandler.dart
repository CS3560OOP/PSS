import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class FileHandler {
  //Properties
  String _fileName;

  //Find the local path
  Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  //Create a reference to the file location
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/' + _fileName);
  }

  //Write data to the file
  Future<File> writeData(String data, String fileName) async {
    _fileName = fileName;

    final file = await _localFile;

    return file.writeAsString(data);
  }

  //Read the data from the file
  Future<String> readData(String fileName) async {
    _fileName = fileName;
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "0";
    }
  }
}


