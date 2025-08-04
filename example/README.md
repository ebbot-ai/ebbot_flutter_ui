# Ebbot Flutter UI Example

This directory contains example applications demonstrating how to use the `ebbot_flutter_ui` library.

## Setup

1. **Environment Configuration**: Copy the environment template and configure your bot:
   ```bash
   cp .env.example .env
   ```
   
2. **Edit `.env` file**: Replace the placeholder values with your actual bot configuration:
   ```bash
   # Example .env content
   BOT_ID=your_bot_id_here
   EBBOT_ENVIRONMENT=ovhEUProduction
   ```
## Running the Example

1. Make sure you have Flutter installed and set up
2. Navigate to the example directory:
   ```bash
   cd example
   ```
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Examples Included

### Basic Chat Integration
The main example shows how to integrate the Ebbot chat widget into a Flutter application with:
- Multiple bot configurations for different environments
- User attribute passing
- Custom callbacks for chat events
- Session management
- Custom styling

### Features Demonstrated

- **Environment Configuration**: Switch between different Ebbot environments
- **User Attributes**: Pass user information to the chat
- **Event Callbacks**: Handle chat events like messages, session start/end
- **Session Recovery**: Resume existing chat sessions
- **Custom Styling**: Apply custom themes and colors
- **Multi-page Integration**: Shows how to preserve chat state across page navigation

## Configuration

The example demonstrates various configuration options:

```dart
var configuration = EbbotConfigurationBuilder()
    .environment(Environment.production)
    .userConfiguration(
      EbbotUserConfigurationBuilder()
        .userAttributes({'name': 'John Doe', 'email': 'john@doe.com'})
        .build()
    )
    .behaviour(
      EbbotBehaviourBuilder()
        .showContextMenu(true)
        .build()
    )
    .callback(
      EbbotCallbackBuilder()
        .onLoad(() => print('Chat loaded'))
        .onMessage((message) => print('Message: $message'))
        .build()
    )
    .build();
```

## Bot Configuration

The example uses environment variables for configuration, making it easy to use with any bot:

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `BOT_ID` | Your Ebbot bot ID | Yes | - |
| `EBBOT_ENVIRONMENT` | Environment to connect to | No | `ovhEUProduction` |

### Supported Environments

- `googleEUProduction` - Google EU production environment
- `ovhEUProduction` - OVH EU production environment  
- `staging` - Staging environment for testing

**Security Note**: The `.env` file contains sensitive bot IDs and is excluded from version control. Never commit actual bot IDs to the repository.
