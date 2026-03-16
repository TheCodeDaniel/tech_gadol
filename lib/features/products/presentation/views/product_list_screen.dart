import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/widgets/app_search_bar.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_events.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_state.dart';
import 'package:tech_gadol/features/products/presentation/widgets/cache_banner.dart';
import 'package:tech_gadol/features/products/presentation/widgets/categories_row.dart';
import 'package:tech_gadol/features/products/presentation/widgets/products_list_view.dart';

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
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
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
    final maxScroll =
        _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= maxScroll - 200) {
      context
          .read<ProductsBloc>()
          .add(const LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ProductsBloc, ProductsState>(
          buildWhen: (prev, curr) =>
              prev.isFromCache != curr.isFromCache,
          builder: (context, state) {
            if (!state.isFromCache) {
              return const SizedBox.shrink();
            }
            return CacheBanner(
              onRefresh: () {
                context
                    .read<ProductsBloc>()
                    .add(const RefreshProducts());
              },
            );
          },
        ),
        BlocBuilder<ProductsBloc, ProductsState>(
          buildWhen: (prev, curr) =>
              prev.searchQuery != curr.searchQuery,
          builder: (context, state) {
            return AppSearchBar(
              initialQuery: state.searchQuery,
              onChanged: (query) {
                context
                    .read<ProductsBloc>()
                    .add(SearchProducts(query));
              },
            );
          },
        ),
        const CategoriesRow(),
        Expanded(
          child: ProductsListView(
            scrollController: _scrollController,
            isWideLayout: widget.isWideLayout,
            selectedProductId: widget.selectedProductId,
            onProductSelected: widget.onProductSelected,
          ),
        ),
      ],
    );
  }
}
