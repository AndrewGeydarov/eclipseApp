import 'package:easy_stars/easy_stars.dart';
import 'package:eclipse_app/bottom/search/movieInfo_page.dart';
import 'package:eclipse_app/database/favorite/favorite_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BottomFavoritePage extends StatefulWidget {
  const BottomFavoritePage({super.key});

  @override
  State<BottomFavoritePage> createState() => _BottomFavoritePageState();
}

class _BottomFavoritePageState extends State<BottomFavoritePage> {
  final String user_id = Supabase.instance.client.auth.currentUser!.id;
  Favorite_Table favorite_table = Favorite_Table();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Supabase.instance.client
            .from('favorite')
            .stream(primaryKey: ['id'])
            .eq('id_user', user_id),
        builder: (context, snapshotFav) {
          if (!snapshotFav.hasData) {
            return Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          var favorites = snapshotFav.data;

          return ListView.builder(
            itemCount: favorites!.length,
            itemBuilder: (context, indexFav) {
              return StreamBuilder(
                stream: Supabase.instance.client
                    .from('movies')
                    .stream(primaryKey: ['id'])
                    .eq('id', favorites[indexFav]['id_movie']),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  }
                  var movie = snapshot.data;
                  return ListTile(
                    title: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(movie![0]['name']),
                        ),
                        EasyStarsRating(
                          initialRating: movie[0]['stars'].toDouble(),
                        ),
                      ],
                    ),
                    subtitle: Text(movie[0]['description'], maxLines: 3),
                    leading: Image.network(movie[0]['image']),
                    trailing: IconButton(
                      onPressed: () async {
                        await favorite_table.delFavorite(
                          user_id,
                          movie[0]['id'],
                        );
                        setState(() {});
                      },
                      icon: Icon(Icons.bookmark, color: Colors.deepPurple),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => MovieInfoPage(docs: movie[0]),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
