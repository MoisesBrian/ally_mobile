import 'package:ally_mobile/model/Logs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonModel {
  final supabase = Supabase.instance.client;

  //insert person
  Future insertPerson({
    required String firstName,
    required String middleName,
    required String lastName,
    required String precint_no,
    required String birthDate,
    required String contactNo,
    required String municipality,
    required String barangay,
    required String gender,
    required String sureOrPaid,
    List refferedBy = const [],
    List refferedTo = const [],
  }) async {
    Map data = {
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'precint_no': precint_no,
      'birth_date': birthDate,
      'contact_no': contactNo,
      'municipality': municipality,
      'barangay': barangay,
      'gender': gender,
      'sure_or_paid': sureOrPaid,
    };
    var response = await supabase.from('person').insert(data).select();
    for (var element in refferedBy) {
      await supabase.from('refferal').insert({
        'reffered_by': element['id'],
        'tag_id': element['tag'],
        'reffered_to': response[0]['person_id'],
      }).select();
    }
    for (var element in refferedTo) {
      await supabase.from('refferal').insert({
        'reffered_by': response[0]['person_id'],
        'tag_id': element['tag'],
        'reffered_to': element['id'],
      }).select();
    }
    return response;
  }

  //insert all refferal List to the person.
  Future<Map> insertRefferal({
    required List refferalList,
    required String person_id,
    required String type,
  }) async {
    //create supabase transaction
    try {
      if (type == 'reffered_by') {
        for (var element in refferalList) {
          await supabase.from('refferal').insert({
            'reffered_by': element['id'],
            'tag_id': element['tag'],
            'reffered_to': person_id,
          }).select();
        }
      }
      if (type == 'reffered_to') {
        for (var element in refferalList) {
          await supabase.from('refferal').insert({
            'reffered_by': person_id,
            'tag_id': element['tag'],
            'reffered_to': element['id'],
          }).select();
        }
      }
      return {'status': 'success', 'message': 'Successfully inserted'};
    } catch (e) {
      //throw error if there is an error
      return {'status': 'error', 'message': e.toString()};
    }
  }

  void deleteRefferal({required String refferalID}) async {
    Get.dialog(const Center(child: CircularProgressIndicator()));
    await supabase.from('refferal').delete().eq('id', refferalID);
    LogsModel(
            logText: 'USER DELETED REFFERAL ON $refferalID', logType: 'DELETE')
        .createLog();
    Get.back();
    Get.snackbar('Success', 'Refferal Deleted');
  }

  Future updatebDate() async {
    final defaultValue = '01-01-2000';
    // var response = await supabase
    //     .from('person')
    //     .update({'birth_date': defaultValue}).eq('birth_date', null);
    var response =
        await supabase.from('person').select('*').is_('birth_date', null);

    // final updateResponse = await supabase.from('person').update({
    //   'birth_date': defaultValue
    // }).eq(
    //     'person_id',
    //     response[element]
    //         ['person_id']); // Update rows where id is in the retrieved IDs
    for (int x = 0; x < response.toString().length; x++) {
      // print(response[x]['person_id']);
    }
    return response;
  }

  Future getTags() async {
    var response = await supabase.from('tag').select('*');

    return response;
  }

  Future getTagsByID({required String where}) async {
    var response = await supabase.from('tag').select('*').eq('id', where);

    return response;
  }

  Future getAllPerson(
      {String filter = '*',
      String where = '',
      String id = '',
      String city = '',
      int limit = 100}) async {
    //get reffered_by query
    String refferedByQuery =
        "refferal!refferal_reffered_to_fkey(reffered_by(person_id,first_name, middle_name, last_name),tag_id(color,tag)) as reffered_by";
    var response = supabase.from('person').select('$filter, $refferedByQuery').or(
        'first_name.ilike.%$where%, last_name.ilike.%$where%, middle_name.ilike.%$where%');
    if (id != '') {
      response = response.or('person_id.eq.$id');
    }
    return await response;
  }

  // Future getStatistics({required String city}) async {
  //   var response = await supabase
  //       .from('person')
  //       .select('*', const FetchOptions(count: CountOption.exact))
  //       .eq('municipality', city);
  //   print(response.count);
  //   return response;
  // }

  Future getStatistics({required String city}) async {
    var response = await supabase
        .from('person')
        .select('*')
        .eq('municipality', city)
        .limit(50);
    print(response);
    return response;
  }

  Future getReferredPerson({required String personID}) async {
    String refferedByQuery =
        "refferal!refferal_reffered_to_fkey(reffered_by(*),tag_id(color,tag)) as reffered_by";
    var response = supabase
        .from('person')
        .select(refferedByQuery)
        .eq('person_id', personID);

    return await response;
  }

  Future getReferredBy({required String personID}) async {
    String refferedByQuery =
        "refferal!refferal_reffered_to_fkey(reffered_by(*),tag_id(color,tag)) as reffered_to";
// Query the refferal table to get the reffered_by IDs
    var refferalResponse = await supabase
        .from('refferal')
        .select('reffered_to')
        .eq('reffered_by', personID);

    print(refferalResponse);

// Extract the reffered_by IDs from the response
    var refferedByIDs =
        refferalResponse.map((item) => item['reffered_to']).toList();

// Query the person table for each reffered_by ID
    var personResponses = <dynamic>[];
    for (var id in refferedByIDs) {
      var personResponse = await supabase
          .from('person')
          .select('*,$refferedByQuery')
          .eq('person_id', id);
      personResponses.add(personResponse[0]);
    }
    print(personResponses);
    return personResponses;
  }

  Future getPersonById({required String id}) async {
    var response =
        await supabase.from('person').select('*').eq('person_id', id);
    return response;
  }

  Future getPersonUpline({required String id}) async {
    var response = await supabase
        .from('refferal')
        .select('tag(*),reffered_by(*)')
        .eq('reffered_to', id);
    return response;
  }

  Future getPersonDownline({required String id}) async {
    var response = await supabase
        .from('refferal')
        .select('tag(*),reffered_to(*)')
        .eq('reffered_by', id);
    return response;
  }

  Future getPersonNetwork({required String id}) async {
    String refferedByQuery =
        "refferal!refferal_reffered_to_fkey(reffered_by(first_name, middle_name, last_name),tag_id(color,tag),id) as reffered_by";
    String refferedToQuery =
        "refferal!refferal_reffered_by_fkey(reffered_to(first_name, middle_name, last_name),tag_id(color,tag),id) as reffered_to";

    var refferedByResponse = await supabase
        .from('person')
        .select('*,$refferedByQuery')
        .eq('person_id', id);

    var refferedToResponse = await supabase
        .from('person')
        .select(refferedToQuery)
        .eq('person_id', id);
    //combine the response
    var combinedResponse = [
      {
        'person_data': refferedByResponse.first,
        'reffered_by': refferedByResponse.first['refferal'],
        'reffered_to': refferedToResponse.first['refferal'],
      }
    ];
    return combinedResponse;
  }
}

extension on PostgrestFilterBuilder<PostgrestList> {
  is_(String s, param1) {}
}
