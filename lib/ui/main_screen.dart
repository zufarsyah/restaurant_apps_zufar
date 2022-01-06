import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/data/api/api_restaurant.dart';
import 'package:restaurant_apps/provider/restaurant_provider.dart';
import 'package:restaurant_apps/ui/favorite_page.dart';
import 'package:restaurant_apps/ui/search_screen.dart';
import 'package:restaurant_apps/ui/settings_page.dart';
import 'package:restaurant_apps/widget/card_grid.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isSearching = false;
  String searchString = "";

  TextEditingController? textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, SettingsPage.routeName);
              });
            },
            icon: const Icon(Icons.settings),
          ),
          title: !isSearching
              ? const Text('Restaurant Apps')
              : TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                      Navigator.pushNamed(context, SearchScreen.routeName,
                          arguments: searchString);
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: const TextStyle(color: Colors.white),
                    icon: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                    ),
                  ),
                ),
          actions: <Widget>[
            !isSearching
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                    icon: const Icon(Icons.search),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        searchString = textEditingController!.text;
                        Navigator.pushNamed(context, SearchScreen.routeName,
                            arguments: searchString);
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
            IconButton(
              onPressed: () {
                setState(() {
                  Navigator.pushNamed(context, FavoritePage.routeName);
                });
              },
              icon: const Icon(Icons.favorite),
            ),
          ],
          centerTitle: !isSearching,
        ),
        body: ChangeNotifierProvider<RestaurantProvider>(
            create: (_) =>
                RestaurantProvider(apiRestaurant: ApiRestaurantList()),
            child: DataRestaurant()));
  }
}

class DataRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildGrid();
  }

  Widget _buildGrid() {
    return Consumer<RestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 250),
            itemCount: state.result.restaurants.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return CardGrid(restaurant: restaurant);
            },
          );
        } else if (state.state == ResultState.NoData) {
          return Center(child: Text(state.message));
        } else if (state.state == ResultState.Error) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
