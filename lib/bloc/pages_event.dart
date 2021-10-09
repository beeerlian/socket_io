part of 'pages_bloc.dart';

abstract class PagesEvent extends Equatable {
  const PagesEvent();
}

class GotoChatPage extends PagesEvent {
  String nickname;
  GotoChatPage(this.nickname);

  @override
  List<Object?> get props => [];
}

class OnLoading extends PagesEvent {
  @override
  List<Object?> get props => [];
}

class GotoJoinPage extends PagesEvent {
  @override
  List<Object?> get props => [];
}
