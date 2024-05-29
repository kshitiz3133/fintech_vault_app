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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to VAULT'),
      ),
      body: a
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        "+91",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _phoneController,
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
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
                    child: Text('Login'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              a = true;
                            });
                          },
                          icon: Icon(Icons.arrow_back)),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          controller: _otpController,
                          decoration: InputDecoration(labelText: 'Enter OTP'),
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
            ),
    );
  }

  Future<void> sendotp() async {
    var url = Uri.parse('${BaseUrl.baseUrl}/auth/sendotp');
    var body = json.encode({"mobileNumber": "+91${_phoneController.text}"});

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print('Response status: ${response.statusCode}');
    setState(() {
      a = false;
    });
    if (response.statusCode == 404) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          builder: (context) => const SizedBox(
            height: 100,
            child: Center(child: Text("OTP Sent!")),
          ),
        );
      });
    }
    print('Response body: ${response.body}');
  }

  Future<void> verify() async {
    var url = Uri.parse('${BaseUrl.baseUrl}/auth/verifyotp');
    var body = json.encode({
      "mobileNumber": "+91${_phoneController.text}",
      "otp": "${_otpController.text}"
    });

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const StartAnimation()));
  }
}
