// ignore_for_file: file_names
import 'package:ally_mobile/widgets/DynamicFontSize.dart';
import 'package:ally_mobile/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class VoterDetails extends StatefulWidget {
  const VoterDetails({super.key});

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
  TextEditingController referedByTag = TextEditingController();
  TextEditingController referal = TextEditingController();
  TextEditingController referalTag = TextEditingController();
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
              children: [
                addPadding(5),
                TypeAheadField(
                  controller: referedBy,
                  suggestionsCallback: (pattern) async {
                    List<Map<String, dynamic>> list = [
                      {"name": "John Doe", "description": "Voter"},
                      {"name": "Jane Doe", "description": "Voter"},
                      {"name": "John Smith", "description": "Voter"},
                      {"name": "Jane Smith", "description": "Voter"},
                    ];
                    return list
                        .where((suggestion) => suggestion["name"]
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
                      title: Text(voterData['name']),
                    );
                  },
                  onSelected: (voterData) {
                    referedBy.text = voterData['name'];
                  },
                ),
                addPadding(3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TypeAheadField(
                      controller: referedByTag,
                      suggestionsCallback: (pattern) async {
                        List<Map<String, dynamic>> list = [
                          {"tag": "Barkada", "id": "Voter"},
                          {"tag": "Kapatid", "id": "Voter"},
                          {"tag": "Tito", "id": "Voter"},
                          {"tag": "Katrabaho", "id": "Voter"},
                        ];
                        return list
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
                      itemBuilder: (context, voterData) {
                        return ListTile(
                          title: Text(voterData['tag']),
                        );
                      },
                      onSelected: (voterData) {
                        referedByTag.text = voterData['tag'];
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
                      handleOnPress: () {},
                    ),
                  ],
                ),
                addPadding(3),
                //REFERED BY TAGS
                Container(
                  width: width,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                addPadding(3),
                TypeAheadField(
                  controller: referal,
                  suggestionsCallback: (pattern) async {
                    List<Map<String, dynamic>> list = [
                      {"name": "John Doe", "description": "Voter"},
                      {"name": "Jane Doe", "description": "Voter"},
                      {"name": "John Smith", "description": "Voter"},
                      {"name": "Jane Smith", "description": "Voter"},
                    ];
                    return list
                        .where((suggestion) => suggestion["name"]
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
                      title: Text(voterData['name']),
                    );
                  },
                  onSelected: (voterData) {
                    referal.text = voterData['name'];
                  },
                ),
                addPadding(3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TypeAheadField(
                      controller: referalTag,
                      suggestionsCallback: (pattern) async {
                        List<Map<String, dynamic>> list = [
                          {"tag": "Barkada", "id": "Voter"},
                          {"tag": "Kapatid", "id": "Voter"},
                          {"tag": "Tito", "id": "Voter"},
                          {"tag": "Katrabaho", "id": "Voter"},
                        ];
                        return list
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
                      handleOnPress: () {},
                    ),
                  ],
                ),
                addPadding(3),
                Container(
                  width: width,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
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
}
