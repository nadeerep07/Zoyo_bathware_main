import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoyo_bathware/database/data_operations/category_db.dart';
import 'package:zoyo_bathware/database/data_operations/product_db.dart';
import 'package:zoyo_bathware/database/data_operations/purchase_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/custom_classes/product_controllers.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/unique_id.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/back_botton.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/category_section.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/description.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/image_picker.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/price_section.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/product_details_section.dart';
import 'package:zoyo_bathware/utilitis/custom_widgets/save_button.dart';

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
        _showCustomSnackBar('Please select at least one image',
            backgroundColor: Colors.red); // Custom SnackBar for error
      }
      return;
    }

    final product = _createProduct();
    await _saveProduct(product);

    _showCustomSnackBar(
      widget.isEditing ? 'Product updated!' : 'Product added!',
      backgroundColor: Colors.green, // Custom SnackBar for success
    );
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
      await addPurchase(product, int.parse(_controllers.quantity.text));
    }
  }

  void _showCustomSnackBar(String message,
      {Color backgroundColor = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
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
                  categories: categoriesNotifier.value,
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
