import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gulstan/state_mangment/restaurant/reataurant_state.dart';
import 'package:resturent/resturent.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final IRestaurantApi _api;
  final int _pageSize;

  RestaurantCubit(this._api, {int defaultPageSize = 30})
      : _pageSize = defaultPageSize,
        super(Initial());

  getAllRestaurants({@required int? page}) async {
    _startLoading();
    final pageResult = await _api.getAllRestaurants(
      page: page,
      pageSize: _pageSize,
    );
    pageResult.restaurants.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(pageResult);
  }

  getRestaurantsByLocation(int page, Location location) async {
    _startLoading();
    final pageResult = await _api.getRestaurantByLocation(
      page: page,
      pageSize: _pageSize,
      location: location,
    );

    pageResult.restaurants.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(pageResult);
  }

  search(int page, String query) async {
    _startLoading();
    final searchResults = await _api.findRestaurant(
      page: page,
      pageSize: _pageSize,
      searchTerm: query,
    );
    searchResults.restaurants.isEmpty
        ? _showError('no restaurants found')
        : _setPageData(searchResults);
  }

  getRestaurant(String id) async {
    _startLoading();
    final restaurant = await _api.getRestaurant(id: id);
    restaurant != null
        ? emit(RestaurantLoaded(restaurant))
        : emit(ErrorState('restaurant not found'));
  }

  getRestaurantMenu(String restauranId) async {
    _startLoading();
    final menu = await _api.getRestaurantMenu(restaurantId: restauranId);
    menu.isNotEmpty
        ? emit(MenuLoaded(menu))
        : emit(ErrorState('no menu found for this restaurant'));
  }

  _startLoading() {
    emit(Loading());
  }

  _setPageData(Page result) {
    emit(PageLoaded(result));
  }

  _showError(String error) {
    emit(ErrorState(error));
  }
}