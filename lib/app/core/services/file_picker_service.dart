import 'dart:async';
import 'dart:io' as IO;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

@Injectable()
class FilePickerService extends Disposable {
  final ImagePicker _picker = ImagePicker();

  Future<List<IO.File>> openFileStorage() async {
    FilePickerResult _filePickerResult;
    try {
      _filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (_filePickerResult.files.isEmpty) return null;
      return _filePickerResult.files.map((e) => IO.File(e.path)).toList();
    } on PlatformException catch (e) {
      print("Erro ao obter arquivo: $e");
      return null;
    }
  }

  Future<IO.File> openCamera() async {
    PickedFile _pickedFile;
    try {
      _pickedFile = await _picker.getImage(source: ImageSource.camera, imageQuality: 100);
      if (_pickedFile?.path == null) return null;
      return IO.File(_pickedFile.path);
    } on PlatformException catch (e) {
      print("Erro ao obter arquivo da galeria: $e");
      return null;
    }
  }

  Future<IO.File> openGallery() async {
    PickedFile _pickedFile;
    try {
      _pickedFile = await _picker.getImage(source: ImageSource.gallery, imageQuality: 100);
      if (_pickedFile?.path == null) return null;
      return IO.File(_pickedFile.path);
    } on PlatformException catch (e) {
      print("Erro ao obter arquivo da galeria: $e");
      return null;
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
