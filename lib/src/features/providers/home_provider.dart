import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../screens/home/models/banner.dart';
import '../screens/home/models/category.dart';
import '../screens/home/models/location.dart';
import '../screens/home/models/product.dart';
import '../screens/home/repository/home_repository.dart';

enum LoadStatus { idle, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  HomeProvider({required HomeRepository repository}) : _repository = repository;

  final HomeRepository _repository;

  // Категории
  LoadStatus categoriesStatus = LoadStatus.idle;
  String? categoriesErrorMessage;
  List<ProductCategory> categories = const [];

  // Баннеры
  LoadStatus bannersStatus = LoadStatus.idle;
  String? bannersErrorMessage;
  List<Baner> banners = const [];

  // Товары
  LoadStatus productsStatus = LoadStatus.idle;
  String? productsErrorMessage;
  List<Product> products = const [];

  // Локации
  List<Location> locations = const [];
  Location? selectedLocation;

  // Фильтры
  String? selectedCategoryId;
  String? searchQuery;

  // Пагинация
  String? _cursor;
  bool _isLoadingMore = false;
  bool get canLoadMore => _cursor != null && !_isLoadingMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadInitial() async {
    await Future.wait([
      loadCategories(),
      loadBanners(),
      loadLocations(),
      loadProducts(),
    ]);
  }

  Future<void> loadCategories() async {
    categoriesStatus = LoadStatus.loading;
    categoriesErrorMessage = null;
    notifyListeners();

    try {
      categories = await _repository.fetchCategories();
      categoriesStatus = LoadStatus.loaded;
      notifyListeners();
    } catch (e) {
      categoriesStatus = LoadStatus.error;
      categoriesErrorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadBanners() async {
    bannersStatus = LoadStatus.loading;
    bannersErrorMessage = null;
    notifyListeners();

    try {
      banners = await _repository.fetchBanners();
      bannersStatus = LoadStatus.loaded;
      notifyListeners();
    } catch (e) {
      bannersStatus = LoadStatus.error;
      bannersErrorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadLocations() async {
    try {
      locations = await _repository.fetchLocations();
      if (locations.isNotEmpty && selectedLocation == null) {
        selectedLocation = locations.first;
      }
      notifyListeners();
    } catch (e) {
      // Игнорируем ошибки загрузки локаций
    }
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      productsStatus = LoadStatus.loading;
      _cursor = null;
      products = const [];
    } else if (productsStatus == LoadStatus.idle) {
      productsStatus = LoadStatus.loading;
    }
    productsErrorMessage = null;
    notifyListeners();

    try {
      final page = await _repository.fetchProducts(
        cursor: refresh ? null : _cursor,
        categoryId: selectedCategoryId,
        locationId: selectedLocation?.id,
        searchQuery: searchQuery,
      );
      products = refresh ? page.items : [...products, ...page.items];
      _cursor = page.nextCursor;
      productsStatus = LoadStatus.loaded;
      notifyListeners();
    } catch (e) {
      productsStatus = LoadStatus.error;
      productsErrorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadProducts(refresh: true);
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      await loadProducts();
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      productsErrorMessage = e.toString();
      notifyListeners();
    }
  }

  void setSelectedLocation(Location? location) {
    selectedLocation = location;
    loadProducts(refresh: true);
    notifyListeners();
  }

  void setSelectedCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    loadProducts(refresh: true);
    notifyListeners();
  }

  void setSearchQuery(String? query) {
    searchQuery = query;
    loadProducts(refresh: true);
    notifyListeners();
  }
}
