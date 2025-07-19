# API Controller

Control the chat widget programmatically using the API controller.

## Overview

The API controller allows you to interact with the chat widget from your application code. You can:
- Send messages programmatically
- Check initialization status
- Restart or end conversations
- Update user attributes dynamically
- Trigger predefined scenarios
- Download conversation transcripts

## Basic Setup

Create and configure the API controller:

```dart
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final EbbotApiController _apiController = EbbotApiController();
  
  @override
  Widget build(BuildContext context) {
    final configuration = EbbotConfigurationBuilder()
      .apiController(_apiController)
      .build();
    
    return EbbotFlutterUi(
      botId: 'your-bot-id',
      configuration: configuration,
    );
  }
}
```

## Available Methods

| Method | Description | Parameters | Returns |
|--------|-------------|------------|---------|
| `isInitialized()` | Check if chat is ready | None | `bool` |
| `sendMessage(message)` | Send a message as the user | `String message` | `void` |
| `restartConversation()` | Restart the conversation | None | `void` |
| `endConversation()` | End the current conversation | None | `void` |
| `setUserAttributes(attrs)` | Update user attributes | `Map<String, dynamic>` | `void` |
| `triggerScenario(id)` | Trigger a predefined scenario | `String scenarioId` | `void` |
| `showTranscript()` | Show conversation transcript | None | `void` |

## Method Details

### Check Initialization Status

Always check if the chat is initialized before calling other methods:

```dart
if (_apiController.isInitialized()) {
  // Chat is ready for API calls
  _apiController.sendMessage('Hello from the app!');
} else {
  print('Chat not yet initialized');
}
```

### Send Messages Programmatically

Send messages as if the user typed them:

```dart
void sendWelcomeMessage() {
  if (_apiController.isInitialized()) {
    _apiController.sendMessage('I need help with my order');
  }
}

void sendQuickReply(String reply) {
  _apiController.sendMessage(reply);
}
```

### Update User Attributes

Dynamically update user information:

```dart
void updateUserLocation(double lat, double lng) {
  _apiController.setUserAttributes({
    'latitude': lat,
    'longitude': lng,
    'lastLocationUpdate': DateTime.now().millisecondsSinceEpoch,
  });
}

void updateUserPreferences(UserPreferences prefs) {
  _apiController.setUserAttributes({
    'theme': prefs.theme,
    'language': prefs.language,
    'notifications': prefs.notificationsEnabled,
  });
}
```

### Trigger Scenarios

Launch predefined conversation flows:

```dart
void showProductDemo() {
  _apiController.triggerScenario('product-demo');
}

void startSupportFlow() {
  _apiController.triggerScenario('technical-support');
}

void handleOrderIssue(String orderId) {
  // Update user context first
  _apiController.setUserAttributes({
    'currentOrderId': orderId,
  });
  
  // Then trigger the scenario
  _apiController.triggerScenario('order-support');
}
```

### Conversation Management

Control conversation flow:

```dart
void restartChat() {
  _apiController.restartConversation();
}

void endChatSession() {
  _apiController.endConversation();
}

void downloadChatHistory() {
  _apiController.showTranscript();
}
```

## Complete Example

Here's a complete implementation with API controller integration:

```dart
class ChatControllerExample extends StatefulWidget {
  @override
  _ChatControllerExampleState createState() => _ChatControllerExampleState();
}

class _ChatControllerExampleState extends State<ChatControllerExample> {
  final EbbotApiController _apiController = EbbotApiController();
  bool _isInitialized = false;
  
  @override
  Widget build(BuildContext context) {
    final configuration = EbbotConfigurationBuilder()
      .apiController(_apiController)
      .callback(
        EbbotCallbackBuilder()
          .onLoad(() {
            setState(() {
              _isInitialized = true;
            });
          })
          .build()
      )
      .build();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Controls'),
        actions: [
          PopupMenuButton<String>(
            enabled: _isInitialized,
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'restart',
                child: Text('Restart Chat'),
              ),
              PopupMenuItem(
                value: 'transcript',
                child: Text('Download Transcript'),
              ),
              PopupMenuItem(
                value: 'end',
                child: Text('End Conversation'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick action buttons
          if (_isInitialized)
            Container(
              padding: EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _sendQuickMessage('I need help'),
                    child: Text('Need Help'),
                  ),
                  ElevatedButton(
                    onPressed: () => _triggerScenario('product-demo'),
                    child: Text('Product Demo'),
                  ),
                  ElevatedButton(
                    onPressed: _updateLocation,
                    child: Text('Share Location'),
                  ),
                ],
              ),
            ),
          
          // Chat widget
          Expanded(
            child: EbbotFlutterUi(
              botId: 'your-bot-id',
              configuration: configuration,
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleMenuAction(String action) {
    switch (action) {
      case 'restart':
        _apiController.restartConversation();
        break;
      case 'transcript':
        _apiController.showTranscript();
        break;
      case 'end':
        _apiController.endConversation();
        break;
    }
  }
  
  void _sendQuickMessage(String message) {
    if (_isInitialized) {
      _apiController.sendMessage(message);
    }
  }
  
  void _triggerScenario(String scenarioId) {
    if (_isInitialized) {
      _apiController.triggerScenario(scenarioId);
    }
  }
  
  void _updateLocation() async {
    // Get user location (simplified)
    final location = await getCurrentLocation();
    _apiController.setUserAttributes({
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timezone': DateTime.now().timeZoneName,
    });
  }
}
```

## Integration Patterns

### With Bottom Sheet

Show chat in a bottom sheet with controls:

```dart
void showChatBottomSheet(BuildContext context) {
  final apiController = EbbotApiController();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (context, scrollController) => Column(
        children: [
          // Header with controls
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Chat Support', style: Theme.of(context).textTheme.headline6),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => apiController.restartConversation(),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Chat widget
          Expanded(
            child: EbbotFlutterUi(
              botId: 'your-bot-id',
              configuration: EbbotConfigurationBuilder()
                .apiController(apiController)
                .build(),
            ),
          ),
        ],
      ),
    ),
  );
}
```

### With State Management

Integrate with your state management solution:

```dart
class ChatBloc extends Cubit<ChatState> {
  final EbbotApiController _apiController = EbbotApiController();
  
  ChatBloc() : super(ChatState.initial());
  
  EbbotApiController get apiController => _apiController;
  
  void sendMessage(String message) {
    if (_apiController.isInitialized()) {
      _apiController.sendMessage(message);
      emit(state.copyWith(lastAction: 'message_sent'));
    }
  }
  
  void updateUserContext(User user) {
    _apiController.setUserAttributes({
      'userId': user.id,
      'name': user.name,
      'tier': user.subscriptionTier,
    });
  }
  
  void triggerSupportFlow(String issue) {
    _apiController.setUserAttributes({
      'supportIssue': issue,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _apiController.triggerScenario('support-flow');
  }
}
```

## Error Handling

Handle API controller errors gracefully:

```dart
void safeApiCall(void Function() apiCall) {
  try {
    if (_apiController.isInitialized()) {
      apiCall();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Chat Not Ready'),
          content: Text('Please wait for the chat to load.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    print('API call failed: $e');
    showSnackBar('Failed to perform action');
  }
}

// Usage
safeApiCall(() => _apiController.sendMessage('Hello'));
```

## Best Practices

1. **Always check initialization** before making API calls
2. **Handle errors gracefully** with try-catch blocks
3. **Provide user feedback** for API actions
4. **Update attributes strategically** - don't overwhelm with updates
5. **Use scenarios effectively** for complex flows
6. **Keep controller references** for the widget lifecycle

## Timing Considerations

The API controller becomes available after the widget initializes:

```dart
class TimingExample extends StatefulWidget {
  @override
  _TimingExampleState createState() => _TimingExampleState();
}

class _TimingExampleState extends State<TimingExample> {
  final EbbotApiController _apiController = EbbotApiController();
  final Queue<String> _pendingMessages = Queue<String>();
  
  @override
  Widget build(BuildContext context) {
    return EbbotFlutterUi(
      botId: 'your-bot-id',
      configuration: EbbotConfigurationBuilder()
        .apiController(_apiController)
        .callback(
          EbbotCallbackBuilder()
            .onLoad(() {
              // Process pending messages
              while (_pendingMessages.isNotEmpty) {
                _apiController.sendMessage(_pendingMessages.removeFirst());
              }
            })
            .build()
        )
        .build(),
    );
  }
  
  void queueMessage(String message) {
    if (_apiController.isInitialized()) {
      _apiController.sendMessage(message);
    } else {
      _pendingMessages.add(message);
    }
  }
}
```

## Next Steps

- Configure [Chat Behavior](./behavior.md)
- Set up [Logging](./logging.md) for debugging
- Explore [Advanced Configuration](./advanced.md) examples
- Review [Event Callbacks](./callbacks.md) for comprehensive integration

## Troubleshooting

Common API controller issues:

1. **Methods not working**: Check `isInitialized()` first
2. **State errors**: Ensure controller is passed to configuration
3. **Null reference errors**: Wait for the `onLoad` callback
4. **Messages not appearing**: Verify bot ID and environment

For more help, see the [Troubleshooting Guide](./troubleshooting.md).