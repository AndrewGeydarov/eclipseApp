import 'dart:io';
import 'package:eclipse_app/database/storage/storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomProfilePage extends StatefulWidget {
  const BottomProfilePage({super.key});

  @override
  State<BottomProfilePage> createState() => _BottomProfilePageState();
}

class _BottomProfilePageState extends State<BottomProfilePage> {
  XFile? _file;
  // ignore: unused_field
  File? _selectFile;
  StorageCloud storageCloud = StorageCloud();
  Supabase supabase = Supabase.instance;
  String? url;
  
  Future<void> selectedImageGallery() async {
    final returnImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _selectFile = File(returnImage!.path);
      _file = returnImage;
    });
  }

  uploadImage() async {
    await storageCloud.addImageCloud(_file!);
  }

  downloadUrl() async {
    try {
      final fileName = path.basename(_file!.path);
      final image = supabase.client.storage
          .from('EclipseBucket')
          .getPublicUrl(fileName);
      setState(() {
        url = image;
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
