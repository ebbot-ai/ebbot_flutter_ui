# Chat Behavior Configuration

Configure user interface behavior and interaction patterns for the chat widget.

## Overview

The behavior configuration controls how users interact with the chat interface:
- Enter key behavior (send message vs new line)
- Context menu visibility
- Input field behavior
- UI interaction patterns

## Basic Configuration

```dart
final configuration = EbbotConfigurationBuilder()
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
  .build();
```

## Context Menu

The context menu provides quick actions for users:

### Enable Context Menu
```dart
.behaviour(
  EbbotBehaviourBuilder()
    .showContextMenu(true)  // Shows menu with restart, transcript, end options
    .build()
)
```

### Disable Context Menu
```dart
.behaviour(
  EbbotBehaviourBuilder()
    .showContextMenu(false)  // Use API controller for programmatic control
    .build()
)
```

When to disable:
- You want custom controls
- Using API controller for actions
- Simplified interface requirements
- Custom UI patterns

## Input Behavior

Configure how the input field behaves:

### Enter Key Behavior

Control what happens when the user presses Enter:

```dart
// Send message on Enter (default)
.input(
  EbbotBehaviourInputBuilder()
    .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
    .build()
)

// Insert new line on Enter
.input(
  EbbotBehaviourInputBuilder()
    .enterPressed(EbbotBehaviourInputEnterPressed.newline)
    .build()
)
```

#### Send Message Mode
- **Enter**: Sends the message
- **Shift+Enter**: Inserts new line
- Best for: Quick conversations, customer support

#### New Line Mode
- **Enter**: Inserts new line
- **Send button**: Sends the message
- Best for: Long messages, detailed descriptions

## Complete Behavior Example

```dart
final configuration = EbbotConfigurationBuilder()
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
  .build();
```

## Use Cases

### Customer Support Chat
Quick interactions, immediate responses:

```dart
final supportBehavior = EbbotBehaviourBuilder()
  .showContextMenu(true)  // Allow users to restart or end chat
  .input(
    EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
      .build()
  )
  .build();
```

### Feedback or Survey Chat
Longer responses, thoughtful input:

```dart
final feedbackBehavior = EbbotBehaviourBuilder()
  .showContextMenu(false)  // Simplified interface
  .input(
    EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.newline)
      .build()
  )
  .build();
```

### Mobile-Optimized Chat
Touch-friendly interactions:

```dart
final mobileBehavior = EbbotBehaviourBuilder()
  .showContextMenu(true)  // Easy access to actions
  .input(
    EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)  // Quick sending
      .build()
  )
  .build();
```

### Desktop Application Chat
Keyboard-focused interactions:

```dart
final desktopBehavior = EbbotBehaviourBuilder()
  .showContextMenu(false)  // Keyboard shortcuts preferred
  .input(
    EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.newline)  // Multi-line support
      .build()
  )
  .build();
```

## Platform-Specific Behavior

Adapt behavior based on the platform:

```dart
EbbotBehaviour getPlatformBehavior() {
  if (Platform.isIOS || Platform.isAndroid) {
    // Mobile: Quick interactions
    return EbbotBehaviourBuilder()
      .showContextMenu(true)
      .input(
        EbbotBehaviourInputBuilder()
          .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
          .build()
      )
      .build();
  } else {
    // Desktop: Rich text input
    return EbbotBehaviourBuilder()
      .showContextMenu(false)
      .input(
        EbbotBehaviourInputBuilder()
          .enterPressed(EbbotBehaviourInputEnterPressed.newline)
          .build()
      )
      .build();
  }
}
```

## Dynamic Behavior Changes

Change behavior based on application state:

```dart
class DynamicBehaviorChat extends StatefulWidget {
  @override
  _DynamicBehaviorChatState createState() => _DynamicBehaviorChatState();
}

class _DynamicBehaviorChatState extends State<DynamicBehaviorChat> {
  bool _isExpressMode = true;
  
  EbbotBehaviour get _currentBehavior {
    return EbbotBehaviourBuilder()
      .showContextMenu(!_isExpressMode)
      .input(
        EbbotBehaviourInputBuilder()
          .enterPressed(_isExpressMode 
            ? EbbotBehaviourInputEnterPressed.sendMessage
            : EbbotBehaviourInputEnterPressed.newline)
          .build()
      )
      .build();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mode toggle
        SwitchListTile(
          title: Text('Express Mode'),
          subtitle: Text('Quick responses with Enter to send'),
          value: _isExpressMode,
          onChanged: (value) {
            setState(() {
              _isExpressMode = value;
            });
          },
        ),
        
        // Chat widget
        Expanded(
          child: EbbotFlutterUi(
            key: ValueKey(_isExpressMode), // Rebuild on change
            botId: 'your-bot-id',
            configuration: EbbotConfigurationBuilder()
              .behaviour(_currentBehavior)
              .build(),
          ),
        ),
      ],
    );
  }
}
```

## User Preference Integration

Save and restore user behavior preferences:

```dart
class BehaviorPreferences {
  static const _enterBehaviorKey = 'chat_enter_behavior';
  static const _contextMenuKey = 'chat_context_menu';
  
  static Future<EbbotBehaviour> loadBehavior() async {
    final prefs = await SharedPreferences.getInstance();
    
    final enterBehavior = prefs.getString(_enterBehaviorKey) == 'newline'
      ? EbbotBehaviourInputEnterPressed.newline
      : EbbotBehaviourInputEnterPressed.sendMessage;
      
    final showContextMenu = prefs.getBool(_contextMenuKey) ?? true;
    
    return EbbotBehaviourBuilder()
      .showContextMenu(showContextMenu)
      .input(
        EbbotBehaviourInputBuilder()
          .enterPressed(enterBehavior)
          .build()
      )
      .build();
  }
  
  static Future<void> saveBehavior(EbbotBehaviour behavior) async {
    final prefs = await SharedPreferences.getInstance();
    // Save preferences...
  }
}
```

## Accessibility Considerations

Configure behavior for accessibility:

```dart
final accessibleBehavior = EbbotBehaviourBuilder()
  .showContextMenu(true)  // Screen reader accessible menu
  .input(
    EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)  // Clear action
      .build()
  )
  .build();
```

## Testing Different Behaviors

Create a debug panel for testing:

```dart
class BehaviorTestPanel extends StatefulWidget {
  final Function(EbbotBehaviour) onBehaviorChanged;
  
  @override
  _BehaviorTestPanelState createState() => _BehaviorTestPanelState();
}

class _BehaviorTestPanelState extends State<BehaviorTestPanel> {
  bool _showContextMenu = true;
  EbbotBehaviourInputEnterPressed _enterBehavior = 
    EbbotBehaviourInputEnterPressed.sendMessage;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Show Context Menu'),
          value: _showContextMenu,
          onChanged: (value) {
            setState(() {
              _showContextMenu = value;
            });
            _updateBehavior();
          },
        ),
        
        RadioListTile<EbbotBehaviourInputEnterPressed>(
          title: Text('Enter sends message'),
          value: EbbotBehaviourInputEnterPressed.sendMessage,
          groupValue: _enterBehavior,
          onChanged: (value) {
            setState(() {
              _enterBehavior = value!;
            });
            _updateBehavior();
          },
        ),
        
        RadioListTile<EbbotBehaviourInputEnterPressed>(
          title: Text('Enter creates new line'),
          value: EbbotBehaviourInputEnterPressed.newline,
          groupValue: _enterBehavior,
          onChanged: (value) {
            setState(() {
              _enterBehavior = value!;
            });
            _updateBehavior();
          },
        ),
      ],
    );
  }
  
  void _updateBehavior() {
    final behavior = EbbotBehaviourBuilder()
      .showContextMenu(_showContextMenu)
      .input(
        EbbotBehaviourInputBuilder()
          .enterPressed(_enterBehavior)
          .build()
      )
      .build();
      
    widget.onBehaviorChanged(behavior);
  }
}
```

## Best Practices

1. **Consider your audience**: Quick support vs detailed feedback
2. **Match platform conventions**: Mobile vs desktop expectations
3. **Provide clear indicators**: Show what Enter does
4. **Test both modes**: Ensure both behaviors work well
5. **Consider accessibility**: Screen readers and keyboard navigation

## Next Steps

- Set up [Logging](./logging.md) for debugging
- Explore [Advanced Configuration](./advanced.md) examples
- Review [Event Callbacks](./callbacks.md) for behavior tracking
- Configure [Styling](./styling.md) to match behavior

## Troubleshooting

Common behavior issues:

1. **Enter not working**: Check device keyboard settings
2. **Context menu not showing**: Verify showContextMenu is true
3. **Unexpected behavior**: Clear app cache and restart
4. **Platform differences**: Test on target devices

For more help, see the [Troubleshooting Guide](./troubleshooting.md).