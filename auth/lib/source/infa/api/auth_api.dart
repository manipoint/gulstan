import 'dart:convert';

import 'package:auth/source/domain/token.dart';
import '../../domain/credential.dart';
import 'package:async/async.dart';
import '../../infa/api/auth_api_contract.dart';
import 'package:auth/source/infa/api/mapper.dart';
import 'package:http/http.dart' as http;

class AuthApi implements IAuthApi {
  final http.Client _client;
  String baseUrl;

  AuthApi(this.baseUrl, this._client);

  @override
  Future<Result<String>> signIn(Credential credential) async {
    var endpoint = baseUrl + '/auth/signin';
    return await _postCredential(endpoint, credential);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    var endpoint = baseUrl + '/auth/signout';
    var header = {
      "Content-type": "application/json",
      "Authorization": token.value
    };
    var respons = await _client.post(Uri.parse(endpoint), headers: header);
    if (respons.statusCode != 200) return Result.value(false);
    return Result.value(true);
  }

  @override
  Future<Result<String>> signUp(Credential credential) async {
    var endpoint = baseUrl + '/auth/signup';
    return await _postCredential(endpoint, credential);
  }

  Future<Result<String>> _postCredential(
      String endpoint, Credential credential) async {
    var response = await _client.post(Uri.parse(endpoint),
        body: jsonEncode(Mapper.toJson(credential)),
        headers: {"Content-type": "application/json"});

    if (response.statusCode != 200) {
      Map map = jsonDecode(response.body);
      return Result.error(_transformError(map));
    }
    var json = jsonDecode(response.body);

    return json['auth_token'] != null
        ? Result.value(json['auth_token'])
        : Result.error(json['message']);
  }


    _transformError(Map map) {
    var contents = map['error'] ?? map['errors'];
    if (contents is String) return contents;
    var errStr =
        contents.fold('', (prev, ele) => prev + ele.values.first + '\n');
    return errStr.trim();
  }
}
