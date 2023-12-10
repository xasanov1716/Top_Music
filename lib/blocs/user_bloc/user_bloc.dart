import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:top_music/data/models/user_model/user_model.dart';
import 'package:top_music/data/repositories/user_repository.dart';
import 'package:meta/meta.dart';

import '../../data/models/user_model/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<AddUser>(_addUser);
    on<GetUsers>(_getUsers);
    on<DeleteUser>(_deleteUser);
    on<UpdateUser>(_updateUser);
  }

  final UserRepository userRepository;

  List<UserModel> users=[];

  Future<void> _addUser(AddUser event,Emitter<UserState> emit)async{
    emit(UserLoadingState());
    try{
      await userRepository.addUser(userModel: event.userModel);
      emit(UserAddSuccessState());
    }catch(e){
      emit(UserErrorState(errorText: e.toString()));
    }

  }

  Future<void> _getUsers(GetUsers event,Emitter<UserState> emit)async{
    emit(UserLoadingState());
    try{
      users=await userRepository.getUsers();
      emit(UserSuccessState());
    }catch (e){
      emit(UserErrorState(errorText: e.toString()));
    }

  }

  Future<void> _deleteUser(DeleteUser event,Emitter<UserState> emit)async{
    emit(UserLoadingState());
    try{
      await userRepository.deleteUser(id: event.id);
      await userRepository.getUsers();
      emit(UserDeleteSuccessState());
    }catch (e){
      emit(UserErrorState(errorText: e.toString()));
    }

  }

  Future<void> _updateUser(UpdateUser event, Emitter<UserState> emit)async{
    emit(UserLoadingState());
    try{
      await userRepository.updateUser(userModel: event.newUserModel);
      await userRepository.getUsers();
      emit(UserUpdateSuccessState());
    }catch (e){
      emit(UserErrorState(errorText: e.toString()));
    }

  }
}
