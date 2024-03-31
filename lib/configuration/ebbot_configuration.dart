import 'package:ebbot_dart_client/configuration/environment_config.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class EbbotConfiguration {
  final ChatTheme theme;
  final Environment
      environment; // This lives in the ebbot_dart_client package for now

  EbbotConfiguration._builder(EbbotConfigurationBuilder builder)
      : theme = builder._theme,
        environment = builder._environment;

  factory EbbotConfiguration(EbbotConfigurationBuilder builder) {
    return EbbotConfiguration._builder(builder);
  }
}

class EbbotConfigurationBuilder {
  ChatTheme _theme = const DefaultChatTheme();
  Environment _environment = Environment.staging; // Default to staging

  EbbotConfigurationBuilder theme(ChatTheme theme) {
    _theme = theme;
    return this;
  }

  EbbotConfigurationBuilder environment(Environment env) {
    _environment = env;
    return this;
  }

  EbbotConfiguration build() {
    return EbbotConfiguration._builder(this);
  }
}
