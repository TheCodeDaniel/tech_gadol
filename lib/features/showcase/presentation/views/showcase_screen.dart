import 'package:flutter/material.dart';
import 'package:tech_gadol/core/theme/dark_theme.dart';
import 'package:tech_gadol/core/theme/light_theme.dart';
import 'package:tech_gadol/core/widgets/app_search_bar.dart';
import 'package:tech_gadol/core/widgets/category_chip.dart';
import 'package:tech_gadol/core/widgets/empty_state.dart';
import 'package:tech_gadol/core/widgets/error_state.dart';
import 'package:tech_gadol/core/widgets/price_tag.dart';
import 'package:tech_gadol/core/widgets/product_card.dart';
import 'package:tech_gadol/core/widgets/rating_bar.dart';
import 'package:tech_gadol/core/widgets/shimmer_loading.dart';
import 'package:tech_gadol/features/products/data/models/product_model.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDark ? DarkTheme.themeData : LightTheme.themeData,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Component Showcase'),
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_isDark ? Icons.dark_mode : Icons.light_mode, size: 20, color: theme.colorScheme.onSurface),
                    Switch(value: _isDark, onChanged: (v) => setState(() => _isDark = v)),
                  ],
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionHeader('SearchBar'),
                AppSearchBar(onChanged: (_) {}),
                const SizedBox(height: 24),

                _SectionHeader('CategoryChip'),
                _CategoryChipShowcase(),
                const SizedBox(height: 24),

                _SectionHeader('ProductCard'),
                ProductCard(product: _sampleProduct, onTap: () {}, enableHero: false),
                const SizedBox(height: 8),
                ProductCard(product: _sampleProduct, onTap: () {}, isSelected: true, enableHero: false),
                const SizedBox(height: 8),
                ProductCard(product: _outOfStockProduct, onTap: () {}, enableHero: false),
                const SizedBox(height: 8),
                ProductCard(product: _noPriceProduct, onTap: () {}, enableHero: false),
                const SizedBox(height: 24),

                _SectionHeader('PriceTag'),
                _PriceTagShowcase(),
                const SizedBox(height: 24),

                _SectionHeader('RatingBar'),
                _RatingBarShowcase(),
                const SizedBox(height: 24),

                _SectionHeader('ShimmerLoading'),
                const SizedBox(height: 200, child: ShimmerLoading(itemCount: 2)),
                const SizedBox(height: 24),

                _SectionHeader('ErrorState'),
                ErrorState(onRetry: () {}),
                const SizedBox(height: 24),

                _SectionHeader('EmptyState'),
                const EmptyState(),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class _CategoryChipShowcase extends StatefulWidget {
  @override
  State<_CategoryChipShowcase> createState() => _CategoryChipShowcaseState();
}

class _CategoryChipShowcaseState extends State<_CategoryChipShowcase> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final categories = ['electronics', 'smart-phones', 'laptops', 'fragrances'];
    return Wrap(
      spacing: 8,
      children: categories.map((c) {
        return CategoryChip(
          label: c,
          isSelected: _selected == c,
          onTap: () => setState(() => _selected = _selected == c ? null : c),
        );
      }).toList(),
    );
  }
}

class _PriceTagShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('With discount:'),
        const SizedBox(height: 4),
        PriceTag(product: _sampleProduct),
        const SizedBox(height: 12),
        const Text('With discount (large):'),
        const SizedBox(height: 4),
        PriceTag(product: _sampleProduct, large: true),
        const SizedBox(height: 12),
        const Text('No discount:'),
        const SizedBox(height: 4),
        PriceTag(product: _noDiscountProduct),
        const SizedBox(height: 12),
        const Text('Price unavailable:'),
        const SizedBox(height: 4),
        PriceTag(product: _noPriceProduct),
      ],
    );
  }
}

class _RatingBarShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar(rating: 5.0),
        SizedBox(height: 8),
        RatingBar(rating: 3.5),
        SizedBox(height: 8),
        RatingBar(rating: 1.0),
        SizedBox(height: 8),
        RatingBar(rating: 0.0),
        SizedBox(height: 8),
        RatingBar(rating: 4.2, size: 24, showLabel: false),
      ],
    );
  }
}

// Sample data for showcase
const _sampleProduct = ProductModel(
  id: 1,
  title: 'iPhone 15 Pro Max',
  description: 'The latest iPhone with A17 Pro chip.',
  category: 'smartphones',
  price: 1199.99,
  discountPercentage: 15.0,
  rating: 4.7,
  stock: 42,
  brand: 'Apple',
  thumbnail: 'https://cdn.dummyjson.com/products/images/smartphones/iPhone%206/thumbnail.png',
  images: [],
  availabilityStatus: 'In Stock',
  warrantyInformation: '1 year',
  shippingInformation: 'Ships in 1 week',
  returnPolicy: '30 day return',
  tags: ['phone'],
);

const _outOfStockProduct = ProductModel(
  id: 2,
  title: 'Galaxy S24 Ultra',
  description: 'Samsung flagship.',
  category: 'smartphones',
  price: 999.99,
  discountPercentage: 0,
  rating: 4.3,
  stock: 0,
  brand: 'Samsung',
  thumbnail: 'https://cdn.dummyjson.com/products/images/smartphones/Samsung%20Galaxy%20S24/thumbnail.png',
  images: [],
  availabilityStatus: 'Out of Stock',
  warrantyInformation: '',
  shippingInformation: '',
  returnPolicy: '',
  tags: [],
);

const _noDiscountProduct = ProductModel(
  id: 3,
  title: 'MacBook Air M3',
  description: 'Lightweight laptop.',
  category: 'laptops',
  price: 1099.00,
  discountPercentage: 0,
  rating: 4.9,
  stock: 100,
  brand: 'Apple',
  thumbnail:
      'https://cdn.dummyjson.com/products/images/laptops/Apple%20MacBook%20Pro%2014%20Inch%20Space%20Black/thumbnail.png',
  images: [],
  availabilityStatus: 'In Stock',
  warrantyInformation: '',
  shippingInformation: '',
  returnPolicy: '',
  tags: [],
);

const _noPriceProduct = ProductModel(
  id: 4,
  title: 'Mystery Product',
  description: 'Price not available.',
  category: 'other',
  price: -1,
  discountPercentage: 0,
  rating: 2.0,
  stock: 5,
  brand: 'Unknown brand',
  thumbnail: '',
  images: [],
  availabilityStatus: 'Limited',
  warrantyInformation: '',
  shippingInformation: '',
  returnPolicy: '',
  tags: [],
);
