import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_events.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_state.dart';
import 'package:tech_gadol/features/products/presentation/widgets/product_detail_body.dart';

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
          body: ProductDetailBody(product: product),
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
        return ProductDetailBody(product: product);
      },
    );
  }
}
