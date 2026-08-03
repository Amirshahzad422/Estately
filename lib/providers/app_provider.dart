import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/mock_data.dart';

class FilterState {
  final String keyword;
  final String? type; // 'House', 'Apartment', 'Villa', etc.
  final String? listing; // 'buy', 'rent'
  final double? minPrice;
  final double? maxPrice;
  final int? bedrooms;
  final double? bathrooms;
  final int? minArea;
  final String? location;
  final String sortBy; // 'newest', 'price_low', 'price_high', 'popular'

  const FilterState({
    this.keyword = '',
    this.type,
    this.listing,
    this.minPrice,
    this.maxPrice,
    this.bedrooms,
    this.bathrooms,
    this.minArea,
    this.location,
    this.sortBy = 'newest',
  });

  FilterState copyWith({
    String? keyword,
    String? type,
    String? listing,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    double? bathrooms,
    int? minArea,
    String? location,
    String? sortBy,
    bool clearType = false,
    bool clearListing = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearBedrooms = false,
    bool clearBathrooms = false,
    bool clearMinArea = false,
    bool clearLocation = false,
  }) {
    return FilterState(
      keyword: keyword ?? this.keyword,
      type: clearType ? null : (type ?? this.type),
      listing: clearListing ? null : (listing ?? this.listing),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      bedrooms: clearBedrooms ? null : (bedrooms ?? this.bedrooms),
      bathrooms: clearBathrooms ? null : (bathrooms ?? this.bathrooms),
      minArea: clearMinArea ? null : (minArea ?? this.minArea),
      location: clearLocation ? null : (location ?? this.location),
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      keyword.isNotEmpty ||
      type != null ||
      listing != null ||
      minPrice != null ||
      maxPrice != null ||
      bedrooms != null ||
      bathrooms != null ||
      minArea != null ||
      location != null;
}

class AppProvider extends ChangeNotifier {
  // Saved Properties
  final Set<String> _savedPropertyIds = {};

  Set<String> get savedPropertyIds => Set.unmodifiable(_savedPropertyIds);

  List<Property> get savedProperties =>
      mockProperties.where((p) => _savedPropertyIds.contains(p.id)).toList();

  bool isSaved(String propertyId) => _savedPropertyIds.contains(propertyId);

  void toggleSaved(String propertyId) {
    if (_savedPropertyIds.contains(propertyId)) {
      _savedPropertyIds.remove(propertyId);
    } else {
      _savedPropertyIds.add(propertyId);
    }
    notifyListeners();
  }

  // Recently Viewed Properties
  final List<String> _recentlyViewedIds = [];

  List<Property> get recentlyViewedProperties {
    List<Property> list = [];
    for (final id in _recentlyViewedIds) {
      final p = mockProperties.where((element) => element.id == id).firstOrNull;
      if (p != null) list.add(p);
    }
    return list;
  }

  void recordView(String propertyId) {
    _recentlyViewedIds.remove(propertyId);
    _recentlyViewedIds.insert(0, propertyId);
    if (_recentlyViewedIds.length > 20) {
      _recentlyViewedIds.removeLast();
    }
    notifyListeners();
  }

  // Real-time Enquiries
  final List<Enquiry> _enquiries = [];

  List<Enquiry> get enquiries => List.unmodifiable(_enquiries);

  void addEnquiry(Enquiry enquiry) {
    _enquiries.insert(0, enquiry);
    notifyListeners();
  }

  // Filter State
  FilterState _filterState = const FilterState();

  FilterState get filterState => _filterState;

  void updateFilter(FilterState newFilters) {
    _filterState = newFilters;
    notifyListeners();
  }

  // User Profile Data
  String userName = 'Syed Arif Husain Shah';
  String userEmail = 'syedarifhussainshah819@gamil.com';
  String userAvatar = 'https://scontent.flyp2-1.fna.fbcdn.net/v/t39.30808-1/488062075_1844064686345165_8186855204777119585_n.jpg?stp=dst-jpg_tt6&cstp=mx1133x1125&ctp=s200x200&_nc_cat=101&ccb=1-7&_nc_sid=1d2534&_nc_eui2=AeG_HIK3GCQYQ6I6B46NT3cClTwEeTeXm5KVPAR5N5ebkoQR5vAPRt6XNMmVbVqxDJNhSK71KAEQtZSFE1nt4xLN&_nc_ohc=4Uz3ew3-ETIQ7kNvwEmjAGd&_nc_oc=AdpPLsVyNOjJBJR3OVJr5O28-1OfuGPJruwUrlh4zXn_tRhGB3Gr-IXUFxy4fKgsoUg&_nc_zt=24&_nc_ht=scontent.flyp2-1.fna&_nc_gid=8qgfuac3KvcmejtujynfJw&_nc_ss=7b2a8&oh=00_AQGM_Tp1J_KjxUUGKUK9I-l_Wp2k_46bNXY0bbp1xOLohg&oe=6A763C0A';
  String userMemberSince = 'Member since 2024';

  void updateAvatar(String newImageUrl) {
    userAvatar = newImageUrl;
    notifyListeners();
  }

  void updateProfile(String name, String email) {
    userName = name;
    userEmail = email;
    notifyListeners();
  }

  void resetFilters() {
    _filterState = const FilterState();
    notifyListeners();
  }

  // Filtered Properties
  List<Property> get filteredProperties {
    List<Property> result = List.from(mockProperties);

    // Keyword filter
    if (_filterState.keyword.isNotEmpty) {
      final kw = _filterState.keyword.toLowerCase();
      result = result.where((p) =>
        p.title.toLowerCase().contains(kw) ||
        p.location.toLowerCase().contains(kw) ||
        p.city.toLowerCase().contains(kw) ||
        p.type.toLowerCase().contains(kw)
      ).toList();
    }

    // Type filter
    if (_filterState.type != null) {
      result = result.where((p) => p.type == _filterState.type).toList();
    }

    // Listing filter
    if (_filterState.listing != null) {
      result = result.where((p) => p.listing == _filterState.listing).toList();
    }

    // Price filters
    if (_filterState.minPrice != null) {
      result = result.where((p) => p.price >= _filterState.minPrice!).toList();
    }
    if (_filterState.maxPrice != null) {
      result = result.where((p) => p.price <= _filterState.maxPrice!).toList();
    }

    // Bedroom filter
    if (_filterState.bedrooms != null) {
      result = result.where((p) => p.bedrooms >= _filterState.bedrooms!).toList();
    }

    // Bathroom filter
    if (_filterState.bathrooms != null) {
      result = result.where((p) => p.bathrooms >= _filterState.bathrooms!).toList();
    }

    // Area filter
    if (_filterState.minArea != null) {
      result = result.where((p) => p.area >= _filterState.minArea!).toList();
    }

    // Location filter
    if (_filterState.location != null && _filterState.location!.isNotEmpty) {
      final loc = _filterState.location!.toLowerCase();
      result = result.where((p) =>
        p.city.toLowerCase().contains(loc) ||
        p.location.toLowerCase().contains(loc)
      ).toList();
    }

    // Sort
    switch (_filterState.sortBy) {
      case 'newest':
        result.sort((a, b) => b.listedDate.compareTo(a.listedDate));
        break;
      case 'price_low':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'popular':
        result = result.where((p) => p.isPopular).toList()
          ..addAll(result.where((p) => !p.isPopular));
        break;
    }

    return result;
  }

  // Navigation index
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }
}
