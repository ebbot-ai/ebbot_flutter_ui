import 'package:ebbot_dart_client/valueobjects/environment.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_user_configuration.dart';
import 'package:ebbot_flutter_ui/v1/controller/ebbot_api_controller.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class EbbotConfiguration {
  final ChatTheme theme;
  final Environment
      environment; // This lives in the ebbot_dart_client package for now
  final EbbotUserConfiguration userConfiguration;
  final EbbotBehaviour behaviour;
  final EbbotCallback callback;
  final EbbotApiController apiController;

  EbbotConfiguration._builder(EbbotConfigurationBuilder builder)
      : theme = builder._theme,
        environment = builder._environment,
        userConfiguration = builder._userConfiguration,
        behaviour = builder._behaviour,
        callback = builder._callback,
        apiController = builder._apiController;

  factory EbbotConfiguration(EbbotConfigurationBuilder builder) {
    return EbbotConfiguration._builder(builder);
  }
}

class EbbotConfigurationBuilder {
  ChatTheme _theme = const DefaultChatTheme();
  Environment _environment = Environment.staging; // Default to staging
  EbbotUserConfiguration _userConfiguration =
      EbbotUserConfigurationBuilder().build();
  EbbotBehaviour _behaviour = EbbotBehaviourBuilder().build();
  EbbotCallback _callback = EbbotCallbackBuilder().build();
  EbbotApiController _apiController = EbbotApiController();

  EbbotConfigurationBuilder theme(ChatTheme theme) {
    _theme = theme;
    return this;
  }

  EbbotConfigurationBuilder environment(Environment env) {
    _environment = env;
    return this;
  }

  EbbotConfigurationBuilder behaviour(EbbotBehaviour behaviour) {
    _behaviour = behaviour;
    return this;
  }

  EbbotConfigurationBuilder userConfiguration(
      EbbotUserConfiguration userConfiguration) {
    _userConfiguration = userConfiguration;
    return this;
  }

  EbbotConfigurationBuilder callback(EbbotCallback callback) {
    _callback = callback;
    return this;
  }

  EbbotConfigurationBuilder apiController(EbbotApiController apiController) {
    _apiController = apiController;
    return this;
  }

  EbbotConfiguration build() {
    return EbbotConfiguration._builder(this);
  }
}
