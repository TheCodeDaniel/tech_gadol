import 'package:equatable/equatable.dart';
import 'package:tech_gadol/features/products/data/models/product_model.dart';

enum ProductsStatus { initial, loading, loaded, error }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<ProductModel> products;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentSkip;
  final int total;
  final ProductModel? selectedProduct;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentSkip = 0,
    this.total = 0,
    this.selectedProduct,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductModel>? products,
    List<String>? categories,
    String? Function()? selectedCategory,
    String? searchQuery,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? Function()? errorMessage,
    int? currentSkip,
    int? total,
    ProductModel? Function()? selectedProduct,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      currentSkip: currentSkip ?? this.currentSkip,
      total: total ?? this.total,
      selectedProduct: selectedProduct != null ? selectedProduct() : this.selectedProduct,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    categories,
    selectedCategory,
    searchQuery,
    hasReachedMax,
    isLoadingMore,
    errorMessage,
    currentSkip,
    total,
    selectedProduct,
  ];
}
