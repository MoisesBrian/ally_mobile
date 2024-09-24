// ignore_for_file: file_names
import 'package:ally_mobile/display/Home.dart';
import 'package:ally_mobile/widgets/DynamicFontSize.dart';
import 'package:ally_mobile/widgets/Widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/UserModel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController =
      TextEditingController(text: "refencoder.catanduanes@login.com");
  TextEditingController passwordController =
      TextEditingController(text: "refencoder");
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    supabase.auth.onAuthStateChange.listen((event) async {
      print("Auth event: ${event.event}");
      //get user role
      if (event.event == AuthChangeEvent.signedIn) {
        // if(event.session?.user == null){
        //   return;
        // }
        try {
          isLoading = true;
          User? user = event.session?.user;
          await UserModel().getUserRole(user!).then((value) {
            // print("User role: $value");
            Get.off(() => const Home(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 250));
          });
          isLoading = false;
          // Login.userRole = role!;
        } catch (e) {
          isLoading = false;
          // print("Error: $e");
        }
      }
    });
  }

  Future<void> handleLogin() async {
    try {
      setState(() {
        isLoading = true;
      });
      AuthResponse login = await UserModel().signIn(
          email: emailController.text, password: passwordController.text);
      //CHECK IF LOGIN IS SUCCESSFUL
      print("Login: ${login.session}");
      if (login.session != null) {
        // ignore: use_build_context_synchronously
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Home(),
        //   ),
        // );
      } else {
        // print("Login failed");
      }
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      // print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double titleFontSize = DynamicFontSize().calculateFontSize(
        initialWidth: 360,
        initialHeight: 800,
        initialFontSize: 44,
        context: context);
    double buttonFontSize = DynamicFontSize().calculateFontSize(
        initialWidth: 360,
        initialHeight: 800,
        initialFontSize: 25,
        context: context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                addPadding(30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: 'WELCOME TO\n',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 25,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'ALLIANCE',
                            style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          TextSpan(
                            text: ' TAGGING',
                            style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                    addPadding(15),
                    addTextField(
                      maxWidth: width,
                      controller: emailController,
                      labelText: "Email",
                    ),
                    addPadding(5),
                    addTextField(
                      maxWidth: width,
                      controller: passwordController,
                      labelText: "Password",
                      obscureText: true,
                    ),
                    addPadding(25),
                    Center(
                      child: addElevatedTextButton(
                        maxWidth: width * .5,
                        maxHeight: 50,
                        text: "Login",
                        fontSize: buttonFontSize,
                        isLoading: isLoading,
                        fontWeight: FontWeight.bold,
                        bgColor: Colors.blueAccent,
                        borderRadius: 50,
                        handleOnPress: () async {
                          await handleLogin();
                          // Get.off(() => const Home(),
                          //     transition: Transition.cupertino,
                          //     duration: const Duration(milliseconds: 250));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
