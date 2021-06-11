import 'package:auth/source/domain/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulstan/models/header.dart';
import 'package:gulstan/state_mangment/helpers/header_bloc.dart';
import 'package:gulstan/state_mangment/restaurant/reataurant_state.dart';
import 'package:gulstan/state_mangment/restaurant/restaurant_cubit.dart';
import 'package:gulstan/ui/pages/home/home_page_adopter.dart';
import 'package:gulstan/ui/widgets/custom_text_fields.dart';
import 'package:gulstan/ui/widgets/restaurant_list_items.dart';
import 'package:gulstan/utils/utils.dart';
import 'package:resturent/resturent.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantListPage extends StatefulWidget {
  final IHomePageAdapter adapter;
  final IAuthService service;

  RestaurantListPage(
    this.adapter,
    this.service,
  );

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  PageLoaded? currentState;
  List<Restaurant> restaurant = [];
  double currentIndex = 0;
  double prevIndex = 0;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    BlocProvider.of<RestaurantCubit>(context).getAllRestaurants(page: 1);
    super.initState();
    _onScrollListener();
  }

  void _onScrollListener() {
    _scrollController.addListener(() {
      currentIndex = (_scrollController.offset.round() / 240).floorToDouble();
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          currentState!.nextPage != null) {
        BlocProvider.of<RestaurantCubit>(context)
            .getAllRestaurants(page: currentState!.nextPage);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.shopping_basket_outlined,
                  size: 37,
                )),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: _header(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.75,
                child: BlocConsumer<RestaurantCubit, RestaurantState>(
                  listener: (context, state) {
                    if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (_, state) {
                    if (state is PageLoaded) {
                      currentState = state;
                      restaurant.addAll(state.restaurants);
                      _updateHeader();
                    }
                    if (currentState == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return _buildListOfRestaurant();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _header() => Container(
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        height: 350.0,
        child: Stack(
          children: [
            BlocBuilder<HeaderBloc, Header>(
              builder: (_, state) => _buildDynamicHeaderinfo(state),
            ),
            Align(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 70),
                child: CustomTextField(
                  hint: "Find Restaurant",
                  fontSize: 14,
                  height: 48,
                  fontWeight: FontWeight.normal,
                  inputAction: TextInputAction.search,
                  onChanged: (val) {},
                  onSubmitted: (query) {
                    if (query.isEmpty) return;
                    widget.adapter.onSearchQuery(context, query);
                  },
                ),
              ),
            )
          ],
        ),
      );

  _buildDynamicHeaderinfo(Header state) => Stack(
        children: [
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image:
                'https://i.picsum.photos/id/225/1500/979.jpg?hmac=jvGoek9ng_Y0GaBbzxN0KJhHaiPtk1VfRcukK8R8FxQ',
            height: 350,
            width: double.infinity,
          ),
          Container(
            color: Theme.of(context).accentColor.withOpacity(.4),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Text(
                state.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.normal),
              ),
            ),
          )
        ],
      );

  void _updateHeader() {
    int indexforlist = currentIndex.toInt();
    var restaurants = restaurant[indexforlist];
    BlocProvider.of<HeaderBloc>(context)
        .update(restaurants.type!, restaurants.displayImgUrl!);
  }

  _buildListOfRestaurant() {
    return Container(
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          if (currentIndex != prevIndex) {
            _updateHeader();
            setState(() {
               prevIndex = currentIndex;
            });
           
          }
          return true;
        },
        child: ListView.builder(
          padding: EdgeInsets.only(top: 40),
          itemBuilder: (context, index) {
            return index >= restaurant.length
                ? bottomLoader()
                : RestaurantListItems(restaurant[index]);
          },
          physics: BouncingScrollPhysics(),
          itemCount: currentState!.nextPage == null
              ? restaurant.length
              : restaurant.length + 1,
          controller: _scrollController,
        ),
      ),
    );
  }
}
