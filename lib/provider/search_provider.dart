import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_apps/data/api/api_search.dart';
import 'package:restaurant_apps/data/model/restaurant_search.dart';

enum ResultState { Loading, NoData, HasData, Error }

class SearchProvider extends ChangeNotifier {
  final ApiSearch apiSearch;

  SearchProvider({required this.apiSearch}) {
    _fetchSearchRestaurant();
  }

  late Search _search;
  late ResultState _state;

  String _message = '';
  String get message => _message;
  Search get result => _search;
  ResultState get state => _state;

  Future<dynamic> _fetchSearchRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiSearch.topSearchlines();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Pencarian tidak ditemukan.';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _search = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Ada Kesalahan, Silakan Cek Internet Anda';
    }
  }
}
