import 'package:firebase_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}


// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /{document=**} {
//       allow read, write: if request.auth != null;
//     }
//   }
// }

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();


  void addContact() async{
    if(_formKey.currentState!.validate()){
      try{
        await FirebaseFirestore.instance.collection("contacts").add({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
        });

        if(mounted) {
          Navigator.pop(context);
        }
      } on FirebaseException catch (e) {
        // print('Failed with error code: ${e.code}');
        // print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add contact'))
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields'))
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
      ),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          Form(child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Name',contentPadding: inputPadding
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nameController,
                textInputAction: TextInputAction.next,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a phone number";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Phone",
                  contentPadding: inputPadding,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter an email";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: "Email",
                  contentPadding: inputPadding,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton.icon(
                    onPressed: addContact,
                    icon: const Icon(IconlyBroken.add_user),
                    label: const Text("Save")),
              )
            ],
          ),key: _formKey,)
        ],
      ),
    );
  }
}
