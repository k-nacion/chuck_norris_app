abstract class Failure {
  const Failure();
}

class UnableToCacheFailure extends Failure {
  const UnableToCacheFailure();
}

class NoJokeFailure extends Failure {
  const NoJokeFailure();
}

class ServerFailure extends Failure {
  const ServerFailure();
}
