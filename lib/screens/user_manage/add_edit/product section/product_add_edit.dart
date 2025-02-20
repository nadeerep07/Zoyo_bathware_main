import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoyo_bathware/database/data_perations/category_db.dart';
import 'package:zoyo_bathware/database/data_perations/product_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/user_manage/add_edit/product section/product_controllers.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/unique_id.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/widgets/category_section.dart';
import 'package:zoyo_bathware/utilitis/widgets/description.dart';
import 'package:zoyo_bathware/utilitis/widgets/image_picker.dart';
import 'package:zoyo_bathware/utilitis/widgets/price_section.dart';
import 'package:zoyo_bathware/utilitis/widgets/product_details_section.dart';
import 'package:zoyo_bathware/utilitis/widgets/save_button.dart';

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
      purchaseDate: [DateTime.now()],
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
                ImagePickerSection(
                  selectedImages: _selectedImages,
                  onPickImage: _pickImage,
                  onRemoveImage: _removeImage,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle("Product Details"),
                ProductDetailsSection(controllers: _controllers),
                const SizedBox(height: 20),
                _buildSectionTitle("Category"),
                CategorySection(
                  categories: categoriesNotifier
                      .value, // Adjust this based on your provider's structure.
                  selectedCategory: _selectedCategory,
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle("Price"),
                PriceSection(controllers: _controllers),
                const SizedBox(height: 20),
                _buildSectionTitle("Description"),
                DescriptionSection(controllers: _controllers),
                const SizedBox(height: 20),
                SaveButton(
                  onPressed: _saveOrUpdateProduct,
                  label: widget.isEditing ? "Update Product" : "Save Product",
                ),
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
}
