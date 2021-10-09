part of 'pages_bloc.dart';


abstract class PagesState extends Equatable {
  const PagesState();
}

class PagesInitialState extends PagesState {
  @override
  List<Object?> get props => [];
}

class LoadingPageState extends PagesState {
  @override
  List<Object?> get props => [];
}

class ChatPageState extends PagesState {
  String nickname;
  ChatPageState(this.nickname);
  @override
  List<Object?> get props => [];
}
class JoinPageState extends PagesState {
  @override
  List<Object?> get props => [];
}


