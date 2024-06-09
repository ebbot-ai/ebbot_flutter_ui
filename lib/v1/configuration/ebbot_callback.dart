class EbbotCallback extends AbstractEbbotCallback {
  final void Function(EbbotInitializationError error) onInitializationError;

  EbbotCallback({
    required this.onInitializationError,
  });

  @override
  void dispatchInitializationError(EbbotInitializationError error) async {
    onInitializationError(error);
  }
}

abstract class AbstractEbbotCallback {
  void dispatchInitializationError(EbbotInitializationError error);
}

class EbbotCallbackBuilder {
  void Function(EbbotInitializationError error) _onInitializationError =
      (error) {};

  EbbotCallbackBuilder onInitializationError(
      void Function(EbbotInitializationError error) onInitializationError) {
    _onInitializationError = onInitializationError;
    return this;
  }

  EbbotCallback build() {
    return EbbotCallback(
      onInitializationError: _onInitializationError,
    );
  }
}

// Error types
enum EbbotInitializationErrorType {
  network,
  initialization,
}

class EbbotInitializationError {
  final EbbotInitializationErrorType type;
  final dynamic cause;
  final StackTrace? stackTrace;
  EbbotInitializationError(this.type, this.cause, this.stackTrace);
}
