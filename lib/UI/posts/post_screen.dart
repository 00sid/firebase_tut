import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:project01/UI/auth/login_screen.dart';
import 'package:project01/UI/posts/add_posts.dart';
import 'package:project01/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editFilter = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: const Text('Post'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: const Text('Loading'),
                  itemBuilder: ((context, snapshot, animation, index) {
                    final title = snapshot.child('Title').value.toString();
                    if (searchFilter.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('Title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: ((context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showMyDiaLog(
                                          title,
                                          snapshot
                                              .child('id')
                                              .value
                                              .toString());
                                    },
                                    leading: Icon(Icons.edit),
                                    title: Text('Edit'),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      ref
                                          .child(snapshot
                                              .child('id')
                                              .value
                                              .toString())
                                          .remove();
                                    },
                                    leading: Icon(Icons.delete),
                                    title: Text('Delete'),
                                  ),
                                ),
                              ]),
                        ),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchFilter.text.toLowerCase().toString())) {
                      return ListTile(
                        title: Text(snapshot.child('Title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    } else {
                      return Container();
                    }
                  })))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddPostsScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDiaLog(String title, String id) async {
    editFilter.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextField(
                controller: editFilter,
                decoration: InputDecoration(
                  hintText: 'edit',
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update(
                      {'Title': editFilter.text.toString()}).then((value) {
                    Utils().toastMessage('Successfully updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }
}
/*Expanded(
              child: StreamBuilder(
            stream: ref.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();

                return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title: Text(list[index]['Title']),
                      );
                    }));
              }
            },
          )),*/