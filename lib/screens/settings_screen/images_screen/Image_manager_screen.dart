import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageManagerScreen extends StatefulWidget {
  const ImageManagerScreen({super.key});

  @override
  State<ImageManagerScreen> createState() => _ImageManagerScreenState();
}

class _ImageManagerScreenState extends State<ImageManagerScreen> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final box = await Hive.openBox<String>('carousel_images');
    setState(() {
      _imagePaths = box.values.toList();
    });
  }

  Future<void> _addImage() async {
    if (_imagePaths.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only add up to 3 images.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final String savedImagePath = '${appDir.path}/$fileName.png';
      final File savedImage = File(image.path);
      await savedImage.copy(savedImagePath);

      final box = await Hive.openBox<String>('carousel_images');
      await box.add(savedImagePath);

      setState(() {
        _imagePaths.add(savedImagePath);
      });
    }
  }

  Future<void> _removeImage(int index) async {
    final box = await Hive.openBox<String>('carousel_images');
    await box.deleteAt(index); // Remove the image from Hive
    setState(() {
      _imagePaths.removeAt(index); // Remove the image from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Home Images')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add Image to Carousel'),
            leading: const Icon(Icons.add_photo_alternate),
            onTap: _addImage,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.file(
                    File(_imagePaths[index]),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text('Image ${index + 1}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeImage(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
