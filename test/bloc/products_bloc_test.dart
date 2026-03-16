import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_gadol/features/products/data/models/product_model.dart';
import 'package:tech_gadol/features/products/data/repositories/product_repository.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_events.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_state.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  final testProducts = List.generate(
    5,
    (i) => ProductModel(
      id: i + 1,
      title: 'Product ${i + 1}',
      description: 'Description ${i + 1}',
      category: 'category',
      price: 10.0 + i,
      discountPercentage: 5,
      rating: 4.0,
      stock: 10,
      brand: 'Brand',
      thumbnail: 'https://example.com/thumb$i.jpg',
      images: ['https://example.com/img$i.jpg'],
      availabilityStatus: 'In Stock',
      warrantyInformation: '',
      shippingInformation: '',
      returnPolicy: '',
      tags: [],
    ),
  );

  final testResponse = ProductsResponse(
    products: testProducts,
    total: 50,
    skip: 0,
    limit: 20,
  );

  group('LoadProducts', () {
    blocTest<ProductsBloc, ProductsState>(
      'emits [loading, loaded] when products are fetched successfully',
      setUp: () {
        when(() => mockRepository.getProducts(
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => testResponse);
        when(() => mockRepository.getCategories(
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => ['electronics', 'clothing']);
      },
      build: () => ProductsBloc(repository: mockRepository),
      act: (bloc) => bloc.add(const LoadProducts()),
      expect: () => [
        const ProductsState(status: ProductsStatus.loading),
        ProductsState(
          status: ProductsStatus.loaded,
          products: testProducts,
          categories: ['electronics', 'clothing'],
          currentSkip: 5,
          total: 50,
          hasReachedMax: false,
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [loading, error] when fetch fails',
      setUp: () {
        when(() => mockRepository.getProducts(
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(Exception('Network error'));
        when(() => mockRepository.getCategories(
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => []);
      },
      build: () => ProductsBloc(repository: mockRepository),
      act: (bloc) => bloc.add(const LoadProducts()),
      expect: () => [
        const ProductsState(status: ProductsStatus.loading),
        isA<ProductsState>()
            .having((s) => s.status, 'status', ProductsStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );
  });

  group('LoadMoreProducts', () {
    blocTest<ProductsBloc, ProductsState>(
      'appends products when loading more',
      setUp: () {
        when(() => mockRepository.getProducts(
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => ProductsResponse(
              products: testProducts,
              total: 50,
              skip: 5,
              limit: 20,
            ));
      },
      build: () => ProductsBloc(repository: mockRepository),
      seed: () => ProductsState(
        status: ProductsStatus.loaded,
        products: testProducts,
        currentSkip: 5,
        total: 50,
      ),
      act: (bloc) => bloc.add(const LoadMoreProducts()),
      expect: () => [
        isA<ProductsState>().having((s) => s.isLoadingMore, 'isLoadingMore', true),
        isA<ProductsState>()
            .having((s) => s.products.length, 'products.length', 10)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'does not load more when hasReachedMax is true',
      build: () => ProductsBloc(repository: mockRepository),
      seed: () => ProductsState(
        status: ProductsStatus.loaded,
        products: testProducts,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const LoadMoreProducts()),
      expect: () => [],
    );
  });

  group('SelectCategory', () {
    blocTest<ProductsBloc, ProductsState>(
      'sets selected category and reloads products',
      setUp: () {
        when(() => mockRepository.getProductsByCategory(
              category: any(named: 'category'),
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => testResponse);
      },
      build: () => ProductsBloc(repository: mockRepository),
      seed: () => const ProductsState(
        status: ProductsStatus.loaded,
        categories: ['electronics', 'clothing'],
      ),
      act: (bloc) => bloc.add(const SelectCategory('electronics')),
      expect: () => [
        // SelectCategory emits state with category
        isA<ProductsState>().having(
            (s) => s.selectedCategory, 'selectedCategory', 'electronics'),
        // Then LoadProducts fires -> loading
        isA<ProductsState>().having(
            (s) => s.status, 'status', ProductsStatus.loading),
        // Then loaded
        isA<ProductsState>()
            .having((s) => s.status, 'status', ProductsStatus.loaded)
            .having((s) => s.selectedCategory, 'selectedCategory', 'electronics'),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'deselects category when same category is tapped again',
      setUp: () {
        when(() => mockRepository.getProducts(
              limit: any(named: 'limit'),
              skip: any(named: 'skip'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => testResponse);
        when(() => mockRepository.getCategories(
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => ['electronics']);
      },
      build: () => ProductsBloc(repository: mockRepository),
      seed: () => const ProductsState(
        status: ProductsStatus.loaded,
        selectedCategory: 'electronics',
        categories: ['electronics'],
      ),
      act: (bloc) => bloc.add(const SelectCategory('electronics')),
      expect: () => [
        isA<ProductsState>()
            .having((s) => s.selectedCategory, 'selectedCategory', isNull),
        isA<ProductsState>()
            .having((s) => s.status, 'status', ProductsStatus.loading),
        isA<ProductsState>()
            .having((s) => s.status, 'status', ProductsStatus.loaded),
      ],
    );
  });

  group('SelectProduct', () {
    blocTest<ProductsBloc, ProductsState>(
      'selects product from existing list',
      build: () => ProductsBloc(repository: mockRepository),
      seed: () => ProductsState(
        status: ProductsStatus.loaded,
        products: testProducts,
      ),
      act: (bloc) => bloc.add(const SelectProduct(1)),
      expect: () => [
        isA<ProductsState>().having(
            (s) => s.selectedProduct?.id, 'selectedProduct.id', 1),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'fetches product by id when not in list',
      setUp: () {
        when(() => mockRepository.getProductById(
              id: any(named: 'id'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => testProducts.first);
      },
      build: () => ProductsBloc(repository: mockRepository),
      seed: () => const ProductsState(status: ProductsStatus.loaded),
      act: (bloc) => bloc.add(const SelectProduct(1)),
      expect: () => [
        isA<ProductsState>().having(
            (s) => s.selectedProduct?.id, 'selectedProduct.id', 1),
      ],
    );
  });
}
