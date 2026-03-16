import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol/core/theme/light_theme.dart';
import 'package:tech_gadol/core/theme/dark_theme.dart';
import 'package:tech_gadol/core/widgets/product_card.dart';
import 'package:tech_gadol/features/products/data/models/product_model.dart';

void main() {
  final testProduct = ProductModel(
    id: 1,
    title: 'Test Product',
    description: 'A test product',
    category: 'electronics',
    price: 99.99,
    discountPercentage: 10,
    rating: 4.5,
    stock: 50,
    brand: 'TestBrand',
    thumbnail: 'https://example.com/thumb.jpg',
    images: ['https://example.com/img.jpg'],
    availabilityStatus: 'In Stock',
    warrantyInformation: '',
    shippingInformation: '',
    returnPolicy: '',
    tags: [],
  );

  Widget buildWidget({ProductModel? product, bool isSelected = false, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? LightTheme.themeData,
      home: Scaffold(
        body: ProductCard(product: product ?? testProduct, isSelected: isSelected, onTap: () {}),
      ),
    );
  }

  group('ProductCard', () {
    testWidgets('displays product title', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('displays brand name', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('TestBrand'), findsOneWidget);
    });

    testWidgets('displays In Stock indicator when in stock', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('In Stock'), findsOneWidget);
    });

    testWidgets('displays Out of Stock when stock is 0', (tester) async {
      final outOfStock = ProductModel(
        id: 2,
        title: 'Out of Stock Product',
        description: '',
        category: 'test',
        price: 50,
        discountPercentage: 0,
        rating: 3.0,
        stock: 0,
        brand: 'Brand',
        thumbnail: 'https://example.com/thumb.jpg',
        images: [],
        availabilityStatus: 'Out of Stock',
        warrantyInformation: '',
        shippingInformation: '',
        returnPolicy: '',
        tags: [],
      );
      await tester.pumpWidget(buildWidget(product: outOfStock));
      expect(find.text('Out of Stock'), findsOneWidget);
    });

    testWidgets('displays Price unavailable for negative price', (tester) async {
      final noPrice = ProductModel(
        id: 3,
        title: 'No Price',
        description: '',
        category: 'test',
        price: -1,
        discountPercentage: 0,
        rating: 3.0,
        stock: 10,
        brand: 'Brand',
        thumbnail: 'https://example.com/thumb.jpg',
        images: [],
        availabilityStatus: 'In Stock',
        warrantyInformation: '',
        shippingInformation: '',
        returnPolicy: '',
        tags: [],
      );
      await tester.pumpWidget(buildWidget(product: noPrice));
      expect(find.text('Price unavailable'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: LightTheme.themeData,
          home: Scaffold(
            body: ProductCard(product: testProduct, onTap: () => tapped = true),
          ),
        ),
      );
      await tester.tap(find.byType(ProductCard));
      expect(tapped, true);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await tester.pumpWidget(buildWidget(theme: DarkTheme.themeData));
      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('TestBrand'), findsOneWidget);
    });
  });
}
