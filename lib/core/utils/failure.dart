class Failure {
  final String? message;

  const Failure({this.message = "Something went wrong. Please try again."});
}

class SocketFailure extends Failure {
  const SocketFailure(
      {this.message = "Please check your internet connection."});

  @override
  final String? message;
}
