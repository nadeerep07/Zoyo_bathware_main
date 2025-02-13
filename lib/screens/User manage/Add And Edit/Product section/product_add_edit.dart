import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoyo_bathware/database/CrudOperations/category_db.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/User%20manage/Add%20And%20Edit/Product%20section/product_controllers.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/unique_id.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/widgets/text_form_field.dart';

class ProductAddEdit extends StatefulWidget {
  final bool isEditing;
  final Product? existingProduct;

  const ProductAddEdit({
    super.key,
    required this.isEditing,
    this.existingProduct,
  });

  @override
  State<ProductAddEdit> createState() => _ProductAddEditState();
}

class _ProductAddEditState extends State<ProductAddEdit> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = ProductControllers();
  final ImagePicker _imagePickerHelper = ImagePicker();
  List<XFile> _selectedImages = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    getAllCategories();
    _initializeData();
  }

  void _initializeData() {
    if (widget.isEditing && widget.existingProduct != null) {
      _controllers.populateFromProduct(widget.existingProduct!);
      _selectedCategory = widget.existingProduct!.category;
      _selectedImages = widget.existingProduct!.imagePaths
          .map((path) => XFile(path))
          .toList();
    }
  }

  Future<void> _pickImage() async {
    final pickedImages = await _imagePickerHelper.pickMultiImage();
    setState(() => _selectedImages = pickedImages);
  }

  Future<void> _saveOrUpdateProduct() async {
    if (!_formKey.currentState!.validate() || _selectedImages.isEmpty) {
      if (_selectedImages.isEmpty) {
        _showSnackBar('Please select at least one image');
      }
      return;
    }

    final product = _createProduct();
    await _saveProduct(product);
    _showSnackBar(widget.isEditing ? 'Product updated!' : 'Product added!');
    Navigator.pop(context);
  }

  Product _createProduct() {
    return Product(
      id: widget.isEditing ? widget.existingProduct!.id : generateUniqueId(),
      productCode: _controllers.productCode.text,
      productName: _controllers.productName.text,
      size: _controllers.size.text,
      type: _controllers.type.text,
      quantity: int.parse(_controllers.quantity.text),
      purchaseRate: double.parse(_controllers.purchaseRate.text),
      salesRate: double.parse(_controllers.salesRate.text),
      description: _controllers.description.text,
      category: _selectedCategory!,
      imagePaths: _selectedImages.map((file) => file.path).toList(),
      createdAt: DateTime.now(),
    );
  }

  Future<void> _saveProduct(Product product) async {
    if (widget.isEditing) {
      await updateProduct(product.id!, product);
    } else {
      await addProduct(product);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Product Images"),
                _buildImagePicker(),
                _buildImageGrid(),
                const SizedBox(height: 20),
                _buildSectionTitle("Product Details"),
                _buildProductDetailsSection(),
                const SizedBox(height: 20),
                _buildSectionTitle("Category"),
                _buildCategorySection(),
                const SizedBox(height: 20),
                _buildSectionTitle("Price"),
                _buildPriceSection(),
                const SizedBox(height: 20),
                _buildSectionTitle("Description"),
                _buildDescriptionSection(),
                const SizedBox(height: 20),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: backButton(context),
      title: Text(widget.isEditing ? "Edit Product" : "Add Product"),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: _selectedImages.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_selectedImages.first.path),
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.add_a_photo, color: AppColors.primaryColor),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_selectedImages.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_selectedImages[index].path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(index),
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
    );
  }

  Widget _buildProductDetailsSection() {
    return Column(
      children: [
        CustomTextField(
          controller: _controllers.productCode,
          labelText: 'Product Code',
          prefixIcon: Icons.code,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controllers.productName,
          labelText: 'Product Name',
          prefixIcon: Icons.shopping_bag,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controllers.size,
          labelText: 'Size',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controllers.type,
          labelText: 'Type',
          prefixIcon: Icons.type_specimen,
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return ValueListenableBuilder<List<Category>>(
      valueListenable: categoriesNotifier,
      builder: (context, categories, _) {
        if (categories.isEmpty) return const Text('No categories available');

        return DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: categories
              .map((category) => DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedCategory = value),
          validator: (value) => value == null || value.isEmpty
              ? 'Please select a category'
              : null,
        );
      },
    );
  }

  Widget _buildPriceSection() {
    return Column(
      children: [
        CustomTextField(
          controller: _controllers.quantity,
          labelText: 'Quantity',
          prefixIcon: Icons.production_quantity_limits,
          isNumeric: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controllers.purchaseRate,
          labelText: 'Purchase Rate',
          isNumeric: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _controllers.salesRate,
          labelText: 'Sales Rate',
          isNumeric: true,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return CustomTextField(
      controller: _controllers.description,
      labelText: 'Description',
      prefixIcon: Icons.description,
      maxLines: 3,
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _saveOrUpdateProduct,
        child: Text(
          widget.isEditing ? "Update Product" : "Save Product",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
