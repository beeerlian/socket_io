import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'pages_event.dart';
part 'pages_state.dart';

class PagesBloc extends Bloc<PagesEvent, PagesState> {
  PagesBloc() : super(PagesInitialState());

  @override
  Stream<PagesState> mapEventToState(PagesEvent event) async*{
    if(event is OnLoading){
      yield LoadingPageState();
    }
    else if(event is GotoChatPage){
      log("Go to chat page");
      yield ChatPageState(event.nickname);
    }
    else if(event is GotoJoinPage){
      yield JoinPageState();
    }
  }
}
