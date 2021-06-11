



import '../domain/menu.dart';

import '../domain/restaurant.dart';

class Mapper {
   static fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      displayImgUrl: json['displayImageUrl'] ?? '',
      location: Location(
        longitude: json['location']['longitude'],
        latitude: json['location']['latitude'],  
      ),
      address: Address(
        street: json['address']['street'],
        city: json['address']['city'],
        provence: json['address']['provence'],
        zone: json['address']['zone'] ?? '',
      ),
    );
  }

  static Menu menuFromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      displayImgUrl: json['image_url'],
      items: json['items'] != null
          ? json['items']
              .map<MenuItem>(
                (item) => MenuItem(
                    name: item['name'],
                    imageUrls: item['imageUrls'],
                    description: item['description'],
                    unitPrice: item['unitPrice']),
              )
              .toList()
          : [],
    );
  }
}