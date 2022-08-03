import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<ReturnType, ParamType> {
  const UseCase();

  Future<Either<Failure, ReturnType>> call(ParamType param);
}
