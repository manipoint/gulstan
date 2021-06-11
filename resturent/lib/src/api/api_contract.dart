

import './page.dart';
import '../domain/menu.dart';
import '../domain/restaurant.dart';

abstract class IRestaurantApi {
  Future<Page> getAllRestaurants({int? page, int? pageSize});
  Future<Page> getRestaurantByLocation(
      {  int? page, int? pageSize,  Location ?location});

  Future<Page> findRestaurant(
      { int? page, int? pageSize , String? searchTerm});

  Future<Restaurant?> getRestaurant({  String? id});
  Future<List<Menu>> getRestaurantMenu({ String? restaurantId});
}
