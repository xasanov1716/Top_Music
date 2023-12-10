part of 'user_bloc.dart';

@immutable
abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoadingState extends UserState{
  @override
  List<Object?> get props=> [];
}

class UserErrorState extends UserState{
  final String errorText;
  UserErrorState({required this.errorText});
  @override
  List<Object?> get props=> [errorText];
}
class UserSuccessState extends UserState{
  @override
  List<Object?> get props=> [];
}

class UserAddSuccessState extends UserState{
  @override
  List<Object?> get props=> [];
}
class UserDeleteSuccessState extends UserState{
  @override
  List<Object?> get props=> [];
}
class UserUpdateSuccessState extends UserState{
  @override
  List<Object?> get props=> [];
}