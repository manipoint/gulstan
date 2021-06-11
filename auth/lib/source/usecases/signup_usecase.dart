import 'package:auth/source/domain/signup_services.dart';

import '../domain/token.dart';
import 'package:async/async.dart';
import '../domain/signup_services.dart';

class SignUpUseCase {
  final ISignUpServices _signUpServices;

  SignUpUseCase(this._signUpServices);

  Future<Result<Token>> execute(
    String name,
    String email,
    String password,
  ) async {
    return await _signUpServices.signUp(name, email, password);
  }
}
