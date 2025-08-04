# Advanced Configuration

Advanced features and complete configuration examples for sophisticated use cases.

## Session Management

### Resuming Existing Conversations

Resume a conversation using a saved chat ID:

```dart
final configuration = EbbotConfigurationBuilder()
  .session(
    EbbotSessionBuilder()
      .chatId('saved-chat-id-123')
      .build()
  )
  .build();
```

### Session Persistence Implementation

Save and restore chat sessions:

```dart
class ChatSessionManager {
  static const String _sessionKey = 'ebbot_chat_session';
  
  static Future<EbbotConfiguration> buildConfiguration({
    required String botId,
    required String userId,
  }) async {
    final savedSessionId = await getSavedSessionId(userId);
    
    return EbbotConfigurationBuilder()
      .environment(Environment.production)
      .session(
        EbbotSessionBuilder()
          .chatId(savedSessionId)  // null if no saved session
          .build()
      )
      .userConfiguration(
        EbbotUserConfigurationBuilder()
          .userAttributes({'userId': userId})
          .build()
      )
      .callback(
        EbbotCallbackBuilder()
          .onSessionData((chatId) => saveSessionId(userId, chatId))
          .onEndConversation(() => clearSession(userId))
          .build()
      )
      .build();
  }
  
  static Future<String?> getSavedSessionId(String userId) async {
    // Implement your preferred storage solution
    return null;
  }
  
  static Future<void> saveSessionId(String userId, String chatId) async {
    // Implement your preferred storage solution
  }
  
  static Future<void> clearSession(String userId) async {
    // Implement your preferred storage solution
  }
}
```

## Complete Configuration Example

A comprehensive example with all features:

```dart
class AdvancedChatConfig {
  static Future<EbbotConfiguration> build({
    required String botId,
    required User currentUser,
    bool isProduction = true,
  }) async {
    final apiController = EbbotApiController();
    
    return EbbotConfigurationBuilder()
      // Environment
      .environment(isProduction 
        ? Environment.googleEUProduction 
        : Environment.staging)
      
      // API Controller
      .apiController(apiController)
      
      // User Configuration
      .userConfiguration(
        EbbotUserConfigurationBuilder()
          .userAttributes(_buildUserAttributes(currentUser))
          .build()
      )
      
      // Behavior
      .behaviour(
        EbbotBehaviourBuilder()
          .showContextMenu(true)
          .input(
            EbbotBehaviourInputBuilder()
              .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
              .build()
          )
          .build()
      )
      
      // Styling
      .chat(
        EbbotChatBuilder()
          .theme(_buildChatTheme())
          .rating(_buildRatingIcon(false))
          .ratingSelected(_buildRatingIcon(true))
          .build()
      )
      
      // Callbacks
      .callback(
        EbbotCallbackBuilder()
          .onLoad(() => _handleChatLoad())
          .onLoadError((error) => _handleLoadError(error))
          .onStartConversation((msg) => _handleConversationStart(msg))
          .onMessage((msg) => _handleMessage(msg))
          .onBotMessage((msg) => _handleBotMessage(msg))
          .onUserMessage((msg) => _handleUserMessage(msg))
          .onSessionData((chatId) => _handleSessionData(chatId))
          .onEndConversation(() => _handleConversationEnd())
          .build()
      )
      
      // Logging
      .logConfiguration(
        EbbotLogConfigurationBuilder()
          .enabled(!isProduction)
          .logLevel(isProduction 
            ? EbbotLogLevel.error 
            : EbbotLogLevel.debug)
          .build()
      )
      
      // Session
      .session(
        EbbotSessionBuilder()
          .chatId(await _getSavedSessionId(currentUser.id))
          .build()
      )
      
      .build();
  }
  
  static Map<String, dynamic> _buildUserAttributes(User user) {
    return {
      'userId': user.id,
      'name': user.displayName,
      'email': user.email,
      'tier': user.subscriptionTier,
      'joinDate': user.createdAt.millisecondsSinceEpoch,
      'language': user.preferredLanguage,
      'timezone': user.timezone,
      'appVersion': user.appVersion,
    };
  }
  
  static ChatTheme _buildChatTheme() {
    return const CustomChatTheme(
      primaryColor: Color(0xFF2196F3),
      backgroundColor: Color(0xFFFFFFFF),
      inputBackgroundColor: Color(0xFFF5F5F5),
    );
  }
  
  static Widget _buildRatingIcon(bool selected) {
    return Icon(
      selected ? Icons.star : Icons.star_border,
      color: selected ? Colors.amber : Colors.grey,
      size: 24,
    );
  }
  
  // Callback handlers
  static void _handleChatLoad() {
    debugPrint('Chat loaded successfully');
  }
  
  static void _handleLoadError(EbbotLoadError error) {
    debugPrint('Chat load error: ${error.type} - ${error.cause}');
  }
  
  static void _handleConversationStart(String message) {
    debugPrint('Conversation started with message: ${message.length} chars');
  }
  
  static void _handleMessage(String message) {
    debugPrint('Message received: ${message.length} characters');
  }
  
  static void _handleBotMessage(String message) {
    debugPrint('Bot message received: ${message.length} characters');
  }
  
  static void _handleUserMessage(String message) {
    debugPrint('User message sent: ${message.length} characters');
  }
  
  static Future<void> _handleSessionData(String chatId) async {
    // Save session using your preferred storage solution
    debugPrint('Session data received: $chatId');
  }
  
  static void _handleConversationEnd() {
    debugPrint('Conversation ended');
  }
  
  static Future<String?> _getSavedSessionId(String userId) async {
    // Retrieve session using your preferred storage solution
    return null;
  }
}
```

## Multi-Bot Configuration

Handle multiple bots in one application:

```dart
class MultiBotManager {
  static final Map<String, EbbotApiController> _controllers = {};
  
  static EbbotConfiguration buildBotConfig({
    required String botId,
    required BotType type,
    required User user,
  }) {
    final controller = EbbotApiController();
    _controllers[botId] = controller;
    
    return EbbotConfigurationBuilder()
      .environment(Environment.production)
      .apiController(controller)
      .userConfiguration(
        EbbotUserConfigurationBuilder()
          .userAttributes({
            ...user.toMap(),
            'botType': type.toString(),
            'sessionId': '${user.id}_${botId}',
          })
          .build()
      )
      .behaviour(
        EbbotBehaviourBuilder()
          .showContextMenu(type == BotType.support)
          .build()
      )
      .callback(
        EbbotCallbackBuilder()
          .onStartConversation((msg) {
            debugPrint('${type.name} conversation started');
          })
          .build()
      )
      .build();
  }
  
  static EbbotApiController? getController(String botId) {
    return _controllers[botId];
  }
}

enum BotType { support, sales, feedback }
```


## Conditional Features

Enable features based on user properties:

```dart
class ConditionalFeatures {
  static EbbotConfiguration buildForUser(User user, String botId) {
    final builder = EbbotConfigurationBuilder()
      .environment(Environment.production)
      .userConfiguration(
        EbbotUserConfigurationBuilder()
          .userAttributes(user.toChatAttributes())
          .build()
      );
    
    // Premium users get enhanced features
    if (user.isPremium) {
      builder.behaviour(
        EbbotBehaviourBuilder()
          .showContextMenu(true)
          .build()
      );
    }
    
    // Beta users get experimental features
    if (user.isBetaTester) {
      builder.logConfiguration(
        EbbotLogConfigurationBuilder()
          .enabled(true)
          .logLevel(EbbotLogLevel.debug)
          .build()
      );
    }
    
    // Support tier affects chat routing
    if (user.supportTier == SupportTier.enterprise) {
      builder.userConfiguration(
        EbbotUserConfigurationBuilder()
          .userAttributes({
            ...user.toChatAttributes(),
            'priority': 'high',
            'supportTier': 'enterprise',
          })
          .build()
      );
    }
    
    return builder.build();
  }
}
```

## Error Handling

Handle loading errors in your configuration:

```dart
class ErrorHandlingConfig {
  static EbbotConfiguration buildWithErrorHandling(String botId) {
    return EbbotConfigurationBuilder()
      .environment(Environment.production)
      .callback(
        EbbotCallbackBuilder()
          .onLoadError((error) {
            debugPrint('Load error: ${error.type} - ${error.cause}');
          })
          .build()
      )
      .logConfiguration(
        EbbotLogConfigurationBuilder()
          .enabled(true)
          .logLevel(EbbotLogLevel.error)
          .build()
      )
      .build();
  }
}
```

## Performance Optimization

Optimize for different performance requirements:

```dart
class PerformanceOptimizedConfig {
  static EbbotConfiguration buildForPerformance({
    required String botId,
    required PerformanceMode mode,
  }) {
    final builder = EbbotConfigurationBuilder()
      .environment(Environment.production);
    
    switch (mode) {
      case PerformanceMode.minimal:
        builder
          .logConfiguration(
            EbbotLogConfigurationBuilder()
              .enabled(false)
              .build()
          )
          .behaviour(
            EbbotBehaviourBuilder()
              .showContextMenu(false)
              .build()
          );
        break;
        
      case PerformanceMode.balanced:
        builder
          .logConfiguration(
            EbbotLogConfigurationBuilder()
              .enabled(true)
              .logLevel(EbbotLogLevel.error)
              .build()
          );
        break;
        
      case PerformanceMode.full:
        builder
          .logConfiguration(
            EbbotLogConfigurationBuilder()
              .enabled(true)
              .logLevel(EbbotLogLevel.debug)
              .build()
          )
          .callback(
            EbbotCallbackBuilder()
              .onMessage((msg) => debugPrint('Message: $msg'))
              .build()
          );
        break;
    }
    
    return builder.build();
  }
}

enum PerformanceMode { minimal, balanced, full }
```

## Integration Examples

### With State Management (Bloc)

```dart
class ChatBloc extends Cubit<ChatState> {
  final EbbotApiController _apiController = EbbotApiController();
  
  EbbotConfiguration get configuration => EbbotConfigurationBuilder()
    .apiController(_apiController)
    .callback(
      EbbotCallbackBuilder()
        .onLoad(() => emit(ChatState.loaded()))
        .onStartConversation((msg) => emit(ChatState.active()))
        .onEndConversation(() => emit(ChatState.ended()))
        .build()
    )
    .build();
    
  void sendMessage(String message) {
    _apiController.sendMessage(message);
  }
}
```

### With Navigation

```dart
class ChatNavigationManager {
  static void showChatPage(BuildContext context, String botId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          configuration: EbbotConfigurationBuilder()
            .callback(
              EbbotCallbackBuilder()
                .onEndConversation(() {
                  Navigator.pop(context);
                })
                .build()
            )
            .build(),
          botId: botId,
        ),
      ),
    );
  }
}
```

## Best Practices

1. **Centralize configuration** in dedicated classes
2. **Use environment-specific configs** for different deployments
3. **Implement proper error handling** and recovery strategies
4. **Monitor performance** with appropriate logging levels
5. **Test configurations** across different scenarios
6. **Keep sensitive data secure** in user attributes
7. **Use session management** for better user experience

## Next Steps

- Check [Troubleshooting Guide](./troubleshooting.md) for common issues
- Explore individual configuration pages for detailed options
- Test your configuration in different environments

## Support

For complex configuration needs:
1. Review the example implementations above
2. Check the troubleshooting guide