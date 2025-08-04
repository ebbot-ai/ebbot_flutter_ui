# Ebbot Flutter UI Example

This directory contains example applications demonstrating how to use the `ebbot_flutter_ui` library.

## Setup

1. **Environment Configuration**: Copy the environment template and add your bot IDs:
   ```bash
   cp .env.example .env
   ```
   
2. **Edit `.env` file**: Replace the placeholder values with your actual bot IDs:
   ```bash
   # Example .env content
   HUSQVARNA_BOT_ID=your_husqvarna_bot_id_here
   FOREST_BOT_ID=your_forest_bot_id_here
   EBBOT_TEST_BOT_ID=your_test_bot_id_here
   DEFAULT_CLIENT=forest
   ```

## Running the Example

1. Make sure you have Flutter installed and set up
2. Navigate to the example directory:
   ```bash
   cd example
   ```
3. Complete the setup steps above (create .env file)
4. Get dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
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

The example supports multiple bot configurations through environment variables:

- **Husqvarna**: Production bot for Husqvarna client
- **Forest**: Production bot for Forest client  
- **Ebbot Test**: Test bot for development

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `HUSQVARNA_BOT_ID` | Bot ID for Husqvarna client | No |
| `FOREST_BOT_ID` | Bot ID for Forest client | No |
| `EBBOT_TEST_BOT_ID` | Bot ID for testing | No |
| `DEFAULT_CLIENT` | Which client to use by default (`husqvarna`, `forest`, `ebbottest`) | Yes |

**Security Note**: The `.env` file contains sensitive bot IDs and is excluded from version control. Never commit actual bot IDs to the repository.