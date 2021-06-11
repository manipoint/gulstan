import './token.dart';
import 'package:async/async.dart';

abstract class IAuthService {
  // the auth services provide authntication from google or email
  Future<Result<Token>> signIn();
  Future<Result<bool>> signOut(Token token);
}
