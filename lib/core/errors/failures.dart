abstract class Failure {
  const Failure(this.message);

  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class HardFailure extends Failure {
  const HardFailure(String message) : super(message);
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(String message) : super(message);
}
