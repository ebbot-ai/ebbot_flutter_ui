# Event Callbacks

Handle chat lifecycle events and user interactions with callback functions.

## Overview

Callbacks allow you to react to various events in the chat widget's lifecycle, from initialization to message handling. This enables you to:
- Track user interactions
- Integrate with analytics
- Handle errors gracefully
- Synchronize with other parts of your app
- Implement custom business logic

## Available Callbacks

| Callback | Description | Parameters |
|----------|-------------|------------|
| `onLoadError` | Called when initialization fails | `EbbotLoadError error` |
| `onLoad` | Called when chat successfully loads | None |
| `onMessage` | Called for any message (bot or user) | `String message` |
| `onBotMessage` | Called for bot messages only | `String message` |
| `onUserMessage` | Called for user messages only | `String message` |
| `onStartConversation` | Called when conversation starts | `String message` (first message) |
| `onEndConversation` | Called when conversation ends | None |
| `onChatClosed` | Called when chat session is closed | None |
| `onRestartConversation` | Called when conversation restarts | None |
| `onSessionData` | Called when session data is available | `String chatId` |

## Basic Implementation

```dart
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

final configuration = EbbotConfigurationBuilder()
  .callback(
    EbbotCallbackBuilder()
      .onLoad(() {
        print('Chat loaded successfully');
      })
      .onMessage((message) {
        print('New message: $message');
      })
      .build()
  )
  .build();
```

## Complete Example

Here's an implementation with all callbacks:

```dart
class ChatCallbacks {
  // Error handling
  static Future<void> onLoadError(EbbotLoadError error) async {
    print('Load error: ${error.type}');
    print('Cause: ${error.cause}');
    print('Stack trace: ${error.stackTrace}');
    
    // Handle different error types
    switch (error.type) {
      case EbbotInitializationErrorType.network:
        showNetworkErrorDialog();
        break;
      case EbbotInitializationErrorType.initialization:
        showInitializationErrorDialog();
        break;
    }
  }
  
  // Lifecycle events
  static Future<void> onLoad() async {
    print('Chat widget loaded');
    analytics.track('chat_loaded');
  }
  
  static Future<void> onStartConversation(String firstMessage) async {
    print('Conversation started with: $firstMessage');
    analytics.track('conversation_started', {
      'first_message': firstMessage,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  static Future<void> onEndConversation() async {
    print('Conversation ended');
    analytics.track('conversation_ended');
  }
  
  static Future<void> onChatClosed() async {
    print('Chat closed');
    analytics.track('chat_closed');
  }
  
  static Future<void> onRestartConversation() async {
    print('Conversation restarted');
    analytics.track('conversation_restarted');
  }
  
  // Message handling
  static Future<void> onMessage(String message) async {
    print('Message received: $message');
    saveMessageToHistory(message);
  }
  
  static Future<void> onBotMessage(String message) async {
    print('Bot said: $message');
    checkForSpecialResponses(message);
  }
  
  static Future<void> onUserMessage(String message) async {
    print('User said: $message');
    updateUserEngagement();
  }
  
  // Session management
  static Future<void> onSessionData(String chatId) async {
    print('Session ID: $chatId');
    saveSessionId(chatId);
  }
}

// Configure callbacks
final configuration = EbbotConfigurationBuilder()
  .callback(
    EbbotCallbackBuilder()
      .onLoadError(ChatCallbacks.onLoadError)
      .onLoad(ChatCallbacks.onLoad)
      .onStartConversation(ChatCallbacks.onStartConversation)
      .onEndConversation(ChatCallbacks.onEndConversation)
      .onChatClosed(ChatCallbacks.onChatClosed)
      .onRestartConversation(ChatCallbacks.onRestartConversation)
      .onMessage(ChatCallbacks.onMessage)
      .onBotMessage(ChatCallbacks.onBotMessage)
      .onUserMessage(ChatCallbacks.onUserMessage)
      .onSessionData(ChatCallbacks.onSessionData)
      .build()
  )
  .build();
```

## Use Cases

### Analytics Integration

Track user engagement and chat metrics:

```dart
.callback(
  EbbotCallbackBuilder()
    .onStartConversation((message) {
      mixpanel.track('Chat Started', {
        'first_message': message,
        'user_id': currentUser.id,
      });
    })
    .onUserMessage((message) {
      mixpanel.track('Message Sent', {
        'message_length': message.length,
        'has_question': message.contains('?'),
      });
    })
    .onEndConversation(() {
      mixpanel.track('Chat Ended', {
        'duration': chatDuration,
        'message_count': messageCount,
      });
    })
    .onChatClosed(() {
      mixpanel.track('Chat Closed', {
        'duration': chatDuration,
        'message_count': messageCount,
      });
    })
    .build()
)
```

### Error Recovery

Implement retry logic and user feedback:

```dart
.callback(
  EbbotCallbackBuilder()
    .onLoadError((error) async {
      if (error.type == EbbotInitializationErrorType.network) {
        // Show retry dialog
        final shouldRetry = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Connection Error'),
            content: Text('Unable to connect to chat. Retry?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Retry'),
              ),
            ],
          ),
        );
        
        if (shouldRetry == true) {
          reloadChatWidget();
        }
      }
    })
    .build()
)
```

### Session Persistence

Save and restore chat sessions:

```dart
class ChatSessionManager {
  static const _sessionKey = 'ebbot_chat_session';
  
  static void configureCallbacks(EbbotCallbackBuilder builder) {
    builder
      .onSessionData((chatId) async {
        // Save session ID
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_sessionKey, chatId);
        print('Session saved: $chatId');
      })
      .onEndConversation(() async {
        // Clear saved session on conversation end
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_sessionKey);
        print('Session cleared on conversation end');
      })
      .onChatClosed(() async {
        // Clear saved session on chat close
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_sessionKey);
        print('Session cleared on chat close');
      });
  }
  
  static Future<String?> getSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }
}
```

### Bot Response Handling

React to specific bot responses:

```dart
.callback(
  EbbotCallbackBuilder()
    .onBotMessage((message) {
      // Check for special commands
      if (message.contains('TRANSFER_AGENT')) {
        showAgentTransferNotification();
      }
      
      // Check for form requests
      if (message.contains('EMAIL_REQUIRED')) {
        showEmailInputDialog();
      }
      
      // Check for completion
      if (message.contains('TICKET_CREATED:')) {
        final ticketId = extractTicketId(message);
        saveTicketReference(ticketId);
      }
    })
    .build()
)
```

### State Synchronization

Keep app state in sync with chat:

```dart
class ChatStateSync {
  final StateManager stateManager;
  
  EbbotCallback buildCallbacks() {
    return EbbotCallbackBuilder()
      .onLoad(() {
        stateManager.setChatStatus(ChatStatus.ready);
      })
      .onStartConversation((message) {
        stateManager.setChatStatus(ChatStatus.active);
        stateManager.addMessage(message);
      })
      .onMessage((message) {
        stateManager.addMessage(message);
        stateManager.updateLastActivity();
      })
      .onEndConversation(() {
        stateManager.setChatStatus(ChatStatus.conversationEnded);
      })
      .onChatClosed(() {
        stateManager.setChatStatus(ChatStatus.chatClosed);
      })
      .build();
  }
}
```

## Callback Flow Diagram

```
App Start
    ↓
[onLoad] or [onLoadError]
    ↓
User sends first message
    ↓
[onStartConversation]
    ↓
[onUserMessage] → [onMessage]
    ↓
Bot responds
    ↓
[onBotMessage] → [onMessage]
    ↓
[onSessionData] (when session established)
    ↓
... (conversation continues)
    ↓
[onEndConversation] or [onChatClosed] or [onRestartConversation]
```

## Best Practices

1. **Keep callbacks lightweight** - Don't perform heavy operations
2. **Handle errors gracefully** - Always implement onLoadError
3. **Avoid UI updates** - Use state management instead
4. **Make callbacks async** - Use Future<void> for async operations
5. **Test error scenarios** - Simulate network failures and errors

## Debugging Callbacks

Enable verbose logging to debug callbacks:

```dart
final debugCallbacks = EbbotCallbackBuilder()
  .onLoad(() => debugPrint('[CALLBACK] onLoad'))
  .onLoadError((error) => debugPrint('[CALLBACK] onLoadError: $error'))
  .onMessage((msg) => debugPrint('[CALLBACK] onMessage: $msg'))
  .onBotMessage((msg) => debugPrint('[CALLBACK] onBotMessage: $msg'))
  .onUserMessage((msg) => debugPrint('[CALLBACK] onUserMessage: $msg'))
  .onStartConversation((msg) => debugPrint('[CALLBACK] onStartConversation'))
  .onEndConversation(() => debugPrint('[CALLBACK] onEndConversation'))
  .onChatClosed(() => debugPrint('[CALLBACK] onChatClosed'))
  .onRestartConversation(() => debugPrint('[CALLBACK] onRestartConversation'))
  .onSessionData((id) => debugPrint('[CALLBACK] onSessionData: $id'))
  .build();
```

## Next Steps

- Implement [API Controller](./api-controller.md) for programmatic control
- Configure [Chat Behavior](./behavior.md)
- Set up [Logging](./logging.md) for debugging
- Explore [Advanced Configuration](./advanced.md) examples

## Troubleshooting

Common callback issues:

1. **Callbacks not firing**: Ensure you're calling `.build()` on the builder
2. **Null errors**: All callbacks are optional, only implement what you need
3. **Timing issues**: onLoad is called before onSessionData
4. **Missing messages**: Check both onMessage and specific message callbacks

For more help, see the [Troubleshooting Guide](./troubleshooting.md).