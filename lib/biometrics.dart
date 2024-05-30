import 'package:fintech_vault_app/bankscreen.dart';
import 'package:fintech_vault_app/vault.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Biometrics extends StatefulWidget {
  const Biometrics({Key? key}) : super(key: key);

  @override
  State<Biometrics> createState() => _BiometricsState();
}

class _BiometricsState extends State<Biometrics> {
  late final LocalAuthentication auth;
  bool _supportstate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) =>
        setState(() {
          _supportstate = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_supportstate)
                const Text("Biometrics",style: TextStyle(color: Colors.black,fontSize: 20),)
              else
                const Text("not supported",style: TextStyle(color: Colors.black,fontSize: 20)),
              const SizedBox(height: 100,),
              ElevatedButton(onPressed: _authenticate, child: Text("Tap to Scan"))

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();
    print(availableBiometrics);
    if (!mounted) {
      return;
    }
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate Yourself For Vault',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      print("Authenticated:$authenticated");
      if(authenticated==true){
        Navigator.pushReplacement(context,  PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const /*VaultHome()*/ BankList(),transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },));
      }
    }
    on PlatformException catch(e){
      print(e);
    }
  }
}
