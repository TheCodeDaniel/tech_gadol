import 'package:flutter/material.dart';
import 'package:tech_gadol/app.dart';
import 'package:tech_gadol/core/services/local_storage_services/product_cache_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProductCacheService.init();
  runApp(const App());
}
