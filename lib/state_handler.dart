import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io/bloc/pages_bloc.dart';
import 'package:socket_io/home.dart';
import 'package:socket_io/input_name.dart';
import 'package:socket_io/loading.dart';

class StateHandler extends StatelessWidget {
  const StateHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (_, state) {
        return Home(nickname: "iu");
      },
    );
  }

  Widget _mapStateToPage(PagesState state) {
    return (state is PagesInitialState)
        ? InputNamePage()
        : (state is ChatPageState)
            ? Home(nickname: state.nickname)
            : (state is JoinPageState)
                ? InputNamePage()
                : const LoadingPage();
  }
}
