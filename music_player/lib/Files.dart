import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class Files {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/usersAndPass.txt');
  }

  Future<File> appendToFile (String write) async {
    final file = await _localFile;
    return file.writeAsString(write,
        mode: FileMode.append
    );
  }

  Future<File> writeToFile (String write) async {
      final file = await _localFile;
    return file.writeAsString(write,
        mode: FileMode.write
    );
  }

  Future<String> readFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("Error! $e");
      return "Error!";
    }
  }
  Future<File> _write(String write) {
    return writeToFile(write);
  }
}