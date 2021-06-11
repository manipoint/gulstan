import 'package:async/async.dart';
import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:gulstan/cache/local_store_contract.dart';
import 'package:gulstan/models/user.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ILocalStore localStore;
  AuthCubit(this.localStore) : super(IntialState());

  signin(IAuthService authService,AuthType t) async {
    _startLoading();
    final result = await authService.signIn();
    _setResultOfAuthState(result);
  }
    signup(ISignUpServices signUpServices, User user) async{
    _startLoading();
    final result = await signUpServices.signUp(user.name, user.email, user.password);
    _setResultOfAuthState(result);
  }

  signout(IAuthService authService) async {
    _startLoading();
    final token = await localStore.fetch();
    final result = await authService.signOut(token!);
    if (result.asValue!.value) {
      localStore.delete(token);
      emit(SignOutSuccessState());
    } else {
      emit(ErrorState("error siging out"));
    }
  }



  void _startLoading() {
    emit(LoadingState());
  }

  void _setResultOfAuthState(Result<Token> result) {
    if (result.asError != null) {
      emit(ErrorState("Error"));
    } else {
      emit(AuthSuccessState(result.asValue!.value));
    }
  }
}
