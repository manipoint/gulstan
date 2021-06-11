import 'package:flutter/foundation.dart';
import 'package:resturent/src/domain/restaurant.dart';

class Page {
  final int? currentPage;
  final int? totalPages;
  final List<Restaurant> restaurants;
  bool get isLast => currentPage == totalPages;

  Page(
      {@required this.currentPage,
      @required this.totalPages,
     required this.restaurants});
}
