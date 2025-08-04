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



## Best Practices

1. **Centralize configuration** in dedicated classes
2. **Use environment-specific configs** for different deployments  
3. **Handle errors appropriately** with callbacks
4. **Keep sensitive data secure** in user attributes

## Next Steps

- Check [Troubleshooting Guide](./troubleshooting.md) for common issues
- Explore individual configuration pages for detailed options
- Test your configuration in different environments

## Support

For complex configuration needs:
1. Review the example implementations above
2. Check the troubleshooting guide