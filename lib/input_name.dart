import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io/bloc/pages_bloc.dart';
import 'package:socket_io/const/const.dart';

class InputNamePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  InputNamePage({Key? key}) : super(key: key);

  @override
  State<InputNamePage> createState() => _InputNamePageState();
}

class _InputNamePageState extends State<InputNamePage> {
  TextEditingController nickname = TextEditingController();
  bool animating = false;

  @override
  void initState() {
    Future.delayed(animatedDuration).then((value) {
      setState(() {
        animating = !animating;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildBackgroundForBody(context),
            _buildMainBody(context),
          ],
        ));
  }

  Widget _buildBackgroundForBody(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var animatedConSize = animating ? width : width / 5;
    return Stack(children: [
      Positioned(
          top: -130,
          left: -170,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: animatedConSize,
            width: animatedConSize,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(width)),
          )),
      Positioned(
          top: -70,
          right: -200,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: animatedConSize,
            width: animatedConSize,
            decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.circular(width)),
          ))
    ]);
  }

  Widget _buildMainBody(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return BlocBuilder<PagesBloc, PagesState>(builder: (context, state) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 20,
              ),
              AnimatedContainer(
                  duration: animatedDuration,
                  width: animating ? width / 1.5 : 10,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: animating ? Colors.white : Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15)),
                  child: animating
                      ? TextField(
                          controller: nickname,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "What is your name?"))
                      : Container()),
              animating
                  ? TextButton(
                      onPressed: () {
                        context
                            .read<PagesBloc>()
                            .add(GotoChatPage(nickname.text));
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Lest Join"),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 30,
                            )
                          ]))
                  : Container()
            ],
          ),
        ),
      );
    });
  }
}
