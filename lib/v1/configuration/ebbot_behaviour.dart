class EbbotBehaviour {
  final EbbotBehaviourInput input;
  final bool showContextMenu;
  final EbbotBehaviourMessageThrottling messageThrottling;

  EbbotBehaviour._builder(EbbotBehaviourBuilder builder)
      : input = builder._input,
        showContextMenu = builder._showContextMenu,
        messageThrottling = builder._messageThrottling;
}

class EbbotBehaviourBuilder {
  EbbotBehaviourInput _input = EbbotBehaviourInputBuilder().build();
  bool _showContextMenu = true;
  EbbotBehaviourMessageThrottling _messageThrottling = EbbotBehaviourMessageThrottlingBuilder().build();

  EbbotBehaviourBuilder input(EbbotBehaviourInput input) {
    _input = input;
    return this;
  }

  EbbotBehaviourBuilder showContextMenu(bool show) {
    _showContextMenu = show;
    return this;
  }

  EbbotBehaviourBuilder messageThrottling(EbbotBehaviourMessageThrottling throttling) {
    _messageThrottling = throttling;
    return this;
  }

  EbbotBehaviour build() {
    return EbbotBehaviour._builder(this);
  }
}

class EbbotBehaviourInput {
  EbbotBehaviourInputEnterPressed enterPressed =
      EbbotBehaviourInputEnterPressed.sendMessage;

  EbbotBehaviourInput._builder(EbbotBehaviourInputBuilder builder)
      : enterPressed = builder._enterPressed;
}

class EbbotBehaviourInputBuilder {
  EbbotBehaviourInputEnterPressed _enterPressed =
      EbbotBehaviourInputEnterPressed.sendMessage;

  EbbotBehaviourInputBuilder enterPressed(
      EbbotBehaviourInputEnterPressed enterPressed) {
    _enterPressed = enterPressed;
    return this;
  }

  EbbotBehaviourInput build() {
    return EbbotBehaviourInput._builder(this);
  }
}

enum EbbotBehaviourInputEnterPressed { sendMessage, newline }

class EbbotBehaviourMessageThrottling {
  final bool enabled;
  final Duration delayBetweenMessages;

  EbbotBehaviourMessageThrottling._builder(EbbotBehaviourMessageThrottlingBuilder builder)
      : enabled = builder._enabled,
        delayBetweenMessages = builder._delayBetweenMessages;
}

class EbbotBehaviourMessageThrottlingBuilder {
  bool _enabled = true;
  Duration _delayBetweenMessages = const Duration(milliseconds: 300);

  EbbotBehaviourMessageThrottlingBuilder enabled(bool enabled) {
    _enabled = enabled;
    return this;
  }

  EbbotBehaviourMessageThrottlingBuilder delayBetweenMessages(Duration delay) {
    _delayBetweenMessages = delay;
    return this;
  }

  EbbotBehaviourMessageThrottling build() {
    return EbbotBehaviourMessageThrottling._builder(this);
  }
}
