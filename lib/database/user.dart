import 'package:supabase_flutter/supabase_flutter.dart';

class LocalUser{
  String? id;

  LocalUser.fromSupaBase(User user){
    id = user.id;
  }
}