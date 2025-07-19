import 'package:ebbot_dart_client/valueobjects/environment.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_behaviour.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_callback.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_chat.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_log_configuration.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_session.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_user_configuration.dart';
import 'package:ebbot_flutter_ui/v1/controller/ebbot_api_controller.dart';

/// Main configuration class for the Ebbot Flutter UI widget.
/// 
/// This class holds all the configuration options for customizing the behavior,
/// appearance, and functionality of the Ebbot chat widget.
/// 
/// Example usage:
/// ```dart
/// final config = EbbotConfigurationBuilder()
///   .environment(Environment.production)
///   .userConfiguration(
///     EbbotUserConfigurationBuilder()
///       .userAttributes({'userId': '123', 'name': 'John'})
///       .build()
///   )
///   .behaviour(
///     EbbotBehaviourBuilder()
///       .showContextMenu(true)
///       .build()
///   )
///   .build();
/// ```
class EbbotConfiguration {
  /// The Ebbot environment to connect to (staging, production, etc.)
  final Environment environment;
  
  /// Configuration for user attributes and identification
  final EbbotUserConfiguration userConfiguration;
  
  /// Configuration for chat behavior and UI settings
  final EbbotBehaviour behaviour;
  
  /// Configuration for event callbacks and handlers
  final EbbotCallback callback;
  
  /// API controller for programmatic chat control
  final EbbotApiController apiController;
  
  /// Configuration for logging settings
  final EbbotLogConfiguration logConfiguration;
  
  /// Configuration for chat-specific settings
  final EbbotChat chat;
  
  /// Configuration for session management and recovery
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

/// Builder class for creating [EbbotConfiguration] instances.
/// 
/// This builder provides a fluent interface for configuring all aspects
/// of the Ebbot chat widget. Use this class to customize the chat behavior,
/// appearance, callbacks, and other settings.
/// 
/// Example usage:
/// ```dart
/// final config = EbbotConfigurationBuilder()
///   .environment(Environment.production)
///   .userConfiguration(
///     EbbotUserConfigurationBuilder()
///       .userAttributes({'userId': '123'})
///       .build()
///   )
///   .callback(
///     EbbotCallbackBuilder()
///       .onMessage((message) => print('New message: $message'))
///       .build()
///   )
///   .build();
/// ```
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

  /// Sets the Ebbot environment to connect to.
  /// 
  /// Available environments include staging, production, and various regional deployments.
  /// Defaults to [Environment.staging] if not specified.
  /// 
  /// Example:
  /// ```dart
  /// builder.environment(Environment.production)
  /// ```
  EbbotConfigurationBuilder environment(Environment env) {
    _environment = env;
    return this;
  }

  /// Sets the behavior configuration for the chat widget.
  /// 
  /// This controls UI behavior such as context menu visibility, input handling,
  /// and other interactive features.
  /// 
  /// Example:
  /// ```dart
  /// builder.behaviour(
  ///   EbbotBehaviourBuilder()
  ///     .showContextMenu(true)
  ///     .build()
  /// )
  /// ```
  EbbotConfigurationBuilder behaviour(EbbotBehaviour behaviour) {
    _behaviour = behaviour;
    return this;
  }

  /// Sets the user configuration including attributes and identification.
  /// 
  /// Use this to pass user information to the chat, such as name, email,
  /// or custom attributes that can be used for personalization.
  /// 
  /// Example:
  /// ```dart
  /// builder.userConfiguration(
  ///   EbbotUserConfigurationBuilder()
  ///     .userAttributes({'name': 'John', 'email': 'john@example.com'})
  ///     .build()
  /// )
  /// ```
  EbbotConfigurationBuilder userConfiguration(
      EbbotUserConfiguration userConfiguration) {
    _userConfiguration = userConfiguration;
    return this;
  }

  /// Sets the callback configuration for handling chat events.
  /// 
  /// Use this to register handlers for events like message received,
  /// conversation started, chat loaded, etc.
  /// 
  /// Example:
  /// ```dart
  /// builder.callback(
  ///   EbbotCallbackBuilder()
  ///     .onMessage((message) => print('Message: $message'))
  ///     .onLoad(() => print('Chat loaded'))
  ///     .build()
  /// )
  /// ```
  EbbotConfigurationBuilder callback(EbbotCallback callback) {
    _callback = callback;
    return this;
  }

  /// Sets the API controller for programmatic chat control.
  /// 
  /// The API controller allows you to control the chat programmatically,
  /// such as sending messages, restarting conversations, or ending sessions.
  /// 
  /// Example:
  /// ```dart
  /// final controller = EbbotApiController();
  /// builder.apiController(controller)
  /// 
  /// // Later, use the controller:
  /// controller.sendMessage('Hello from code!');
  /// ```
  EbbotConfigurationBuilder apiController(EbbotApiController apiController) {
    _apiController = apiController;
    return this;
  }

  /// Sets the logging configuration for debugging and monitoring.
  /// 
  /// Configure logging levels and enable/disable logging for debugging purposes.
  /// 
  /// Example:
  /// ```dart
  /// builder.logConfiguration(
  ///   EbbotLogConfigurationBuilder()
  ///     .enabled(true)
  ///     .logLevel(EbbotLogLevel.debug)
  ///     .build()
  /// )
  /// ```
  EbbotConfigurationBuilder logConfiguration(
      EbbotLogConfiguration logConfiguration) {
    _logConfiguration = logConfiguration;
    return this;
  }

  /// Sets the chat-specific configuration options.
  /// 
  /// This includes settings specific to the chat interface and behavior.
  /// 
  /// Example:
  /// ```dart
  /// builder.chat(
  ///   EbbotChatBuilder()
  ///     .build()
  /// )
  /// ```
  EbbotConfigurationBuilder chat(EbbotChat chat) {
    _chat = chat;
    return this;
  }

  /// Sets the session configuration for chat session management.
  /// 
  /// Use this to configure session recovery, specify existing chat IDs,
  /// or control session behavior.
  /// 
  /// Example:
  /// ```dart
  /// builder.session(
  ///   EbbotSessionBuilder()
  ///     .chatId('existing-chat-id-123')
  ///     .build()
  /// )
  /// ```
  EbbotConfigurationBuilder session(EbbotSession session) {
    _session = session;
    return this;
  }

  /// Builds the final [EbbotConfiguration] instance.
  /// 
  /// Call this method after configuring all desired options to create
  /// the configuration object that can be passed to [EbbotFlutterUi].
  /// 
  /// Returns a configured [EbbotConfiguration] instance.
  EbbotConfiguration build() {
    return EbbotConfiguration._builder(this);
  }
}
