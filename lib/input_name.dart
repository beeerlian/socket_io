import 'package:flutter/material.dart';

class InputNamePage extends StatelessWidget {
  InputNamePage({ Key? key }) : super(key: key);
  TextEditingController nickname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal : 20),
          child: Column(
            children: [
              TextField(
                controller: nickname,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: (){
                Navigator.pushReplacementNamed(context, "/home", arguments: nickname.text);
              }, child: const Text("Join"))
            ],
          ),
        ),
      ),
    );
  }
}