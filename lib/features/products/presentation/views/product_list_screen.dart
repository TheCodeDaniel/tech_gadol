import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/widgets/app_search_bar.dart';
import 'package:tech_gadol/core/widgets/category_chip.dart';
import 'package:tech_gadol/core/widgets/empty_state.dart';
import 'package:tech_gadol/core/widgets/error_state.dart';
import 'package:tech_gadol/core/widgets/product_card.dart';
import 'package:tech_gadol/core/widgets/shimmer_loading.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_events.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_state.dart';

class ProductListScreen extends StatefulWidget {
  final bool isWideLayout;
  final int? selectedProductId;
  final ValueChanged<int>? onProductSelected;

  const ProductListScreen({
    super.key,
    this.isWideLayout = false,
    this.selectedProductId,
    this.onProductSelected,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProductsBloc>();
    if (bloc.state.status == ProductsStatus.initial) {
      bloc.add(const LoadProducts());
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll - 200) {
      context.read<ProductsBloc>().add(const LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ProductsBloc, ProductsState>(
          buildWhen: (prev, curr) => prev.searchQuery != curr.searchQuery,
          builder: (context, state) {
            return AppSearchBar(
              initialQuery: state.searchQuery,
              onChanged: (query) {
                context.read<ProductsBloc>().add(SearchProducts(query));
              },
            );
          },
        ),
        _CategoriesRow(),
        Expanded(child: _ProductsList(
          scrollController: _scrollController,
          isWideLayout: widget.isWideLayout,
          selectedProductId: widget.selectedProductId,
          onProductSelected: widget.onProductSelected,
        )),
      ],
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (prev, curr) =>
          prev.categories != curr.categories ||
          prev.selectedCategory != curr.selectedCategory,
      builder: (context, state) {
        if (state.categories.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return CategoryChip(
                label: category,
                isSelected: state.selectedCategory == category,
                onTap: () {
                  context.read<ProductsBloc>().add(SelectCategory(category));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ProductsList extends StatelessWidget {
  final ScrollController scrollController;
  final bool isWideLayout;
  final int? selectedProductId;
  final ValueChanged<int>? onProductSelected;

  const _ProductsList({
    required this.scrollController,
    required this.isWideLayout,
    this.selectedProductId,
    this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        switch (state.status) {
          case ProductsStatus.initial:
          case ProductsStatus.loading:
            return const ShimmerLoading();
          case ProductsStatus.error:
            return ErrorState(
              message: state.errorMessage ?? 'Something went wrong.',
              onRetry: () {
                context.read<ProductsBloc>().add(const LoadProducts());
              },
            );
          case ProductsStatus.loaded:
            if (state.products.isEmpty) {
              return const EmptyState();
            }
            return ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.products.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final product = state.products[index];
                return ProductCard(
                  product: product,
                  isSelected: isWideLayout && product.id == selectedProductId,
                  onTap: () {
                    if (onProductSelected != null) {
                      onProductSelected!(product.id);
                    }
                  },
                );
              },
            );
        }
      },
    );
  }
}
