// ignore_for_file: file_names
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:ally_mobile/display/Login.dart';
import 'package:ally_mobile/display/VoterDetails.dart';
import 'package:ally_mobile/model/Person.dart';
import 'package:ally_mobile/widgets/DynamicFontSize.dart';
import 'package:ally_mobile/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController search = TextEditingController();
  StreamController _getPersonStream = StreamController.broadcast();
  Future getAllPersonStream(
      {String columnNames = '*',
      String filter = 'ASDSADASDSA324l23kj42k3l423l4DASDSAD',
      // String id = 'f8e9609f-76dc-4ef8-9595-539d52cf2620',
      String city = ''}) async {
    try {
      PersonModel personModel = PersonModel();
      List personData = await personModel.getAllPerson(
          where: filter, city: city, filter: columnNames);
      for (int x = 0; x < personData.length; x++) {
        if (personData[x]['gender'] == null) {
          personData[x]['gender'] = '-';
        }
      }
      // print(personData);
      _getPersonStream.add(personData);
    } catch (e) {
      // ignore: use_build_context_synchronously
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double titleFontSize = DynamicFontSize().calculateFontSize(
        initialWidth: 360,
        initialHeight: 800,
        initialFontSize: 40,
        context: context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Get.to(
            //     () => VoterDetails(
            //           voterData: {},
            //         ),
            //     transition: Transition.cupertino,
            //     duration: const Duration(milliseconds: 250));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Get.off(() => const Login(),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 250));
              },
            ),
          ],
          title: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: 'SEARCH AN ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.blue,
                fontSize: titleFontSize - 10,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'ALLY',
                  style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addPadding(3),
                addSuffixedTextField(
                    labelText: "Search an Ally",
                    borderRadius: 50,
                    maxWidth: width,
                    controller: search,
                    icon: Icons.search_rounded,
                    handleButtonClicked: () async {
                      await getAllPersonStream(filter: search.text);
                    }),
                addPadding(5),
                SizedBox(
                  width: width,
                  height: height * .8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: _getPersonStream.stream,
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return loadingSkeleton(width, height);
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            return Column(
                              children: [
                                for (int i = 0; i < snapshot.data.length; i++)
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          () => VoterDetails(
                                                voterData: snapshot.data[i],
                                              ),
                                          transition: Transition.cupertino,
                                          duration: const Duration(
                                              milliseconds: 250));
                                    },
                                    child: Container(
                                      width: width,
                                      height: 60,
                                      margin: const EdgeInsets.only(bottom: 1),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        color: const Color(0xFFE7EBEF),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: addLabel(
                                              alignment: TextAlign.left,
                                              text:
                                                  "${snapshot.data[i]['last_name']}, ${snapshot.data[i]['first_name']} ${snapshot.data[i]['middle_name']} ",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontColor: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column loadingSkeleton(double width, double height) {
    return Column(
      children: [
        for (int i = 0; i < 5; i++)
          Shimmer.fromColors(
            baseColor: Colors.grey[350]!,
            highlightColor: Colors.white,
            child: Container(
              width: width,
              height: 50,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
