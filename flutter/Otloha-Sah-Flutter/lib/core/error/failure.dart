abstract class Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {}

class SomeThingWentWrongFailure extends Failure {}

class NetworkFailure extends Failure {}

class InvalidDataFailure extends Failure {
  final Map<String, dynamic> _errors;

  InvalidDataFailure(this._errors);

  Map<String, dynamic> get errors => _errors;
}
