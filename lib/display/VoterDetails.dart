// ignore_for_file: file_names, must_be_immutable
import 'package:ally_mobile/model/Person.dart';
import 'package:ally_mobile/model/Tags.dart';
import 'package:ally_mobile/widgets/DynamicFontSize.dart';
import 'package:ally_mobile/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../model/Logs.dart';

class VoterDetails extends StatefulWidget {
  VoterDetails({super.key, required this.voterData});
  Map voterData;
  @override
  State<VoterDetails> createState() => _VoterDetailsState();
}

class _VoterDetailsState extends State<VoterDetails> {
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController precinctNo = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController contactNo = TextEditingController();
  String? selectedMunicipality;
  List<String> municipalityList = [
    "MUNICIPALITY 1",
    "MUNICIPALITY 2",
    "MUNICIPALITY 3",
    "MUNICIPALITY 4",
    "MUNICIPALITY 5",
  ];
  String? selectedBarangay;
  List<String> barangayList = [
    "BARANGAY 1",
    "BARANGAY 2",
    "BARANGAY 3",
    "BARANGAY 4",
    "BARANGAY 5",
  ];
  String? selectedGender;
  List<String> genderList = [
    "MALE",
    "FEMALE",
  ];
  bool isSureVoter = false;
  TextEditingController referedBy = TextEditingController();
  String referedById = "";
  TextEditingController referedByTag = TextEditingController();
  String referedByTagId = "";
  TextEditingController referal = TextEditingController();
  String referalId = "";
  TextEditingController referalTag = TextEditingController();
  String referalTagId = "";

  // Future<void> getReferals() async {
  //   PersonModel personModel = PersonModel();
  //   var personData = await personModel.getPersonNetwork(
  //       id: "${widget.voterData['person_id']}");
  //   // print("PERSON DATA: $personData");
  //   print("PERSON DATA REFERED TO: ${personData.first['reffered_to']}");
  //   print("PERSON DATA REFERED BY: ${personData.first['reffered_by']}");
  // }

  void updateControllers() {
    firstName.text = widget.voterData['first_name'] ?? "";
    middleName.text = widget.voterData['middle_name'] ?? "";
    lastName.text = widget.voterData['last_name'] ?? "";
    precinctNo.text = widget.voterData['precint_no'] ?? "";
    birthDate.text = widget.voterData['birth_date'] ?? "";
    contactNo.text = widget.voterData['contact_no'] ?? "";
    if (municipalityList.contains("${widget.voterData['municipality']}")) {
      selectedMunicipality = widget.voterData['municipality'];
    }
    if (barangayList.contains("${widget.voterData['barangay']}")) {
      selectedBarangay = widget.voterData['barangay'];
    }
    if (widget.voterData['gender'] != null) {
      selectedGender = widget.voterData['gender'] == "M" ? "MALE" : "FEMALE";
    }
    isSureVoter = widget.voterData['sure_or_paid'] != "paid";
  }

  @override
  initState() {
    super.initState();
    updateControllers();
    // getReferals();
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
    double buttonFontSize = DynamicFontSize().calculateFontSize(
        initialWidth: 360,
        initialHeight: 800,
        initialFontSize: 20,
        context: context);
    double namesFontSize = DynamicFontSize().calculateFontSize(
        initialWidth: 360,
        initialHeight: 800,
        initialFontSize: 15,
        context: context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: 'Ally ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.blue,
                fontSize: titleFontSize - 10,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'PROFILE',
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
                addPadding(5),
                RichText(
                  text: TextSpan(
                    text: firstName.text,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: titleFontSize - 10,
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' ${middleName.text[0]}. ${lastName.text}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: titleFontSize - 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // addLabel(
                //     text:
                //         "${firstName.text} ${middleName.text[0]}. ${lastName.text}",
                //     fontSize: titleFontSize - 10,
                //     fontWeight: FontWeight.w600,
                //     fontColor: Colors.black87),
                addPadding(5),
                TypeAheadField(
                  controller: referedBy,
                  suggestionsCallback: (pattern) async {
                    PersonModel personModel = PersonModel();
                    List personData = await personModel.getAllPerson(
                        where: pattern.replaceAll(",", ""),
                        filter: 'person_id, last_name, first_name, middle_name',
                        limit: 10);
                    return personData
                        .where((suggestion) =>
                            suggestion["last_name"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()) ||
                            suggestion["first_name"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()) ||
                            suggestion["middle_name"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  builder: (context, controller, focusNode) {
                    return addTextField(
                        labelText: "Refered By",
                        maxWidth: width,
                        controller: controller,
                        focusNode: focusNode,
                        borderColor: Colors.blueAccent);
                  },
                  itemBuilder: (context, voterData) {
                    return ListTile(
                      title: Text(
                          "${voterData['last_name']}, ${voterData['first_name']} ${voterData['middle_name']}"),
                    );
                  },
                  onSelected: (voterData) {
                    referedBy.text =
                        "${voterData['last_name']}, ${voterData['first_name']} ${voterData['middle_name']}";
                    referedById = "${voterData['person_id']}";
                  },
                ),
                addPadding(3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TypeAheadField(
                      controller: referedByTag,
                      suggestionsCallback: (pattern) async {
                        List tags = await TagsModel().getAllTags();
                        return tags
                            .where((suggestion) => suggestion["tag"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      builder: (context, controller, focusNode) {
                        return addTextField(
                            labelText: "Rerefed By Tag",
                            maxWidth: width * .5,
                            controller: controller,
                            focusNode: focusNode,
                            borderColor: Colors.blueAccent);
                      },
                      itemBuilder: (context, tagData) {
                        return ListTile(
                          title: Text(tagData['tag']),
                        );
                      },
                      onSelected: (tagData) {
                        referedByTag.text = "${tagData['tag']}";
                        referedByTagId = "${tagData['id']}";
                      },
                    ),
                    addElevatedTextButton(
                      maxWidth: width * .4,
                      maxHeight: 45,
                      text: "Confirm Tag",
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      bgColor: Colors.blueAccent,
                      borderRadius: 5,
                      handleOnPress: () async {
                        if ((referedById != '' && referedBy.text != "") &&
                            (referedByTagId != '' && referedByTag.text != "")) {
                          await PersonModel().insertRefferal(
                              refferalList: [
                                {'id': referedById, 'tag': referedByTagId}
                              ],
                              person_id: widget.voterData['person_id'],
                              type: "reffered_by").then((value) async {
                            if (value['status'] == 'success') {
                              LogsModel model = LogsModel(
                                logText:
                                    'Reffered by and reffered to has been added to the person with ID: ${widget.voterData['person_id']}',
                                logType: 'Refferal',
                              );
                              await model.createLog();
                              referedBy.clear();
                              referedByTag.clear();
                              referedById = '';
                              referedByTagId = '';
                              Get.snackbar("Success", "Refferal Added");
                            } else {
                              Get.snackbar("Error", "Refferal not Added");
                            }
                          });
                        } else {
                          Get.snackbar(
                              "Error", "Please select a tag and a person");
                        }
                      },
                    ),
                  ],
                ),
                addPadding(3),
                //REFERED BY TAGS
                Container(
                  width: width,
                  height: 200,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                      future: PersonModel().getPersonNetwork(
                          id: "${widget.voterData['person_id']}"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loadingSkeleton(width, height);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        return Wrap(
                          spacing: 5,
                          runSpacing: 3,
                          children: [
                            for (int i = 0;
                                i < snapshot.data.first['reffered_by'].length;
                                i++)
                              Container(
                                padding: const EdgeInsets.all(5),
                                // margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(int.parse(
                                      "0x${snapshot.data.first['reffered_by'][i]['tag_id']['color']}")),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: addLabel(
                                    text:
                                        "${snapshot.data.first['reffered_by'][i]['reffered_by']['last_name']}, ${snapshot.data.first['reffered_by'][i]['reffered_by']['first_name']} ${snapshot.data.first['reffered_by'][i]['reffered_by']['middle_name']}",
                                    fontSize: namesFontSize,
                                    fontWeight: FontWeight.w500,
                                    fontColor: Colors.white),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                addPadding(3),
                TypeAheadField(
                  controller: referal,
                  suggestionsCallback: (pattern) async {
                    PersonModel personModel = PersonModel();
                    List personData = await personModel.getAllPerson(
                        where: pattern.replaceAll(",", ""),
                        filter: 'person_id, last_name, first_name, middle_name',
                        limit: 10);
                    return personData
                        .where((suggestion) =>
                            suggestion["last_name"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()) ||
                            suggestion["first_name"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()) ||
                            suggestion["middle_name"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  builder: (context, controller, focusNode) {
                    return addTextField(
                        labelText: "Referals",
                        maxWidth: width,
                        controller: controller,
                        focusNode: focusNode,
                        borderColor: Colors.blueAccent);
                  },
                  itemBuilder: (context, voterData) {
                    return ListTile(
                      title: Text(
                          "${voterData['last_name']}, ${voterData['first_name']} ${voterData['middle_name']}"),
                    );
                  },
                  onSelected: (voterData) {
                    referal.text =
                        "${voterData['last_name']}, ${voterData['first_name']} ${voterData['middle_name']}";
                    referalId = "${voterData['person_id']}";
                  },
                ),
                addPadding(3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TypeAheadField(
                      controller: referalTag,
                      suggestionsCallback: (pattern) async {
                        List tags = await TagsModel().getAllTags();
                        return tags
                            .where((suggestion) => suggestion["tag"]
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      builder: (context, controller, focusNode) {
                        return addTextField(
                            labelText: "Rerefal Tag",
                            maxWidth: width * .5,
                            controller: controller,
                            focusNode: focusNode,
                            borderColor: Colors.blueAccent);
                      },
                      itemBuilder: (context, voterData) {
                        return ListTile(
                          title: Text(voterData['tag']),
                        );
                      },
                      onSelected: (voterData) {
                        referalTag.text = voterData['tag'];
                        referalTagId = "${voterData['id']}";
                      },
                    ),
                    addElevatedTextButton(
                      maxWidth: width * .4,
                      maxHeight: 45,
                      text: "Confirm Tag",
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      bgColor: Colors.blueAccent,
                      borderRadius: 5,
                      handleOnPress: () async {
                        if ((referalId != '' && referal.text != "") &&
                            (referalTagId != '' && referalTag.text != "")) {
                          await PersonModel().insertRefferal(
                              refferalList: [
                                {'id': referalId, 'tag': referalTagId}
                              ],
                              person_id: widget.voterData['person_id'],
                              type: "reffered_to").then((value) async {
                            if (value['status'] == 'success') {
                              LogsModel model = LogsModel(
                                logText:
                                    'Reffered by and reffered to has been added to the person with ID: ${widget.voterData['person_id']}',
                                logType: 'Refferal',
                              );
                              await model.createLog();
                              referal.clear();
                              referalTag.clear();
                              referalId = '';
                              referalTagId = '';
                              Get.snackbar("Success", "Refferal Added");
                            } else {
                              Get.snackbar("Error", "Refferal not Added");
                            }
                          });
                        } else {
                          Get.snackbar(
                              "Error", "Please select a tag and a person");
                        }
                      },
                    ),
                  ],
                ),
                addPadding(3),
                //REFERED TO TAGS
                Container(
                  width: width,
                  height: 200,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                      future: PersonModel().getPersonNetwork(
                          id: "${widget.voterData['person_id']}"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loadingSkeleton(width, height);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        return Wrap(
                          spacing: 5,
                          runSpacing: 3,
                          children: [
                            for (int i = 0;
                                i < snapshot.data.first['reffered_to'].length;
                                i++)
                              Container(
                                padding: const EdgeInsets.all(5),
                                // margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(int.parse(
                                      "0x${snapshot.data.first['reffered_to'][i]['tag_id']['color']}")),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: addLabel(
                                    text:
                                        "${snapshot.data.first['reffered_to'][i]['reffered_to']['last_name']}, ${snapshot.data.first['reffered_to'][i]['reffered_to']['first_name']} ${snapshot.data.first['reffered_to'][i]['reffered_to']['middle_name']}",
                                    fontSize: namesFontSize,
                                    fontWeight: FontWeight.w500,
                                    fontColor: Colors.white),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                addPadding(3),
                addTextField(
                  maxWidth: width,
                  controller: firstName,
                  labelText: "First Name",
                ),
                addPadding(3),
                addTextField(
                  maxWidth: width,
                  controller: middleName,
                  labelText: "Middle Name",
                ),
                addPadding(3),
                addTextField(
                  maxWidth: width,
                  controller: lastName,
                  labelText: "Last Name",
                ),
                addPadding(3),
                addTextField(
                  maxWidth: width,
                  controller: precinctNo,
                  labelText: "Precint No",
                ),
                addPadding(3),
                addSuffixedTextField(
                    labelText: "Birth Date",
                    maxWidth: width,
                    controller: birthDate,
                    icon: Icons.date_range_rounded,
                    handleButtonClicked: () async {
                      DateTime? datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(3000),
                      );
                      if (datePicked != null) {
                        birthDate.text = DateFormat('dd-MM-yyyy')
                            .format(datePicked)
                            .toString();
                      }
                    }),
                addPadding(3),
                addStringDropdown(
                  maxWidth: width,
                  labelText: "Municipality",
                  value: selectedMunicipality,
                  listValues: municipalityList,
                  handleOnSelect: (value) {
                    setState(() {
                      selectedMunicipality = value;
                    });
                  },
                ),
                addPadding(3),
                addStringDropdown(
                  maxWidth: width,
                  labelText: "Barangay",
                  value: selectedBarangay,
                  listValues: barangayList,
                  handleOnSelect: (value) {
                    setState(() {
                      selectedBarangay = value;
                    });
                  },
                ),
                addPadding(3),
                addStringDropdown(
                  maxWidth: width,
                  labelText: "Gender",
                  value: selectedGender,
                  listValues: genderList,
                  handleOnSelect: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                addPadding(3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blueAccent,
                          value: isSureVoter,
                          onChanged: (value) {
                            setState(() {
                              isSureVoter = value!;
                            });
                          },
                        ),
                        const Text("Sure Voter")
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.red,
                          value: !isSureVoter,
                          onChanged: (value) {
                            setState(() {
                              isSureVoter = !value!;
                            });
                          },
                        ),
                        const Text("Paid Voter")
                      ],
                    ),
                  ],
                ),
                addPadding(3),
                addElevatedTextButton(
                  maxWidth: width,
                  maxHeight: 45,
                  text: "Save Changes",
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.bold,
                  bgColor: Colors.blueAccent,
                  borderRadius: 50,
                  handleOnPress: () {},
                ),
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
        for (int i = 0; i < 50; i++)
          Shimmer.fromColors(
            baseColor: Colors.grey[350]!,
            highlightColor: Colors.white,
            child: Container(
              width: width,
              height: 30,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
