import 'package:file_picker/file_picker.dart';

class FilePickerUtils {
  static Future<FilePickerResult?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'crl',
        'crt',
        'cer',
        'p12',
      ],
    );
    return result;
  }

  Future<FilePickerResult> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    return result!;
  }
}
