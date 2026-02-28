import 'package:supabase_flutter/supabase_flutter.dart';

class UserTable {
  final Supabase supabase = Supabase.instance;

  Future<void> addUserTable(
    String fullname,
    String email,
    String password,
    String gender,
    String date,
    String avatar,
  ) async {
    try {
      await supabase.client.from('users').insert({
        'full_name': fullname,
        'email': email,
        'password': password,
        'birth_date': date,
        'gender': gender,
        'avatar': 'https://kpvbppodktqilevinrki.supabase.co/storage/v1/object/public/EclipseBucket/default-avatar.jpeg',
      });

      print('ДОБАВЛЕН ПОЛЬЗОВАТЕЛЬ'); 
    } catch (e) {
      return;
    }
  }

  Future<void> updateImage(String url, String id_user) async{
    try {
      await supabase.client.from('users').update({'avatar': url}).eq('id', id_user);
    } catch (e) {
      return;
    }
  }
}
