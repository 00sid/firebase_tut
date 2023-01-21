import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project01/UI/posts/post_screen.dart';
import 'package:project01/utils/utils.dart';

import '../../widgets/round_botton.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
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
              title: 'Verify',
              ontap: () async {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: phoneNumberController.text.toString(),
                );
                try {
                  await auth.signInWithCredential(credential);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PostScreen();
                  }));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                }
              })
        ],
      ),
    );
  }
}
