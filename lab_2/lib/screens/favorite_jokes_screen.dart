import 'package:flutter/material.dart';
import '../models/joke.dart';

class FavoriteJokesScreen extends StatelessWidget {
  final List<Joke> favoriteJokes;

  const FavoriteJokesScreen({Key? key, required this.favoriteJokes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Jokes")),
      body: favoriteJokes.isEmpty
          ? Center(child: Text("No favorite jokes yet!"))
          : ListView.builder(
        itemCount: favoriteJokes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteJokes[index].setup),
            subtitle: Text(favoriteJokes[index].punchline),
          );
        },
      ),
    );
  }
}
