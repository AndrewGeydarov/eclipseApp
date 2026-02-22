import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageCloud {
  final Supabase supabase = Supabase.instance;

  Future<void> addImageCloud(XFile image) async{
    try {
      final fileName = path.basename(image.path);
      await supabase.client.storage.from('EclipseBucket').upload(fileName, File(image.path)).then((value) => print("Complited"));
    } catch (e) {
      return;
    }
  }
}