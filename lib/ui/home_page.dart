import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/ui/add_contact_page.dart';
import 'package:firebase_app/ui/edit_contact_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final contactsCollection = FirebaseFirestore.instance.collection("contacts").snapshots();

  void deleteContact (String id) async{
    await FirebaseFirestore.instance.collection('contacts').doc(id).delete();
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact Deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Manager'),
      ),
      body: StreamBuilder(
        stream: contactsCollection,
        builder: (context,snapshot){
          if(snapshot.hasData){
            // final List<QueryDocumentSnapshot> document = snapshot.data!.docs;
            final document = snapshot.data!.docs;
            if(document.isEmpty){
              return Center(
                child: Text('No contact yet',style: Theme.of(context).textTheme.headline6)
              );
            }

            return ListView.builder(
              itemCount: document.length,
              itemBuilder: (context,index){
                final contact = document[index].data() as Map<String,dynamic>;
                final contactID = document[index].id;
                final String name = contact['name'];
                final String phone = contact['phone'];
                final String email = contact['email'];
                final String avatar = "https://api.dicebear.com/6.x/avataaars/svg?seed=$name";
                return ListTile(
                  title: Text(name),
                  subtitle: Text('$phone \n$email'),
                  leading: Hero(
                    tag: contactID,
                    child: CircleAvatar(
                      // backgroundImage: NetworkImage(avatar),
                      backgroundImage: NetworkImage('https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditContactPage(
                              name: name,
                              email: email,
                              avatar: 'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                              phone: phone,
                              id: contactID,
                            )));
                          },
                          icon: Icon(IconlyBroken.edit),splashRadius: 24),
                      IconButton(onPressed: (){ deleteContact(contactID);}, icon: Icon(IconlyBroken.delete),splashRadius: 24),
                    ],
                  ),
                );
              },
            );
          }else if(snapshot.hasError){
            return Text("Error");
          }

          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddContactPage(),
            ),
          );
        },
        label: const Text('Add Contact'),
        icon: Icon(IconlyBroken.document),

      ),
    );
  }
}
