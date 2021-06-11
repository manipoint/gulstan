import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:resturent/resturent.dart';

class RestaurantListItems extends StatelessWidget {
  final Restaurant? restaurant;

  const RestaurantListItems(this.restaurant);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).accentColor,
                blurRadius: 0,
                offset: Offset(5, 5),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                restaurant!.name!,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            FractionallySizedBox(
              widthFactor: .7,
              child: Text(
                "${restaurant!.address!.street!},${restaurant!.address!.city!},${restaurant!.address!.provence!}",
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RatingBarIndicator(
              rating: 4.5,
              itemBuilder: (BuildContext context, int index) => Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 50,
            ),
            Text(
              "4.5",
              style: Theme.of(context).textTheme.headline5,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4.0,
              children: [_createChip('Vegetarian', context),
              _createChip('Vegen', context),],
            )
          ],
        ),
      ),
    );
  }

  _createChip(String label, BuildContext context) {
    return Chip(
      backgroundColor: Colors.black87,
        label: Text(
      label,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
    ));
  }
}
