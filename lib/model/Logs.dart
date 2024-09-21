import 'package:supabase_flutter/supabase_flutter.dart';

class LogsModel {
  final supabase = Supabase.instance.client;
  String logText;
  String logType;

  LogsModel({required this.logText, required this.logType});

  Future getLogs({required DateTime dateFrom, required DateTime dateTo}) async {
    try {
      var response = await supabase
          .from('logs')
          .select()
          .gte('created_at', dateFrom.toIso8601String())
          .lte('created_at', dateTo.toIso8601String())
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future createLog() async {
    try {
      var response = await supabase.from('logs').insert({
        'log_text': logText,
        'log_type': logType,
        'user_id': supabase.auth.currentUser!.id,
      }).select();

      return {'status': 'success', 'message': 'Logs inserted'};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
