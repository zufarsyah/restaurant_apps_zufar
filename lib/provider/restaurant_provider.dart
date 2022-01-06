import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_apps/data/api/api_restaurant.dart';
import 'package:restaurant_apps/data/model/restaurant.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantProvider extends ChangeNotifier {
  final ApiRestaurantList apiRestaurant;

  RestaurantProvider({required this.apiRestaurant}) {
    _fetchAllRestaurant();
  }

  late Welcome _welcome;
  late ResultState _state;

  String _message = '';
  String get message => _message;
  Welcome get result => _welcome;
  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiRestaurant.topHeadlines();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Tidak Ada Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _welcome = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Ada Kesalahan, Silakan Cek Internet Anda.';
    }
  }
}
