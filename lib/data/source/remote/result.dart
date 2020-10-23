import 'package:meta/meta.dart';

@sealed
abstract class Result<T> {
  R whenWithResult<R>(R Function(Success<T>) success,
      R Function(InProgress<T>) inProgress, R Function(Error<T>) error) {
    if (this is Success<T>) {
      return success(this as Success<T>);
    } else if (this is InProgress<T>) {
      return inProgress(this as InProgress<T>);
    } else if (this is Error) {
      return error(this as Error<T>);
    } else {
      throw new Exception('Unhandled result!');
    }
  }
}

class Success<T> extends Result<T> {
  dynamic data;

  Success({this.data});
}

class InProgress<T> extends Result<T> {
  dynamic data;

  InProgress({this.data});
}

class Error<T> extends Result<T> {
  dynamic data;
  Exception error;

  Error({this.data, this.error});
}
