import 'package:firebase_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class EditContactPage extends StatefulWidget {

  final String name;
  final String phone;
  final String email;
  final String avatar;
  final String id;

  const EditContactPage({Key? key, required this.name, required this.phone, required this.email, required this.avatar, required this.id}) : super(key: key);

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;


  void editContact() async{
    if(_formKey.currentState!.validate()){
      try{
        await FirebaseFirestore.instance.collection("contacts").doc(widget.id).update({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
        });

        if(mounted) {
          Navigator.pop(context);
        }
      } on FirebaseException{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to edit contact'))
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.name
    );
    phoneController = TextEditingController(
      text: widget.phone
    );
    emailController = TextEditingController(
      text: widget.email
    );

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
        title: const Text("Edit Contact"),
      ),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          Form(child: Column(
            children: [
              SizedBox(height: 20,),
              Hero(
                tag: widget.id,
                child: Center(child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(widget.avatar),
                )),
              ),
              SizedBox(height: 30,),
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
                readOnly: true,
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
                    onPressed: editContact,
                    icon: const Icon(IconlyBroken.edit_square),
                    label: const Text("Edit Contact")),
              )
            ],
          ),key: _formKey,)
        ],
      ),
    );
  }
}
