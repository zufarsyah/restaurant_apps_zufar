import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_apps/data/api/api_search.dart';
import 'package:restaurant_apps/provider/search_provider.dart';
import 'package:restaurant_apps/widget/card_grid.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/resto_search';
  final String nameRestaurant;
  const SearchScreen({Key? key, required this.nameRestaurant})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Result'),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(
                apiSearch: ApiSearch(query: widget.nameRestaurant)),
            child: DataSearch()));
  }
}

class DataSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildGrid();
  }

  Widget _buildGrid() {
    return Consumer<SearchProvider>(
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
