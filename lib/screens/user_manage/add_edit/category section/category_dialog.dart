import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/data_perations/category_db.dart';
import 'package:zoyo_bathware/utilitis/image_picker.dart';

class CategoryDialog extends StatefulWidget {
  final Category? category;
  final int? index;

  const CategoryDialog({Key? key, this.category, this.index}) : super(key: key);

  @override
  CategoryDialogState createState() => CategoryDialogState();
}

class CategoryDialogState extends State<CategoryDialog> {
  final TextEditingController nameController = TextEditingController();
  final ImagePickerHelper imagePickerHelper = ImagePickerHelper();
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    nameController.text = widget.category?.name ?? "";
    imagePath = widget.category?.imagePath ?? "";
  }

  Future<void> pickImage(bool fromGallery) async {
    File? pickedImage = await imagePickerHelper.pickImageFromGallery();

    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? "Add Category" : "Edit Category"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Category Name"),
          ),
          const SizedBox(height: 10),
          imagePath.isNotEmpty
              ? Image.file(File(imagePath), width: 100, height: 100)
              : Container(),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => pickImage(true),
            icon: const Icon(Icons.image),
            label: const Text("Gallery"),
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              final newCategory = Category(
                name: nameController.text,
                imagePath: imagePath,
                id: widget.category?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
              );

              if (widget.category == null) {
                addCategory(newCategory);
              } else {
                updateCategory(widget.category!.id, newCategory);
              }

              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
