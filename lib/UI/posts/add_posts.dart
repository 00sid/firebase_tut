import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project01/utils/utils.dart';
import 'package:project01/widgets/round_botton.dart';

class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key});

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Post',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "What's in your mind",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundBotton(
              loading: loading,
              title: 'Add',
              ontap: () {
                setState(() {
                  loading = true;
                });

                String id = DateTime.now().microsecondsSinceEpoch.toString();
                databaseRef.child(id).set({
                  'id': id,
                  'Title': postController.text.toString()
                }).then((value) {
                  Utils().toastMessage('Post Added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
