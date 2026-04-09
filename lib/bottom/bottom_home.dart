// ignore_for_file: unnecessary_import, unused_import

import 'package:easy_stars/easy_stars.dart';
import 'package:eclipse_app/bottom/search/movieInfo_page.dart';
import 'package:eclipse_app/database/favorite/favorite_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomHomePage extends StatefulWidget {
  const BottomHomePage({super.key});

  @override
  State<BottomHomePage> createState() => _BottomHomePageState();
}

class _BottomHomePageState extends State<BottomHomePage> {
  Favorite_Table favorite_table = Favorite_Table();
  final String user_id = Supabase.instance.client.auth.currentUser!.id;
  List<int> Favs = [];
  int selectedGenre = 3;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final response = await Supabase.instance.client
        .from('favorite')
        .select()
        .eq('id_user', user_id);
    if (response.isEmpty) return;
    for (var element in response) {
      Favs.add(element['id_movie']);
    }
  }

  Widget movieTile(BuildContext context, dynamic docs) {
    return ListTile(
      title: Column(
        children: [
          Container(alignment: Alignment.centerLeft, child: Text(docs['name'])),
          EasyStarsRating(initialRating: docs['stars'].toDouble()),
        ],
      ),
      subtitle: Text(docs['description'], maxLines: 3),
      leading: Image.network(docs['image']),
      trailing: IconButton(
        onPressed: () async {
          if (Favs.contains(docs['id'])) {
            await favorite_table.delFavorite(user_id, docs['id']);
            Favs.remove(docs['id']);
          } else {
            await favorite_table.addFavorite(user_id, docs);
            Favs.add(docs['id']);
          }
          setState(() {});
        },
        icon: Icon(
          Icons.bookmark,
          color: Favs.contains(docs['id']) ? Colors.deepPurple : Colors.grey,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => MovieInfoPage(docs: docs)),
      ),
    );
  }

  Widget GenresButtons(BuildContext context, dynamic docs) {
    return Row(
      verticalDirection: VerticalDirection.up,
      children: [
        ElevatedButton(
          onPressed: () {
            selectedGenre = docs['id'];
            setState(() {});
          },
          style: selectedGenre == docs['id'] ?
          ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              const Color.fromARGB(255, 68, 1, 106)
            ),
            foregroundColor: WidgetStatePropertyAll(
              const Color.fromARGB(255, 220, 138, 235)
            ),
          ) :
           ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              const Color.fromARGB(255, 220, 138, 235),
            ),
            foregroundColor: WidgetStatePropertyAll(
              const Color.fromARGB(255, 68, 1, 106),
            ),
          ),
          child: Text(docs['name']),
        ),
      ],
    );
  }

  Widget CardMovie(BuildContext context, dynamic docs) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          docs['image'],
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        SizedBox(height: 8),
        Text(
          docs['name'],
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MovieInfoPage(docs: docs),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                const Color.fromARGB(255, 243, 174, 255),
              ),
              foregroundColor: WidgetStatePropertyAll(
                const Color.fromARGB(255, 40, 0, 108),
              ),
            ),
            child: Text('Смотреть'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: StreamBuilder(
                stream: Supabase.instance.client
                    .from('movies')
                    .stream(primaryKey: ['id']),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  }
                  var movies = snapshot.data;
                  return PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CardMovie(context, movies[index]),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Сейчас в топе',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            SizedBox(
              height: 40,
              child: StreamBuilder(
                stream: Supabase.instance.client
                    .from('genres')
                    .stream(primaryKey: ['id']),
                builder: (context, snapshotGenres) {
                  if (!snapshotGenres.hasData) {
                    return CircularProgressIndicator(color: Colors.deepPurple);
                  }

                  var genres = snapshotGenres.data;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: genres!.length,
                    separatorBuilder: (context, index) => SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return GenresButtons(context, genres[index]);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            StreamBuilder(
              stream: Supabase.instance.client
                  .from('movies')
                  .stream(primaryKey: ['id']),
              builder: (context, snapshotMovies) {
                if (!snapshotMovies.hasData) {
                  return CircularProgressIndicator(color: Colors.deepPurple);
                }

                var movies = snapshotMovies.data;

                if (selectedGenre != 3) {
                  movies = movies!
                      .where((element) => element['id_genre'] == selectedGenre)
                      .toList();
                }
                return ListView.builder(
                  shrinkWrap: true, // Важно!
                  physics:
                      NeverScrollableScrollPhysics(),
                  itemCount: movies!.length,
                  itemBuilder: (context, index) {
                    return movieTile(context, movies![index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
