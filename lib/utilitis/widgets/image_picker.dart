import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class ImagePickerSection extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function() onPickImage;
  final Function(int) onRemoveImage;

  const ImagePickerSection({
    Key? key,
    required this.selectedImages,
    required this.onPickImage,
    required this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPickImage,
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: selectedImages.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(selectedImages.first.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.add_a_photo, color: AppColors.primaryColor),
          ),
        ),
        if (selectedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: selectedImages.length,
              itemBuilder: (context, index) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(selectedImages[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => onRemoveImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
