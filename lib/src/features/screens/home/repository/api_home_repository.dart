import 'dart:convert';

import '../../../../core/service/api_service.dart';
import '../models/banner.dart';
import '../models/category.dart';
import '../models/location.dart';
import '../models/product.dart';
import 'home_repository.dart';

/// Реализация репозитория, готовая к бэкенду.
class ApiHomeRepository implements HomeRepository {
  const ApiHomeRepository();

  @override
  Future<List<ProductCategory>> fetchCategories() async {
    final raw = await ApiService.request('/categories', method: Method.get);

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected categories response');
    }

    final items = (decoded['items'] as List? ?? [])
        .whereType<Map>()
        .map((e) => ProductCategory.fromJson(e.cast<String, dynamic>()))
        .toList();

    return items;
  }

  @override
  Future<List<Baner>> fetchBanners() async {
    final raw = await ApiService.request('/banners', method: Method.get);

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected banners response');
    }

    final items = (decoded['items'] as List? ?? [])
        .whereType<Map>()
        .map((e) => Baner.fromJson(e.cast<String, dynamic>()))
        .toList();

    return items;
  }

  @override
  Future<ProductListPage> fetchProducts({
    String? cursor,
    int limit = 20,
    String? categoryId,
    String? locationId,
    String? searchQuery,
  }) async {
    final queryParameters = <String, Object?>{
      'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (categoryId != null) 'categoryId': categoryId,
      if (locationId != null) 'locationId': locationId,
      if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
    };

    final raw = await ApiService.request(
      '/products',
      method: Method.get,
      queryParameters: queryParameters,
    );

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected products response');
    }

    final items = (decoded['items'] as List? ?? [])
        .whereType<Map>()
        .map((e) => Product.fromJson(e.cast<String, dynamic>()))
        .toList();

    final nextCursor = decoded['nextCursor']?.toString();

    return ProductListPage(
      items: items,
      nextCursor: nextCursor?.isEmpty == true ? null : nextCursor,
    );
  }

  @override
  Future<List<Location>> fetchLocations() async {
    final raw = await ApiService.request('/locations', method: Method.get);

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected locations response');
    }

    final items = (decoded['items'] as List? ?? [])
        .whereType<Map>()
        .map((e) => Location.fromJson(e.cast<String, dynamic>()))
        .toList();

    return items;
  }
}
