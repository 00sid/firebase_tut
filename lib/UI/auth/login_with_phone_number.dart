import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project01/UI/auth/verify_code_screen.dart';
import 'package:project01/utils/utils.dart';
import 'package:project01/widgets/round_botton.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              //  keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter phone number with +977',
                helperText: 'For eg +977 9812345678',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundBotton(
                loading: loading,
                title: 'Login',
                ontap: () {
                  setState(() {
                    loading = true;
                  });
                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumberController.toString(),
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(
                        e.toString(),
                      );
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCodeScreen(
                            verificationId: verificationId,
                          ),
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
