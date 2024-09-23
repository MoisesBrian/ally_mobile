// ignore_for_file: file_names

import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final supabase = Supabase.instance.client;
  static String role = '';
  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  Future<void> getUserRole(User user) async {
    var response = await supabase
        .from('user_role')
        .select('user_role')
        .eq('user_id', user.id);
    print(response);
    UserModel.role = response[0]['user_role'];
  }
}
