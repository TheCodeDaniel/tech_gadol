import 'package:go_router/go_router.dart';
import 'package:tech_gadol/core/routing/app_routes.dart';
import 'package:tech_gadol/features/products/presentation/views/product_detail_screen.dart';
import 'package:tech_gadol/features/products/presentation/views/responsive_layout.dart';
import 'package:tech_gadol/features/showcase/presentation/views/showcase_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.products,
    routes: [
      GoRoute(
        path: AppRoutes.products,
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
      GoRoute(
        path: AppRoutes.showcase,
        builder: (context, state) => const ShowcaseScreen(),
      ),
    ],
  );
}
