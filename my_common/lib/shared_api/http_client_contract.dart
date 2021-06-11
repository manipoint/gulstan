abstract class IHttpClient {
  Future<HttpResult>? get(String?url, {Map<String, String>? header});
  Future<HttpResult>? post(String? url, String? body,
      {Map<String, String> header});
}

class HttpResult {
  final String data;
  final Status status;

  HttpResult(this.data, this.status);

}
enum Status{success,failure}
