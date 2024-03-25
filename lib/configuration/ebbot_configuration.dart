import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class EbbotConfiguration {
  final ChatTheme theme;

  EbbotConfiguration._builder(EbbotConfigurationBuilder builder)
      : theme = builder._theme;

  factory EbbotConfiguration(EbbotConfigurationBuilder builder) {
    return EbbotConfiguration._builder(builder);
  }
}

class EbbotConfigurationBuilder {
  ChatTheme _theme = const DefaultChatTheme();

  EbbotConfigurationBuilder theme(ChatTheme theme) {
    _theme = theme;
    return this;
  }

  EbbotConfiguration build() {
    return EbbotConfiguration._builder(this);
  }
}