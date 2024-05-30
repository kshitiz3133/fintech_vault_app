import 'dart:convert';
import 'package:fintech_vault_app/startanimation.dart';
import 'package:http/http.dart' as http;
import 'package:fintech_vault_app/Util/baseurl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool a = true;
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD5D5D5),
      body: a
          ? SingleChildScrollView(
            child: Center(
                    child: Container(
            width: 300,
            decoration: BoxDecoration(color: Color(0xffD5D5D5),borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100,),
                  SizedBox(height: 100,child: Image.asset("asstes/vault.png")),
                  SizedBox(height: 20,),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "+91",
                            style: TextStyle(fontSize: 20,color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 180,
                            child: TextField(
                              controller: _phoneController,
                              decoration:
                              InputDecoration(labelText: 'Phone Number',labelStyle: TextStyle(color: Colors.black)),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            enterNumber();
                          });
                        },
                        child: Text('Login',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                  SizedBox(height: 100,),
                  SizedBox(height: 100,),
                ],
              ),
            ),
                    ),
                  ),
          )
          : SingleChildScrollView(
            child: Center(
                    child: Container(
            width: 300,
            decoration: BoxDecoration(color: Color(0xffD5D5D5),borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100,),
                  SizedBox(height: 100,child: Image.asset("asstes/vault.png")),
                  SizedBox(height: 20,),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  a = true;
                                });
                              },
                              icon: Icon(Icons.arrow_back,color: Colors.black,)),
                          SizedBox(
                            width: 180,
                            child: TextField(
                              controller: _otpController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(labelText: 'Enter OTP',labelStyle: TextStyle(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            enterOtp();
                          },
                          child: Text('Verify'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100,),
                  SizedBox(height: 100,),
                ],
              ),
            ),
                    ),
                  ),
          ),
    );
  }

  Future<void> sendotp() async {
    var url = Uri.parse('${BaseUrl.baseUrl}/auth/sendotp');
    var body = json.encode({"mobileNumber": "+91${_phoneController.text}"});

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      if (response.body == "An OTP has been sent to your mobile number") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showModalBottomSheet(
            context: context,
            builder: (context) => const SizedBox(
              height: 100,
              child: Center(child: Text("OTP Sent!")),
            ),
          );
        });
        setState(() {
          a = false;
        });
        print('Error: ${response.body}');
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showModalBottomSheet(
            context: context,
            builder: (context) => const SizedBox(
              height: 100,
              child: Center(child: Text("Please Enter a Valid Number",style: TextStyle(fontSize: 18),)),
            ),
          );
        });
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  Future<void> verify() async {
    var url = Uri.parse('${BaseUrl.baseUrl}/auth/verifyotp');
    var body = json.encode({
      "mobileNumber": "+91${_phoneController.text}",
      "otp": "${_otpController.text}"
    });

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          check = true;
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showModalBottomSheet(
            context: context,
            builder: (context) => const SizedBox(
              height: 100,
              child: Center(child: Text("Enter Correct OTP")),
            ),
          );
        });
      }
    } catch (e) {
      print("Error verifying OTP: $e");
    }
  }

  Future<void> enterNumber() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    await sendotp();
    Navigator.of(context).pop();
  }

  Future<void> enterOtp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    await verify();
    Navigator.of(context).pop();
    check?Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const StartAnimation())):print("error");

  }
}
