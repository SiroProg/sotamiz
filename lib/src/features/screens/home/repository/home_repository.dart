import '../models/banner.dart';
import '../models/category.dart';
import '../models/location.dart';
import '../models/product.dart';

class ProductListPage {
  const ProductListPage({required this.items, required this.nextCursor});

  final List<Product> items;
  final String? nextCursor;
}

abstract class HomeRepository {
  Future<List<ProductCategory>> fetchCategories();
  Future<List<Baner>> fetchBanners();
  Future<ProductListPage> fetchProducts({
    String? cursor,
    int limit = 20,
    String? categoryId,
    String? locationId,
    String? searchQuery,
  });
  Future<List<Location>> fetchLocations();
}
