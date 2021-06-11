
import 'package:equatable/equatable.dart';

class Restaurant {
  final String? id;
  final String? name;
  final String? displayImgUrl;
  final String? type;
  final Location? location;
  final Address? address;

  Restaurant({
     this.id,
     this.name,
     this.displayImgUrl,
     this.type,
     this.location,
     this.address,
  });
}

class Location extends Equatable {
  final double? longitude;
  final double? latitude;

  Location({
     this.longitude,
     this.latitude,
  });

  @override
  List<Object?> get props => [longitude, latitude];
}

class Address extends Equatable {
  final String? street;
  final String? city;
  final String? provence;
  final String? zone;

  Address({
     this.street,
     this.city,
     this.provence,
    this.zone,
  });

  @override
  List<Object?> get props => [street, city, provence, zone!];
}
