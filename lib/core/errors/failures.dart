abstract class Failure {
  const Failure();
}

class CacheFailure extends Failure {
  const CacheFailure();
}

class ServerFailure extends Failure {
  const ServerFailure();
}
