import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/widgets/empty_state.dart';
import 'package:tech_gadol/core/widgets/error_state.dart';
import 'package:tech_gadol/core/widgets/product_card.dart';
import 'package:tech_gadol/core/widgets/shimmer_loading.dart';
import 'package:tech_gadol/core/widgets/staggered_list_item.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_events.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_state.dart';

class ProductsListView extends StatelessWidget {
  final ScrollController scrollController;
  final bool isWideLayout;
  final int? selectedProductId;
  final ValueChanged<int>? onProductSelected;

  const ProductsListView({
    super.key,
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
              message: state.errorMessage ??
                  'Something went wrong.',
              onRetry: () {
                context
                    .read<ProductsBloc>()
                    .add(const LoadProducts());
              },
            );
          case ProductsStatus.loaded:
            if (state.products.isEmpty) {
              return const EmptyState();
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ProductsBloc>()
                    .add(const RefreshProducts());
              },
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: state.products.length +
                    (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final product = state.products[index];
                  return StaggeredListItem(
                    index: index,
                    child: ProductCard(
                      product: product,
                      isSelected: isWideLayout &&
                          product.id == selectedProductId,
                      onTap: () {
                        onProductSelected?.call(product.id);
                      },
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }
}
