import 'package:async/async.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/credential.dart';
import '../../infa/api/auth_api_contract.dart';
import '../../domain/auth_service.dart';
import '../../domain/token.dart';

class GoogleAuth implements IAuthService {
  final IAuthApi _authApi;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;

  GoogleAuth(this._authApi, [GoogleSignIn? googleSignIn])
      : this._googleSignIn =
            googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile']);

  @override
  Future<Result<Token>> signIn() async {
    await _handleGoogleSignIn();
    if (_currentUser == null)
      return Result.error("Failed to signin with google");
    Credential credential = Credential(
        type: AuthType.google,
        email: _currentUser!.email,
        name: _currentUser!.displayName);
    var result = await _authApi.signIn(credential);
    return Result.value(Token(result.asValue!.value));
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    var result = await _authApi.signOut(token);
    if (result.asValue!.value) _googleSignIn.disconnect();
    return result;
  }

  _handleGoogleSignIn() async {
    try {
      _currentUser = (await _googleSignIn.signIn())!;
    } catch (error) {
      print(error.toString());
      return;
    }
  }
}
