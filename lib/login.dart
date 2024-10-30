import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/common_view_model.dart';
import 'package:qr_attendance/components/app_image.dart';
import 'package:qr_attendance/components/constants.dart';
import 'package:qr_attendance/components/input_container.dart';
import 'package:qr_attendance/request/login_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = new TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isobsecure = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(appLogo, width: 200),
            ),

            const Text(
              '"First BI Integrated School Solution"',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),

            Image.asset(freePikLogin),
            const SizedBox(height: 30),
            InputContainer(
                child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: usernameController,
                    decoration: const InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        hintText: "Username",
                        border: InputBorder.none))),
            InputContainer(
                child: TextField(
                    cursorColor: kPrimaryColor,
                    controller: passwordController,
                    obscureText: _isobsecure,
                    decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                        suffixIcon: IconButton(
                          color: kPrimaryColor,
                          icon: Icon(
                            _isobsecure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isobsecure = !_isobsecure;
                            });
                          },
                        ),
                        hintText: "Password",
                        border: InputBorder.none))),

            Consumer<CommonViewModel>(builder: (context, common, child) {
              return InkWell(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: kPrimaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                onTap: () async {
                  final data = LoginRequest(
                      username: usernameController.text,
                      password: passwordController.text);

                  await common.login(context, data);
                },
              );
            }),

            // ElevatedButton(onPressed: null, child: const Text("abc"),),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
