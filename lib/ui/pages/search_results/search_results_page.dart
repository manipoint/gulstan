import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gulstan/state_mangment/restaurant/reataurant_state.dart';
import 'package:gulstan/state_mangment/restaurant/restaurant_cubit.dart';
import 'package:gulstan/ui/pages/search_results/search_result_adapter.dart';
import 'package:gulstan/utils/utils.dart';
import 'package:resturent/resturent.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchResultPage extends StatefulWidget {
  final RestaurantCubit restaurantCubit;
  final String query;
  final ISearchResultsPageAdapter adapter;

  const SearchResultPage(this.restaurantCubit, this.query,this.adapter);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<Restaurant?> restaurants = [];
  PageLoaded? currentState;
  bool fetchMore = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    widget.restaurantCubit.search(1, widget.query);
    super.initState();
    _onScrollListener();
  }

  void _onScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          currentState != null) {
        fetchMore = true;
        widget.restaurantCubit.search(
          currentState!.nextPage!,
          widget.query,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${widget.query} Results',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(child: _buildResults())
          ],
        ),
      ),
    );
  }

  _buildResults() {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      bloc: widget.restaurantCubit,
      builder: (_, state) {
        if (state is PageLoaded) {
          currentState = state;
          fetchMore = false;
          restaurants.addAll(state.restaurants);
        }
        if (state is ErrorState) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        }
        if (currentState == null)
          return Center(
            child: CircularProgressIndicator(),
          );

        return _buildResultsList();
      },
    );
  }

  _buildResultsList() => ListView.separated(
        itemBuilder: (context, index) {
          if (index >= restaurants.length) {
            return bottomLoader();
          } else {
            return ListTile(
              leading: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                    'https://i.picsum.photos/id/225/1500/979.jpg?hmac=jvGoek9ng_Y0GaBbzxN0KJhHaiPtk1VfRcukK8R8FxQ',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurants[index]!.name!,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  RatingBarIndicator(
                    rating: 4.5,
                    itemBuilder: (context, index) => Icon(
                      Icons.star_rate,
                      color: Colors.purpleAccent,
                    ),
                    itemSize: 25,
                  )
                ],
              ),
              subtitle: Text(
                "${restaurants[index]!.address!.street!},${restaurants[index]!.address!.city},${restaurants[index]!.address!.provence}",
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            );
          }
        },
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        separatorBuilder: (BuildContext _, index) => Divider(),
        itemCount: !fetchMore ? restaurants.length : restaurants.length + 1,
      );
}
