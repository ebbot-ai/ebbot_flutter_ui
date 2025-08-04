# User Attributes Configuration

Pass user-specific data to personalize conversations and provide context to your Ebbot chat bot.

## Overview

User attributes allow you to send information about the current user to the chat bot. This data can be used to:
- Personalize greetings and responses
- Route conversations based on user properties
- Pre-fill information in forms
- Track user segments and behavior
- Provide context for better support

## Basic Usage

```dart
final configuration = EbbotConfigurationBuilder()
  .userConfiguration(
    EbbotUserConfigurationBuilder()
      .userAttributes({
        'userId': '12345',
        'name': 'John Doe',
        'email': 'john.doe@example.com'
      })
      .build()
  )
  .build();
```

## Supported Data Types

User attributes support the following Dart types:
- `String` - Text values
- `int` - Integer numbers
- `double` - Decimal numbers
- `bool` - True/false values
- `DateTime` - Date and time values (converted to milliseconds)

### Example with Multiple Types

```dart
final userAttributes = {
  // String values
  'userId': 'user_123',
  'name': 'John Doe',
  'email': 'john@example.com',
  'membershipType': 'premium',
  
  // Numeric values
  'age': 30,
  'accountBalance': 150.50,
  'orderCount': 42,
  
  // Boolean values
  'isPremium': true,
  'hasCompletedOnboarding': false,
  'emailVerified': true,
  
  // Date values (converted to milliseconds)
  'createdAt': DateTime(2023, 1, 15).millisecondsSinceEpoch,
  'lastLogin': DateTime.now().millisecondsSinceEpoch,
};

final configuration = EbbotConfigurationBuilder()
  .userConfiguration(
    EbbotUserConfigurationBuilder()
      .userAttributes(userAttributes)
      .build()
  )
  .build();
```


## Dynamic Attribute Updates

You can update user attributes after initialization using the API controller:

```dart
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _apiController = EbbotApiController();
  
  void _updateUserLocation(Position position) {
    _apiController.setUserAttributes({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'lastLocationUpdate': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  void _updateUserPreferences(UserPreferences prefs) {
    _apiController.setUserAttributes({
      'theme': prefs.theme,
      'notifications': prefs.notificationsEnabled,
      'language': prefs.language,
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final configuration = EbbotConfigurationBuilder()
      .apiController(_apiController)
      .userConfiguration(
        EbbotUserConfigurationBuilder()
          .userAttributes({
            'userId': currentUser.id,
            'name': currentUser.name,
          })
          .build()
      )
      .build();
    
    return EbbotFlutterUi(
      botId: 'your-bot-id',
      configuration: configuration,
    );
  }
}
```

## Attribute Naming Conventions

Follow these naming conventions for consistency:

1. **Use camelCase**: `userId`, `firstName`, `lastLogin`
2. **Be descriptive**: `customerSupportTier` instead of `tier`
3. **Use standard names**: `email`, `phone`, `name`
4. **Prefix related attributes**: `billing_address`, `billing_city`
5. **Use boolean prefixes**: `is`, `has`, `can` (e.g., `isPremium`)

## Privacy and Security Considerations

⚠️ **Important**: Be mindful of the data you send as user attributes.

### Do NOT Send:
- Passwords or authentication tokens
- Credit card numbers
- Social security numbers
- Medical records
- Other sensitive personal information

### Best Practices:
- Only send necessary information
- Use user IDs instead of sensitive identifiers
- Implement proper data encryption in transit
- Follow GDPR/CCPA compliance requirements
- Allow users to opt-out of data sharing

## Conditional Attributes

Send different attributes based on user state:

```dart
Map<String, dynamic> getUserAttributes(User user) {
  final baseAttributes = {
    'userId': user.id,
    'type': user.type,
  };
  
  // Add authenticated user attributes
  if (user.isAuthenticated) {
    baseAttributes.addAll({
      'name': user.name,
      'email': user.email,
      'memberSince': user.createdAt.millisecondsSinceEpoch,
    });
  }
  
  // Add premium user attributes
  if (user.isPremium) {
    baseAttributes.addAll({
      'subscriptionType': user.subscription,
      'subscriptionExpiry': user.subscriptionEnd?.millisecondsSinceEpoch,
    });
  }
  
  return baseAttributes;
}
```

## Integration Example

Configure user attributes for chat:

```dart
void initializeChat(User user) {
  final attributes = {
    'userId': user.id,
    'segment': user.segment,
    'cohort': user.cohort,
  };
  
  // Send to chat
  final configuration = EbbotConfigurationBuilder()
    .userConfiguration(
      EbbotUserConfigurationBuilder()
        .userAttributes(attributes)
        .build()
    )
    .build();
}
```

## Testing User Attributes

During development, use debug attributes:

```dart
final debugAttributes = kDebugMode
  ? {
      'userId': 'test_user_123',
      'name': 'Test User',
      'email': 'test@example.com',
      'debugMode': true,
      'environment': 'development',
    }
  : getProductionUserAttributes();
```

## Next Steps

- Configure [Environment Settings](./environments.md)
- Set up [Event Callbacks](./callbacks.md)
- Implement [Chat Behavior](./behavior.md)
- Use the [API Controller](./api-controller.md) for dynamic updates

## Troubleshooting

If user attributes aren't working:

1. Verify the attribute types are supported
2. Check for typos in attribute names
3. Ensure attributes are set before initialization
4. Enable logging to see what's being sent
5. Test with simple attributes first

For more help, see the [Troubleshooting Guide](./troubleshooting.md).