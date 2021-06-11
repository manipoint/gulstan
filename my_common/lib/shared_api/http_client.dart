
import 'package:http/http.dart';
import 'package:my_common/shared_api/http_client_contract.dart';


class HttpClientImpl implements IHttpClient {
  final Client _client;

  HttpClientImpl(this._client);

  @override
  Future<HttpResult> get(String? url, {Map<String, String>? header}) async {
    final response = await _client.get(Uri.parse(url!), headers: header);
    return HttpResult(response.body, _setStatus(response));
  }

  @override
  Future<HttpResult> post(String? url, String? body,
      {Map<String, String>? header}) async {
    final response =
        await _client.post(Uri.parse(url!), body: body, headers: header);
    return HttpResult(response.body, _setStatus(response));
  }

  _setStatus(Response response) {
    if (response.statusCode != 200) return Status.failure;
    return Status.success;
  }
}
