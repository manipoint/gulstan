import 'package:flutter/material.dart';
import 'package:gulstan/state_mangment/restaurant/restaurant_cubit.dart';
import 'package:resturent/resturent.dart';

class RestaurantPage extends StatefulWidget {
  final Restaurant restaurant;
  final RestaurantCubit restaurantCubit;

  const RestaurantPage(this.restaurant, this.restaurantCubit);
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
