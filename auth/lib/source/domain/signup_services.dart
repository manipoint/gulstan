import 'package:async/async.dart';
import 'package:auth/source/domain/token.dart';

abstract class ISignUpServices {
  Future<Result<Token>> signUp(
    String? name,
    String? email,
    String? password,
  );
}
