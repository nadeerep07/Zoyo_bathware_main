import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/data_operations/cart_db.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/features/billing_section/billing_screen.dart';
import 'package:zoyo_bathware/features/detail_screens/details_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

// Responsive class
class Responsive {
  final BuildContext context;
  final Size size;
  final TextScaler textScaler;

  Responsive(this.context)
      : size = MediaQuery.of(context).size,
        textScaler = MediaQuery.of(context).textScaler;

  double wp(double percent) => size.width * percent / 100;
  double hp(double percent) => size.height * percent / 100;
  double sp(double fontSize) => textScaler.scale(fontSize);
  double get width => size.width;
  double get height => size.height;
}

class ProductCard extends StatefulWidget {
  final Product product;
  final bool isGridView;
  final int? index;

  const ProductCard({
    super.key,
    required this.product,
    required this.isGridView,
    this.index,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _addToCartController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _addToCartAnimation;

  bool _isAdding = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _addToCartController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    _addToCartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _addToCartController, curve: Curves.easeOut),
    );
  }

  void _startEntryAnimation() {
    final delay = (widget.index ?? 0) * 80;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  void _animatedAddToCart() async {
    setState(() => _isAdding = true);
    _addToCartController.forward();

    updateQuantity(widget.product, 1);
    _showFlipkartSnackBar();

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isAdding = false);
      _addToCartController.reverse();
    }
  }

  void _showFlipkartSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.product.productName} added to cart',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  double _calculateDiscount() {
    double originalPrice = widget.product.salesRate * 1.3; // Assume 30% markup for demo
    return ((originalPrice - widget.product.salesRate) / originalPrice * 100);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final bool isOutOfStock = widget.product.quantity == 0;
    final double discountPercent = _calculateDiscount();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.isGridView
              ? _buildFlipkartGridCard(responsive, isOutOfStock, discountPercent)
              : _buildFlipkartListCard(responsive, isOutOfStock, discountPercent),
        ),
      ),
    );
  }

  Widget _buildFlipkartGridCard(Responsive responsive, bool isOutOfStock, double discountPercent) {
    return GestureDetector(
      onTap: () => _navigateToDetails(),
      child: Container(
        margin: EdgeInsets.all(responsive.wp(1)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            _buildFlipkartGridImage(responsive, isOutOfStock, discountPercent),
            // Product Details Section
            _buildFlipkartGridDetails(responsive, isOutOfStock, discountPercent),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipkartGridImage(Responsive responsive, bool isOutOfStock, double discountPercent) {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(responsive.wp(2)),
        child: Stack(
          children: [
            // Product Image
            Center(
              child: widget.product.imagePaths.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(
                        File(widget.product.imagePaths.first),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: responsive.sp(32),
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
            // Wishlist Icon
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => setState(() => _isFavorite = !_isFavorite),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey.shade600,
                    size: 16,
                  ),
                ),
              ),
            ),
            // Discount Badge
            if (discountPercent > 0 && !isOutOfStock)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '${discountPercent.toInt()}% off',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            // Out of Stock Overlay
            if (isOutOfStock)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.sp(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipkartGridDetails(Responsive responsive, bool isOutOfStock, double discountPercent) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(responsive.wp(3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Name (if available)
            Text(
              'house of common', // You can replace this with actual brand from product
              style: TextStyle(
                fontSize: responsive.sp(10),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: responsive.hp(0.3)),
            // Product Name
            Text(
              widget.product.productName,
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Price Section
            Row(
              children: [
                // Discount Badge
                if (discountPercent > 0 && !isOutOfStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      '${discountPercent.toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                // Crossed Price
                if (discountPercent > 0 && !isOutOfStock)
                  Text(
                    '₹${(widget.product.salesRate * 1.3).toInt()}',
                    style: TextStyle(
                      fontSize: responsive.sp(10),
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            SizedBox(height: responsive.hp(0.2)),
            // Current Price
            Text(
              '₹${widget.product.salesRate.toInt()}',
              style: TextStyle(
                fontSize: responsive.sp(14),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: responsive.hp(0.3)),
            // Bank Offer (Flipkart style)
            if (!isOutOfStock)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'WOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.sp(8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.wp(1)),
                  Text(
                    '₹${(widget.product.salesRate * 0.9).toInt()} with Bank offer',
                    style: TextStyle(
                      fontSize: responsive.sp(9),
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            SizedBox(height: responsive.hp(0.5)),
            // F-assured badge (if applicable)
            if (!isOutOfStock)
              Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    size: responsive.sp(10),
                    color: Colors.blue.shade600,
                  ),
                  SizedBox(width: responsive.wp(1)),
                  Text(
                    'Assured',
                    style: TextStyle(
                      fontSize: responsive.sp(9),
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipkartListCard(Responsive responsive, bool isOutOfStock, double discountPercent) {
    return GestureDetector(
      onTap: () => _navigateToDetails(),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: responsive.hp(0.5),
          horizontal: responsive.wp(2),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.wp(3)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              _buildFlipkartListImage(responsive, isOutOfStock, discountPercent),
              SizedBox(width: responsive.wp(3)),
              // Product Details
              Expanded(
                child: _buildFlipkartListDetails(responsive, isOutOfStock, discountPercent),
              ),
              // Wishlist Icon
              GestureDetector(
                onTap: () => setState(() => _isFavorite = !_isFavorite),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey.shade400,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlipkartListImage(Responsive responsive, bool isOutOfStock, double discountPercent) {
    return Container(
      width: responsive.wp(20),
      height: responsive.wp(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: widget.product.imagePaths.isNotEmpty
                ? Image.file(
                    File(widget.product.imagePaths.first),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade100,
                    child: Icon(
                      Icons.image_outlined,
                      size: responsive.sp(24),
                      color: Colors.grey.shade400,
                    ),
                  ),
          ),
          // Discount Badge
          if (discountPercent > 0 && !isOutOfStock)
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  '${discountPercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          // Out of Stock Overlay
          if (isOutOfStock)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Out of\nStock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: responsive.sp(10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFlipkartListDetails(Responsive responsive, bool isOutOfStock, double discountPercent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          widget.product.productName,
          style: TextStyle(
            fontSize: responsive.sp(14),
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: responsive.hp(0.3)),
        // Brand/Code
        Text(
          "Code: ${widget.product.productCode}",
          style: TextStyle(
            fontSize: responsive.sp(11),
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: responsive.hp(0.8)),
        // Price Section
        Row(
          children: [
            // Discount Badge
            if (discountPercent > 0 && !isOutOfStock)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  '${discountPercent.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            // Crossed Price
            if (discountPercent > 0 && !isOutOfStock)
              Text(
                '₹${(widget.product.salesRate * 1.3).toInt()}',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: Colors.grey.shade500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
        SizedBox(height: responsive.hp(0.2)),
        // Current Price
        Text(
          '₹${widget.product.salesRate.toInt()}',
          style: TextStyle(
            fontSize: responsive.sp(16),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: responsive.hp(0.3)),
        // Bank Offer
        if (!isOutOfStock)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  'WOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.sp(8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: responsive.wp(1.5)),
              Text(
                '₹${(widget.product.salesRate * 0.9).toInt()} with Bank offer',
                style: TextStyle(
                  fontSize: responsive.sp(10),
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        SizedBox(height: responsive.hp(0.3)),
        // F-assured badge
        if (!isOutOfStock)
          Row(
            children: [
              Icon(
                Icons.verified_user,
                size: responsive.sp(12),
                color: Colors.blue.shade600,
              ),
              SizedBox(width: responsive.wp(1)),
              Text(
                'Assured',
                style: TextStyle(
                  fontSize: responsive.sp(10),
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        SizedBox(height: responsive.hp(0.5)),
        // Delivery Info
        if (!isOutOfStock)
          Text(
            'Delivery by 12th Sep',
            style: TextStyle(
              fontSize: responsive.sp(10),
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  void _navigateToDetails() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(productCode: widget.product.id!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _addToCartController.dispose();
    super.dispose();
  }
}