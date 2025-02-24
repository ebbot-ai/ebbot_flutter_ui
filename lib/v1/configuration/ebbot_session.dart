class EbbotSession {
  String? chatId;

  EbbotSession._builder(EbbotSessionBuilder builder) {
    chatId = builder._chatId;
  }
}

class EbbotSessionBuilder {
  String? _chatId;

  EbbotSessionBuilder chatId(String chatId) {
    _chatId = chatId;
    return this;
  }

  EbbotSession build() {
    return EbbotSession._builder(this);
  }
}
