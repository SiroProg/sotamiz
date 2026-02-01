import 'dart:async';

import '../models/banner.dart';
import '../models/category.dart';
import '../models/location.dart';
import '../models/product.dart';
import 'home_repository.dart';

/// Mock репозиторий для разработки без бэкенда.
class MockHomeRepository implements HomeRepository {
  const MockHomeRepository();

  @override
  Future<List<ProductCategory>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ProductCategory(id: '1', name: 'Мебель', icon: 'sofa'),
      ProductCategory(id: '2', name: 'Транспорт', icon: 'bicycle'),
      ProductCategory(id: '3', name: 'Электроника', icon: 'laptop'),
      ProductCategory(id: '4', name: 'Одежда', icon: 'tshirt'),
      ProductCategory(id: '5', name: 'Фототехника', icon: 'camera'),
      ProductCategory(id: '6', name: 'Часы', icon: 'watch'),
      ProductCategory(id: '7', name: 'Телефоны', icon: 'phone'),
      ProductCategory(id: '8', name: 'Аудио', icon: 'headphones'),
    ];
  }

  @override
  Future<List<Baner>> fetchBanners() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [Baner(id: '1', imageUrl: '', title: 'Рекламный баннер')];
  }

  @override
  Future<ProductListPage> fetchProducts({
    String? cursor,
    int limit = 20,
    String? categoryId,
    String? locationId,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final products = [
      Product(
        id: '1',
        title: 'Серый диван',
        price: 25000,
        priceText: '25 000 Р',
        imageUrl: null,
        location: 'Центр',
        createdAt: now.subtract(const Duration(hours: 2)),
        categoryId: '1',
      ),
      Product(
        id: '2',
        title: 'Горный велосипед',
        price: 18000,
        priceText: '18 000 Р',
        imageUrl: null,
        location: 'Северный район',
        createdAt: now.subtract(const Duration(hours: 5)),
        categoryId: '2',
      ),
      Product(
        id: '3',
        title: 'MacBook Pro',
        price: 120000,
        priceText: '120 000 Р',
        imageUrl: null,
        location: 'Центр',
        createdAt: now.subtract(const Duration(hours: 8)),
        categoryId: '3',
      ),
      Product(
        id: '4',
        title: 'Пуховик SUPER PI',
        price: 5000,
        priceText: '5 000 Р',
        imageUrl: null,
        location: 'Центр',
        createdAt: now.subtract(const Duration(hours: 12)),
        categoryId: '4',
      ),
    ];

    // Фильтрация по категории, если указана
    final filteredProducts = categoryId != null
        ? products.where((p) => p.categoryId == categoryId).toList()
        : products;

    // Фильтрация по локации, если указана
    final locationFilteredProducts = locationId != null
        ? filteredProducts.where((p) => p.location == locationId).toList()
        : filteredProducts;

    // Фильтрация по поисковому запросу, если указан
    final searchFilteredProducts = searchQuery != null && searchQuery.isNotEmpty
        ? locationFilteredProducts
              .where(
                (p) =>
                    p.title.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList()
        : locationFilteredProducts;

    // Пагинация
    final startIndex = cursor != null ? int.tryParse(cursor) ?? 0 : 0;
    final endIndex = (startIndex + limit).clamp(
      0,
      searchFilteredProducts.length,
    );
    final paginatedProducts = searchFilteredProducts.sublist(
      startIndex.clamp(0, searchFilteredProducts.length),
      endIndex,
    );

    final nextCursor = endIndex < searchFilteredProducts.length
        ? endIndex.toString()
        : null;

    return ProductListPage(items: paginatedProducts, nextCursor: nextCursor);
  }

  @override
  Future<List<Location>> fetchLocations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      Location(id: 'center', name: 'Центр'),
      Location(id: 'north', name: 'Северный район'),
      Location(id: 'south', name: 'Южный район'),
      Location(id: 'east', name: 'Восточный район'),
      Location(id: 'west', name: 'Западный район'),
    ];
  }
}
