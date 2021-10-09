import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io/bloc/pages_bloc.dart';

class InputNamePage extends StatelessWidget {
  InputNamePage({ Key? key }) : super(key: key);
  TextEditingController nickname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nickname,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(onPressed: (){
                    context.read<PagesBloc>().add(GotoChatPage(nickname.text));
                  }, child: const Text("Join"))
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}