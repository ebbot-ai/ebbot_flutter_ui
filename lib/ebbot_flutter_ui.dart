/// A Flutter UI widget for integrating Ebbot chat functionality into Flutter applications.
///
/// This library provides a comprehensive chat interface that connects to Ebbot's
/// backend services, offering features like:
/// - Real-time messaging with WebSocket support
/// - Image upload capabilities
/// - Session management and recovery
/// - Customizable themes and behaviors
/// - Agent handover support
/// - Conversation transcripts
///
/// ## Getting Started
///
/// To use this library, add it to your `pubspec.yaml`:
///
/// ```yaml
/// dependencies:
///   ebbot_flutter_ui:
///     git:
///       url: https://github.com/your-org/ebbot_flutter_ui.git
///       ref: main
/// ```
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';
/// import 'package:ebbot_dart_client/valueobjects/environment.dart';
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: EbbotFlutterUi(
///         botId: 'your-bot-id',
///         configuration: EbbotConfigurationBuilder()
///           .environment(Environment.production)
///           .build(),
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Configuration
///
/// The library supports extensive configuration through the [EbbotConfiguration] class:
///
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
///   .callback(
///     EbbotCallbackBuilder()
///       .onLoad(() => print('Chat loaded'))
///       .onMessage((message) => print('Message: $message'))
///       .onInputVisibilityChanged((isVisible) => print('Input visible: $isVisible'))
///       .onTypingChanged((isTyping, typingEntity) => print('Typing: $isTyping ($typingEntity)'))
///       .onAgentHandover(() => print('Agent handover occurred'))
///       .build()
///   )
///   .build();
/// ```
library ebbot_flutter_ui;

// Main widget
export 'v1/ebbot_flutter_ui.dart';

// Configuration classes
export 'v1/configuration/ebbot_configuration.dart';
export 'v1/configuration/ebbot_behaviour.dart';
export 'v1/configuration/ebbot_callback.dart';
export 'v1/configuration/ebbot_chat.dart';
export 'v1/configuration/ebbot_log_configuration.dart';
export 'v1/configuration/ebbot_session.dart';
export 'v1/configuration/ebbot_user_configuration.dart';

// API Controller for programmatic control
export 'v1/controller/ebbot_api_controller.dart';

// Re-export necessary dependencies from ebbot_dart_client
export 'package:ebbot_dart_client/valueobjects/environment.dart';