import 'package:go_router/go_router.dart';
import 'package:tech_gadol/features/products/presentation/views/product_detail_screen.dart';
import 'package:tech_gadol/features/products/presentation/views/responsive_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/products',
    routes: [
      GoRoute(
        path: '/products',
        builder: (context, state) => const ResponsiveLayout(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return ProductDetailScreen(productId: id);
            },
          ),
        ],
      ),
    ],
  );
}
