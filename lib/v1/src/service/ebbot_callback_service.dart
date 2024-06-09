import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';

class EbbotCallbackService {
  final EbbotCallback _callback;
  EbbotCallbackService(this._callback);

  void dispatchInitializationError(EbbotInitializationError error) {
    _callback.dispatchInitializationError(error);
  }
}
