import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:resturent/resturent.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
}

class Initial extends RestaurantState {
  List<Object?> get props => [];
}

class Loading extends RestaurantState {
  const Loading();

  @override
  List<Object?> get props => [];
}

class PageLoaded extends RestaurantState {
  List<Restaurant> get restaurants => _page!.restaurants;
  final Page? _page;
  int? get nextPage => _page!.isLast ? null : this._page!.currentPage! + 1;
  const PageLoaded(this._page);

  @override
  List<Object?> get props => [_page];
}

class RestaurantLoaded extends RestaurantState {
  final Restaurant restaurant;

  RestaurantLoaded(this.restaurant);

  @override
  List<Object?> get props => [restaurant];
}

class MenuLoaded extends RestaurantState {
  final List<Menu> menu;

  MenuLoaded(this.menu);

  @override
  List<Object?> get props => [menu];
}

class ErrorState extends RestaurantState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object?> get props => [message];

  

}
