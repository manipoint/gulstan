
enum AuthType { email, google }

class Credential {
  final AuthType? type;
  final String? name;
  final String? email;
  final String? password;

  Credential(
      {this.type, this.name,  this.email, this.password});
}
