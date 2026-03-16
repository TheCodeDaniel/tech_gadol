import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/widgets/cached_image.dart';
import 'package:tech_gadol/core/widgets/price_tag.dart';
import 'package:tech_gadol/core/widgets/rating_bar.dart';
import 'package:tech_gadol/features/products/data/models/product_model.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_events.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(SelectProduct(widget.productId));
  }

  @override
  void didUpdateWidget(ProductDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      context.read<ProductsBloc>().add(SelectProduct(widget.productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (prev, curr) => prev.selectedProduct != curr.selectedProduct,
      builder: (context, state) {
        final product = state.selectedProduct;
        if (product == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(title: Text(product.title)),
          body: _DetailBody(product: product),
        );
      },
    );
  }
}

class ProductDetailPane extends StatefulWidget {
  final int productId;

  const ProductDetailPane({super.key, required this.productId});

  @override
  State<ProductDetailPane> createState() => _ProductDetailPaneState();
}

class _ProductDetailPaneState extends State<ProductDetailPane> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(SelectProduct(widget.productId));
  }

  @override
  void didUpdateWidget(ProductDetailPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      context.read<ProductsBloc>().add(SelectProduct(widget.productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (prev, curr) => prev.selectedProduct != curr.selectedProduct,
      builder: (context, state) {
        final product = state.selectedProduct;
        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _DetailBody(product: product);
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final ProductModel product;

  const _DetailBody({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image gallery
          SizedBox(
            height: 300,
            child: product.images.isNotEmpty
                ? PageView.builder(
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      return CachedImage(
                        imageUrl: product.images[index],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.contain,
                      );
                    },
                  )
                : CachedImage(imageUrl: product.thumbnail, width: double.infinity, height: 300, fit: BoxFit.contain),
          ),
          // Image page indicator
          if (product.images.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.swipe, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${product.images.length} images', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(product.title, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),
                // Brand
                Text(
                  product.brand,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                // Price
                PriceTag(product: product, large: true),
                const SizedBox(height: 16),
                // Rating and stock
                Row(
                  children: [
                    RatingBar(rating: product.rating, size: 20),
                    const SizedBox(width: 16),
                    _StockBadge(product: product),
                  ],
                ),
                const SizedBox(height: 16),
                // Category
                Chip(label: Text(product.category), avatar: const Icon(Icons.category, size: 16)),
                const SizedBox(height: 16),
                // Description
                Text('Description', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(product.description, style: theme.textTheme.bodyMedium),
                // Additional info
                if (product.warrantyInformation.isNotEmpty ||
                    product.shippingInformation.isNotEmpty ||
                    product.returnPolicy.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  if (product.warrantyInformation.isNotEmpty)
                    _InfoRow(icon: Icons.verified_user_outlined, label: product.warrantyInformation),
                  if (product.shippingInformation.isNotEmpty)
                    _InfoRow(icon: Icons.local_shipping_outlined, label: product.shippingInformation),
                  if (product.returnPolicy.isNotEmpty)
                    _InfoRow(icon: Icons.assignment_return_outlined, label: product.returnPolicy),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final ProductModel product;

  const _StockBadge({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = product.isInStock ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        product.isInStock ? 'In Stock (${product.stock})' : 'Out of Stock',
        style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
