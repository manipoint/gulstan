import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_common/shared_api/http_client_contract.dart';
import 'package:resturent/src/api/restaurant_api.dart';
import 'package:resturent/src/domain/restaurant.dart';

class HttpClient extends Mock implements IHttpClient {}

void main() {
  late RestaurantApi sut;
  late HttpClient client;

  setUp(() {
    client = HttpClient();
    sut = RestaurantApi('baseurl', client);
  });
  group('getAllRestaurants', () {
    test('returns an empty list when no restaurants are found', () async {
      //arrange
      when(client.get(any)).thenAnswer(
          (_) async => HttpResult(jsonEncode({"metadata": {"page":1,"limit":2}
          ,"restaurants":[]}), Status.success));
      //act
      final result = await sut.getAllRestaurants(page: 1,pageSize: 2);
      //assert
      expect(result.restaurants, []);
    });
    test('resturns list of restaurants when success', () async {
      //arrange
      when(client.get(any)).thenAnswer((_) async =>
          HttpResult(jsonEncode(_restaurantsJson()), Status.success));
      //act
      final result = await sut.getAllRestaurants(page: 1,pageSize: 2);
      //assert
      expect(result.restaurants.length, 2);
    });
  });
  group('getRestaurant', () {
    test('returns null when no restaurant is found', () async {
      //arrange
      when(client.get(any)).thenAnswer((_) async => HttpResult(
          jsonEncode({"error": "restaurant were not found"}), Status.failure));
      //act
      final result = await sut.getRestaurant(id: '123445');
      //assert
      expect(result, null);
    });

    test('resturns  restaurant when success', () async {
      //arrange
      when(client.get(any)).thenAnswer(
          (_) async => HttpResult(
            jsonEncode(_restaurantsJson()["restaurants"][0]), Status.success));
      //act
      final result = await sut.getRestaurant(id: '12345');
      //assert
      expect(result, isNotNull);
      expect(result!.id, '12345');
    });
  });
  group('getRestaurantByLocation', () {
    test('returns an empty list when no restaurants are found', () async {
      //arrange
      when(client.get(any)).thenAnswer(
          (_) async => HttpResult(jsonEncode({ "metadata": {"page": 1, "limit": 2},
            "restaurants": []}), Status.success));
      //act
      final result = await sut.getRestaurantByLocation(
          page: 1,pageSize: 2 ,location: Location(longitude: 12.45, latitude: 1233));
      //assert
      expect(result.restaurants, []);
    });
    test('resturns list of restaurants By Location when success', () async {
      //arrange
      when(client.get(any)).thenAnswer((_) async =>
          HttpResult(jsonEncode( _restaurantsJson()), Status.success));
      //act
      final result = await sut.getRestaurantByLocation(
          page: 1,pageSize: 2 ,location: Location(longitude: 345.33, latitude: 345.23));
      //assert
      expect(result.restaurants.length, 2);
    });
  });
  group('findRestaurants', () {
    test('returns an empty list when no restaurants are found', () async {
      //arrange
      when(client.get(any)).thenAnswer(
          (_) async => HttpResult(jsonEncode({  "metadata": {"page": 1, "limit": 2},
            "restaurants": []}), Status.success));
      //act
      final result = await sut.findRestaurant(page: 1,pageSize: 2, searchTerm: 'blass');
      //assert
      expect(result.restaurants, []);
    });
    test('resturns list of restaurants when search success', () async {
      //arrange
      when(client.get(any)).thenAnswer((_) async =>
          HttpResult(jsonEncode(_restaurantsJson()), Status.success));
      //act
      final result =
          await sut.findRestaurant(page: 1,pageSize: 2, searchTerm: 'good food');
      //assert
      expect(result.restaurants.length, 2);
    });
  });

  group('getRestaurantsMenu', () {
    test('returns an empty list when no menu are found', () async {
      //arrange
      when(client.get(any)).thenAnswer(
          (_) async => HttpResult(jsonEncode({"menu": []}), Status.failure));
      //act
      final result = await sut.getRestaurantMenu(restaurantId: '123432');
      //assert
      expect(result, []);
    });
    test('resturns restaurant,s menu when success', () async {
      //arrange
      when(client.get(any)).thenAnswer((_) async =>
          HttpResult(jsonEncode({"menu": _restaurantMenuJson()}), Status.success));
      //act
      final result = await sut.getRestaurantMenu(restaurantId: '12345');
      //assert
      expect(result.length, 1);
      expect(result.first.id, '12345');
    });
  });
}

_restaurantsJson() {
  return {
    "metadata": {"page": 1, "totalPages": 2},
    "restaurants": [
      {
        "id": "12345",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "image_url": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "provence": "Punjab",
          "zone": "Zone"
        }
      },
      {
        "id": "12666",
        "name": "Restuarant Name",
        "type": "Fast Food",
        "imageUrl": "restaurant.jpg",
        "location": {"longitude": 345.33, "latitude": 345.23},
        "address": {
          "street": "Road 1",
          "city": "City",
          "provence": "Kpk",
          "zone": "Zone"
        }
      }
    ]
  };
}
_restaurantMenuJson() {
  return [
    {
      "id": "12345",
      "name": "Lunch",
      "description": "a fun menu",
      "image_url": "menu.jpg",
      "items": [
        {
          "name": "nuff food",
          "description": "awasome!!",
          "image_urls": ["url1", "url2"],
          "unit_price": 12.99
        },
        {
          "name": "nuff food",
          "description": "awasome!!",
          "image_urls": ["url1", "url2"],
          "unit_price": 12.99
        }
      ]
    }
  ];
}