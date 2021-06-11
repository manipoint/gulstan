import 'package:auth/auth.dart';
import 'package:auth/source/infa/adapters/sign_up_service.dart';
import 'package:auth/source/infa/mangers/auth_mangers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulstan/cache/local_store.dart';
import 'package:gulstan/fake_restaurent_api.dart';
import 'package:gulstan/state_mangment/auth/auth_cubit.dart';
import 'package:gulstan/state_mangment/helpers/header_bloc.dart';
import 'package:gulstan/state_mangment/helpers/main_page_bloc.dart';
import 'package:gulstan/state_mangment/restaurant/restaurant_cubit.dart';
import 'package:gulstan/ui/pages/auth/auth_page_adapter.dart';
import 'package:gulstan/ui/pages/home/home_page_adopter.dart';
import 'package:gulstan/ui/pages/home/restaurant_list_page.dart';
import 'package:gulstan/ui/pages/main/main_page.dart';
import 'package:gulstan/ui/pages/restaurant/restaurant_page.dart';
import 'package:gulstan/ui/pages/search_results/search_result_adapter.dart';
import 'package:gulstan/ui/pages/search_results/search_results_page.dart';
import 'package:http/http.dart' as http;
import 'package:gulstan/cache/local_store_contract.dart';
import 'package:resturent/resturent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/pages/auth/auth_page.dart';

class CompositionRoot {
  static SharedPreferences? _sharedPreferences;
  static ILocalStore? _localStore;
  static String? _baseUrl;
  static http.Client? _client;
  //static RestaurantApi? _api;
  static AuthManager? _manager;
  static IAuthApi? _authApi;
  static FakeRestaurantApi? _api;

  static configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localStore = LocalStore(_sharedPreferences!);
    _client = http.Client();
    _baseUrl = "http://localhost:3000";
   // _api = RestaurantApi(_baseUrl!, _secureClient);
    _api = FakeRestaurantApi(50);
    _authApi = AuthApi(_baseUrl!, _client!);
    _manager = AuthManager(_authApi!);
  }

  static Widget composeAuthUi() {
    AuthCubit _authCubit = AuthCubit(_localStore!);
    ISignUpServices _signupService = SignUpService(_authApi!);
    IAuthPageAdapter _adapter =
        AuthPageAdapter(onUserAuthenticated: composeHomeUi);

    return BlocProvider(
      create: (BuildContext context) => _authCubit,
      child: AuthPage(_manager!, _signupService, _adapter),
    );
  }

  static Future<Widget>? start() async {
    final token = await _localStore!.fetch();
    final authType = await _localStore!.fetchAuthType();
    final service = _manager!.service(authType);
    return token == null ? composeAuthUi() : _composeMainPage(service);
  }

  static Widget composeHomeUi(IAuthService service) {
    RestaurantCubit _restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 20);
    IHomePageAdapter adapter = HomePageAdapter(
         _composeSearchResultsPageWith,
         _composeRestaurantPageWith,
        composeAuthUi);
    AuthCubit _authCubit = AuthCubit(_localStore!);

    return MultiBlocProvider(providers: [
      BlocProvider<RestaurantCubit>(
        create: (BuildContext context) => _restaurantCubit,
      ),
      BlocProvider<HeaderBloc>(
        create: (BuildContext context) => HeaderBloc(),
      ),
      BlocProvider<AuthCubit>(
        create: (BuildContext context) => _authCubit,
      )
    ], child: RestaurantListPage(adapter, service));
  }

//experimental features for using a bottom navigation bar to show different pages
  static Widget _composeMainPage(IAuthService service) {
    final pagesToCompose = [
      () => composeHomeUi(service),
      () => _composeQR(),
      () => _composeSettings()
    ];
    MainPageBloc _mainPageCubit =
        MainPageBloc(pageToCompose: pagesToCompose);
    return BlocProvider<MainPageBloc>(
      create: (BuildContext context) => _mainPageCubit,
      child: MainPage(),
    );
  }

  //experimental features for using a bottom navigation bar to show different pages
  static Widget _composeQR() => Center(child: Text('QR Page'));
  static Widget _composeSettings() => Center(child: Text('Settings Page'));

  static Widget _composeSearchResultsPageWith(String query) {
    RestaurantCubit restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 10);
    ISearchResultsPageAdapter searchResultsPageAdapter =
        SearchResultsPageAdapter(onSelection: _composeRestaurantPageWith);
    return SearchResultPage(restaurantCubit, query, searchResultsPageAdapter);
  }

  static Widget _composeRestaurantPageWith(Restaurant restaurant) {
    RestaurantCubit restaurantCubit =
        RestaurantCubit(_api!, defaultPageSize: 10);
    return RestaurantPage(restaurant, restaurantCubit);
  }
}












// class CompositionRoot {
//   static SharedPreferences? _sharedPreferences;
//   static ILocalStore? _localStore;
//   static String? _baseUrl;
//   static http.Client? _client;
//   static IAuthApi? _authApi;
//   static AuthManager? _manager;
//   static FakeRestaurantApi? _api;

//   static configure() async {
//     _sharedPreferences = await SharedPreferences.getInstance();
//     _localStore = LocalStore(_sharedPreferences);
//     _client = http.Client();
//     _baseUrl = "http://localhost:3000";
//     _api = FakeRestaurantApi(50);
//   }

//   static Widget composeAuthUi() {
//     AuthCubit _authCubit = AuthCubit(_localStore!);
//     ISignUpServices _signupService = SignUpService(_authApi!);
//     IAuthPageAdapter _adapter =
//         AuthPageAdapter(onUserAuthenticated: composeHomeUi);

//     return BlocProvider(
//       create: (BuildContext context) => _authCubit,
//       child: AuthPage(_manager!, _signupService, _adapter),
//     );
//   }

//  static Future<Widget> start() async {
//     final token = await _localStore!.fetch();
//     final authType = await _localStore!.fetchAuthType();
//     final service = _manager!.service(authType);
//     return token ==  null ? composeAuthUi() : _composeMainPage(service);
//   }

//   static Widget composeHomeUi(IAuthService service) {
//     RestaurantCubit _restaurantCubit =
//         RestaurantCubit(_api!, defaultPageSize: 20);
//     IHomePageAdapter adapter = HomePageAdapter(_composeSearchResultsPageWith,
//         _composeRestaurantPageWith, composeAuthUi);
//     AuthCubit _authCubit = AuthCubit(_localStore!);

//     return MultiBlocProvider(providers: [
//       BlocProvider<RestaurantCubit>(
//         create: (BuildContext context) => _restaurantCubit,
//       ),
//       BlocProvider<HeaderBloc>(create: (BuildContext context) => HeaderBloc()),
//       BlocProvider<AuthCubit>(create: (BuildContext context) => _authCubit),
//     ], child: RestaurantListPage(adapter));
//   }

//   static Widget _composeSearchResultsPageWith(String query) {
//     RestaurantCubit restaurantCubit =
//         RestaurantCubit(_api!, defaultPageSize: 10);
//     ISearchResultsPageAdapter searchResultsPageAdapter =
//         SearchResultsPageAdapter(onSelection: _composeRestaurantPageWith);
//     return SearchResultPage(restaurantCubit, query, searchResultsPageAdapter);
//   }

//   static Widget _composeRestaurantPageWith(Restaurant restaurant) {
//     RestaurantCubit restaurantCubit =
//         RestaurantCubit(_api!, defaultPageSize: 10);
//     return RestaurantPage(restaurant, restaurantCubit);
//   }

//   static Widget _composeMainPage(IAuthService service) {
//     final pageToCompose = [
//       () => composeHomeUi(service),
//       () => _composeQR(),
//       () => _composeSetting()
//     ];
//     MainPageBloc _mainPageBloc = MainPageBloc(pageToCompose: pageToCompose);
//     return BlocProvider<MainPageBloc>(
//       create: (BuildContext context) => _mainPageBloc,
//     child: MainPage(),
//     );
//   }

//   static Widget _composeQR() => Center(
//         child: Text('QR Page'),
//       );
//   static Widget _composeSetting() => Center(
//         child: Text('Setting Page'),
//       );
// }
