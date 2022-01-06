import 'package:flutter/material.dart';
import 'package:restaurant_apps/data/model/restaurant.dart';
import 'package:restaurant_apps/navigation.dart';
import 'package:restaurant_apps/ui/detail_screen.dart';

class CardGrid extends StatefulWidget {
  final Restaurant restaurant;

  CardGrid({required this.restaurant});

  @override
  _CardGridState createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigation.intentWithData(DetailScreen.routeName, widget.restaurant);
        });
      },
      child: SizedBox(
        height: 250,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/' +
                      widget.restaurant.pictureId,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurant.name,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Text(
                          widget.restaurant.city,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        ),
                        Text(
                          widget.restaurant.rating.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
