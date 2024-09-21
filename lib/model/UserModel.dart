import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final supabase = Supabase.instance.client;
  Future<AuthResponse> signIn(
      {required String email, required String password}) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  Future<String?> getUserRole(User user) async {
    var response = await supabase
        .from('user_role')
        .select('user_role')
        .eq('user_id', user.id);
    return response[0]['user_role'];
  }
}
