import 'package:supabase_flutter/supabase_flutter.dart';

class Favorite_Table {
  final Supabase supabase = Supabase.instance;

  Future<void> addFavorite(String userId, dynamic docs) async {
    try {
      await supabase.client.from('favorite').insert({
        'id_user': userId,
        'id_movie': docs['id'],
      });
    } catch (e) {
      return;
    }
  }

  Future<void> delFavorite(String userId, int movieId) async {
    try {
      await supabase.client.from('favorite').delete().match({
        'id_user': userId,
        'id_movie': movieId,
      });
    } catch (e) {
      return;
    }
  }
}
