import 'package:supabase_flutter/supabase_flutter.dart';

class TagsModel {
  final supabase = Supabase.instance.client;

  Future saveTags({required String tag_name, required String tag_color}) async {
    Map data = {
      'tag': tag_name,
      'color': tag_color,
    };
    var response = await supabase.from('tag').insert(data).select();
    return response;
  }

  Future getAllTags() async {
    var response = await supabase.from('tag').select();
    return response;
  }

  Future editTag(
      {required String name, required String color, required int id}) async {
    try {
      var response = await supabase.from('tag').update({
        'color': color,
        'tag': name,
      }).match({'id': id}).select();
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }
}
