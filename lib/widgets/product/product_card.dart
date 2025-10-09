import 'package:flutter/material.dart';
import 'package:zoyo_bathware/core/models/product_model.dart';
import 'package:zoyo_bathware/widgets/product/grid_product_card.dart';
import 'package:zoyo_bathware/widgets/product/list_product_card.dart';
import 'package:zoyo_bathware/widgets/responsive.dart';
import 'package:zoyo_bathware/features/detail_screens/view/screens/details_screen.dart';

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

class _ProductCardState extends State<ProductCard> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startEntryAnimation();
  }

  void _initAnimations() {
    _fadeController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
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

  double _calculateDiscount() {
    double originalPrice = widget.product.salesRate * 1.3;
    return ((originalPrice - widget.product.salesRate) / originalPrice * 100);
  }

  void _toggleFavorite() => setState(() => _isFavorite = !_isFavorite);

  void _navigateToDetails() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailScreen(productCode: widget.product.id!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOutCubic));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discount = _calculateDiscount();
    final isOutOfStock = widget.product.quantity == 0;
    final responsive = Responsive(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.isGridView
              ? GridProductCard(
                  product: widget.product,
                  responsive: responsive,
                  discount: discount,
                  isOutOfStock: isOutOfStock,
                  isFavorite: _isFavorite,
                  onFavoriteToggle: _toggleFavorite,
                  onTap: _navigateToDetails,
                )
              : ListProductCard(
                  product: widget.product,
                  responsive: responsive,
                  discount: discount,
                  isOutOfStock: isOutOfStock,
                  isFavorite: _isFavorite,
                  onFavoriteToggle: _toggleFavorite,
                  onTap: _navigateToDetails,
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
