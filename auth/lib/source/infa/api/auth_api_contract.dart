import '../../domain/token.dart';

import '../../domain/credential.dart';
import 'package:async/async.dart';

// Auth interface 
abstract class IAuthApi {
  Future<Result<String>> signIn(Credential credential);
  Future<Result<String>> signUp(Credential credential);
  Future<Result<bool>> signOut(Token token);
}
