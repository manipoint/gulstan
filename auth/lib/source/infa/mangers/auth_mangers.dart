import 'package:auth/auth.dart';
import 'package:auth/source/infa/adapters/google_auth.dart';

class AuthManager {
  IAuthApi? _api;

  AuthManager(IAuthApi api) {
    this._api = api;
  }
  IAuthService service(AuthType? type) {
    var service;
    switch (type) {
      case AuthType.google:
        service = GoogleAuth(_api!);
        break;
      case AuthType.email:
        service = EmailAuth(_api!);
        break;
      default:
        service = EmailAuth(_api!);
    }
    return service;
  }
}
