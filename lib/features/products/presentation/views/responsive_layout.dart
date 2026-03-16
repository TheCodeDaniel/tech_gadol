import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_gadol/core/routing/app_routes.dart';
import 'package:tech_gadol/features/products/presentation/views/product_detail_screen.dart';
import 'package:tech_gadol/features/products/presentation/views/product_list_screen.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  int? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 768;

    if (isWide) {
      return _WideLayout(
        selectedProductId: _selectedProductId,
        onProductSelected: (id) {
          setState(() => _selectedProductId = id);
        },
      );
    }

    return _NarrowLayout(
      onProductSelected: (id) {
        context.go(AppRoutes.productById(id));
      },
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final ValueChanged<int> onProductSelected;

  const _NarrowLayout({required this.onProductSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Component Showcase',
            onPressed: () => context.push(AppRoutes.showcase),
          ),
        ],
      ),
      body: ProductListScreen(onProductSelected: onProductSelected),
    );
  }
}

class _WideLayout extends StatelessWidget {
  final int? selectedProductId;
  final ValueChanged<int> onProductSelected;

  const _WideLayout({required this.selectedProductId, required this.onProductSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Component Showcase',
            onPressed: () => context.push(AppRoutes.showcase),
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 380,
            child: ProductListScreen(
              isWideLayout: true,
              selectedProductId: selectedProductId,
              onProductSelected: onProductSelected,
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: theme.dividerColor),
          Expanded(
            child: selectedProductId != null
                ? ProductDetailPane(productId: selectedProductId!)
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          'Select a product to view details',
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
