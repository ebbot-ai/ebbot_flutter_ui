class EbbotBehaviour {
  final EbbotBehaviourInput input;
  final bool showContextMenu;

  EbbotBehaviour._builder(EbbotBehaviourBuilder builder)
      : input = builder._input,
        showContextMenu = builder._showContextMenu;
}

class EbbotBehaviourBuilder {
  EbbotBehaviourInput _input = EbbotBehaviourInputBuilder().build();
  bool _showContextMenu = true;

  EbbotBehaviourBuilder input(EbbotBehaviourInput input) {
    _input = input;
    return this;
  }

  EbbotBehaviourBuilder showContextMenu(bool show) {
    _showContextMenu = show;
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
