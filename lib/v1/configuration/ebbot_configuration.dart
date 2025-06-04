import 'package:ebbot_dart_client/valueobjects/environment.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_chat.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_log_configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_session.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_user_configuration.dart';
import 'package:ebbot_flutter_ui/v1/controller/ebbot_api_controller.dart';

class EbbotConfiguration {
  final Environment
      environment; // This lives in the ebbot_dart_client package for now
  final EbbotUserConfiguration userConfiguration;
  final EbbotBehaviour behaviour;
  final EbbotCallback callback;
  final EbbotApiController apiController;
  final EbbotLogConfiguration logConfiguration;
  final EbbotChat chat;
  final EbbotSession session;

  EbbotConfiguration._builder(EbbotConfigurationBuilder builder)
      : environment = builder._environment,
        userConfiguration = builder._userConfiguration,
        behaviour = builder._behaviour,
        callback = builder._callback,
        apiController = builder._apiController,
        logConfiguration = builder._logConfiguration,
        chat = builder._chat,
        session = builder._session;

  factory EbbotConfiguration(EbbotConfigurationBuilder builder) {
    return EbbotConfiguration._builder(builder);
  }
}

class EbbotConfigurationBuilder {
  Environment _environment = Environment.staging; // Default to staging
  EbbotUserConfiguration _userConfiguration =
      EbbotUserConfigurationBuilder().build();
  EbbotBehaviour _behaviour = EbbotBehaviourBuilder().build();
  EbbotCallback _callback = EbbotCallbackBuilder().build();
  EbbotApiController _apiController = EbbotApiController();
  EbbotLogConfiguration _logConfiguration =
      EbbotLogConfigurationBuilder().build();
  EbbotChat _chat = EbbotChatBuilder().build();
  EbbotSession _session = EbbotSessionBuilder().build();

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

  EbbotConfigurationBuilder logConfiguration(
      EbbotLogConfiguration logConfiguration) {
    _logConfiguration = logConfiguration;
    return this;
  }

  EbbotConfigurationBuilder chat(EbbotChat chat) {
    _chat = chat;
    return this;
  }

  EbbotConfigurationBuilder session(EbbotSession session) {
    _session = session;
    return this;
  }

  EbbotConfiguration build() {
    return EbbotConfiguration._builder(this);
  }
}
