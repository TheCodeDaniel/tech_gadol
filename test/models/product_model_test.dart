import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol/features/products/data/models/product_model.dart';

void main() {
  group('ProductModel.fromJson', () {
    test('parses valid product JSON correctly', () {
      final json = _validProductJson();
      final product = ProductModel.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'iPhone 9');
      expect(product.description, 'An apple mobile');
      expect(product.price, 549.0);
      expect(product.discountPercentage, 12.96);
      expect(product.rating, 4.69);
      expect(product.stock, 94);
      expect(product.brand, 'Apple');
      expect(product.category, 'smartphones');
      expect(product.thumbnail, 'https://example.com/thumb.jpg');
      expect(product.images, hasLength(2));
    });

    test('provides default brand when brand is missing', () {
      final json = _validProductJson()..remove('brand');
      final product = ProductModel.fromJson(json);

      expect(product.brand, 'Unknown brand');
    });

    test('provides default brand when brand is empty string', () {
      final json = _validProductJson()..['brand'] = '';
      final product = ProductModel.fromJson(json);

      expect(product.brand, 'Unknown brand');
    });

    test('handles missing price as -1', () {
      final json = _validProductJson()..remove('price');
      final product = ProductModel.fromJson(json);

      expect(product.price, -1);
      expect(product.hasPriceAvailable, false);
    });

    test('handles negative price', () {
      final json = _validProductJson()..['price'] = -10;
      final product = ProductModel.fromJson(json);

      expect(product.price, -1);
      expect(product.hasPriceAvailable, false);
    });

    test('handles missing title with default', () {
      final json = _validProductJson()..remove('title');
      final product = ProductModel.fromJson(json);

      expect(product.title, 'Untitled Product');
    });

    test('handles missing category with default', () {
      final json = _validProductJson()..remove('category');
      final product = ProductModel.fromJson(json);

      expect(product.category, 'Uncategorized');
    });

    test('clamps rating between 0 and 5', () {
      final json = _validProductJson()..['rating'] = 7.5;
      final product = ProductModel.fromJson(json);

      expect(product.rating, 5.0);
    });

    test('handles missing images as empty list', () {
      final json = _validProductJson()..remove('images');
      final product = ProductModel.fromJson(json);

      expect(product.images, isEmpty);
    });

    test('filters out invalid image URLs', () {
      final json = _validProductJson()..['images'] = ['https://example.com/valid.jpg', 'not-a-url', ''];
      final product = ProductModel.fromJson(json);

      expect(product.images, hasLength(1));
      expect(product.images.first, 'https://example.com/valid.jpg');
    });

    test('handles completely missing fields without crashing', () {
      final product = ProductModel.fromJson({});

      expect(product.id, 0);
      expect(product.title, 'Untitled Product');
      expect(product.brand, 'Unknown brand');
      expect(product.category, 'Uncategorized');
      expect(product.price, -1);
      expect(product.rating, 0);
      expect(product.stock, 0);
      expect(product.images, isEmpty);
    });
  });

  group('ProductModel computed properties', () {
    test('calculates discounted price correctly', () {
      final json = _validProductJson();
      final product = ProductModel.fromJson(json);

      final expected = 549.0 - (549.0 * 12.96 / 100);
      expect(product.discountedPrice, closeTo(expected, 0.01));
    });

    test('hasDiscount is true when discountPercentage > 0', () {
      final product = ProductModel.fromJson(_validProductJson());
      expect(product.hasDiscount, true);
    });

    test('hasDiscount is false when discountPercentage is 0', () {
      final json = _validProductJson()..['discountPercentage'] = 0;
      final product = ProductModel.fromJson(json);
      expect(product.hasDiscount, false);
    });

    test('isInStock is true when stock > 0', () {
      final product = ProductModel.fromJson(_validProductJson());
      expect(product.isInStock, true);
    });

    test('isInStock is false when stock is 0', () {
      final json = _validProductJson()..['stock'] = 0;
      final product = ProductModel.fromJson(json);
      expect(product.isInStock, false);
    });
  });

  group('ProductsResponse.fromJson', () {
    test('parses response with products', () {
      final json = {
        'products': [_validProductJson()],
        'total': 100,
        'skip': 0,
        'limit': 20,
      };
      final response = ProductsResponse.fromJson(json);

      expect(response.products, hasLength(1));
      expect(response.total, 100);
      expect(response.skip, 0);
      expect(response.limit, 20);
      expect(response.hasMore, true);
    });

    test('hasMore is false when all products loaded', () {
      final json = {
        'products': [_validProductJson()],
        'total': 1,
        'skip': 0,
        'limit': 20,
      };
      final response = ProductsResponse.fromJson(json);

      expect(response.hasMore, false);
    });

    test('handles empty products list', () {
      final json = {'products': [], 'total': 0, 'skip': 0, 'limit': 20};
      final response = ProductsResponse.fromJson(json);

      expect(response.products, isEmpty);
      expect(response.hasMore, false);
    });
  });
}

Map<String, dynamic> _validProductJson() => {
  'id': 1,
  'title': 'iPhone 9',
  'description': 'An apple mobile',
  'price': 549,
  'discountPercentage': 12.96,
  'rating': 4.69,
  'stock': 94,
  'brand': 'Apple',
  'category': 'smartphones',
  'thumbnail': 'https://example.com/thumb.jpg',
  'images': ['https://example.com/img1.jpg', 'https://example.com/img2.jpg'],
  'availabilityStatus': 'In Stock',
  'warrantyInformation': '1 year warranty',
  'shippingInformation': 'Ships in 1 week',
  'returnPolicy': '30 day return',
  'tags': ['phone', 'apple'],
};
