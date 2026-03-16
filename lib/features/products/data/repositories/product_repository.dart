import 'package:dio/dio.dart';
import 'package:tech_gadol/core/services/api_services/api_constants.dart';
import 'package:tech_gadol/core/services/api_services/api_functions.dart';
import 'package:tech_gadol/features/products/data/models/product_model.dart';

class ProductRepository {
  final ApiFunction _apiFunction;

  ProductRepository({ApiFunction? apiFunction})
      : _apiFunction = apiFunction ?? ApiFunction();

  Future<ProductsResponse> getProducts({
    int limit = 20,
    int skip = 0,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiFunction.getApiCall(
      apiName: ApiConstants.products,
      queryParameters: {'limit': limit, 'skip': skip},
      cancelToken: cancelToken,
    );
    if (response == null) throw Exception('No internet connection');
    return ProductsResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<ProductsResponse> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiFunction.getApiCall(
      apiName: ApiConstants.productSearch,
      queryParameters: {'q': query, 'limit': limit, 'skip': skip},
      cancelToken: cancelToken,
    );
    if (response == null) throw Exception('No internet connection');
    return ProductsResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<List<String>> getCategories({CancelToken? cancelToken}) async {
    final response = await _apiFunction.getApiCall(
      apiName: ApiConstants.productCategories,
      cancelToken: cancelToken,
    );
    if (response == null) throw Exception('No internet connection');
    final list = response as List<dynamic>;
    return list.map((e) {
      if (e is Map<String, dynamic>) return e['slug'] as String? ?? '';
      return e.toString();
    }).where((s) => s.isNotEmpty).toList();
  }

  Future<ProductsResponse> getProductsByCategory({
    required String category,
    int limit = 20,
    int skip = 0,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiFunction.getApiCall(
      apiName: '${ApiConstants.productsByCategory}/$category',
      queryParameters: {'limit': limit, 'skip': skip},
      cancelToken: cancelToken,
    );
    if (response == null) throw Exception('No internet connection');
    return ProductsResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<ProductModel> getProductById({
    required int id,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiFunction.getApiCall(
      apiName: '${ApiConstants.products}/$id',
      cancelToken: cancelToken,
    );
    if (response == null) throw Exception('No internet connection');
    return ProductModel.fromJson(response as Map<String, dynamic>);
  }
}
