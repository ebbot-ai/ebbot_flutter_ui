# ebbot-flutter-ui

Is a flutter ui widget for implementing the Ebbot chatbot.
This widget encapsulates the logic in the `ebbot-dart-client` package and provides an drop-in ready solution for rendering a Ebbot Chat in your Flutter App.

## Notable technical dependencies

- This widget depends on the `flutter-chat-ui` package for rendering the chat ui
- It also depends on the `ebbot-dart-client` client library which wraps the business logic of the Ebbot Chat bot

### Usage

The most basic way to render the chat, is simply by providing it as a home destination of a `MaterialApp` widget:
```
class EbbotDemoApp extends StatelessWidget {
  const EbbotDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebbot Chat Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: EbbotUiWidget(botId: 'your-bot-id'),
    );
  }
}
```

### Configuration

As of now, the configurable options are:
- change the underlying theme in `flutter-chat-ui`
- passing user specific attributes
- setting the cloud environment the App is running against

```
class EbbotDemoApp extends StatelessWidget {
  const EbbotDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    var userAttributes = {
      'name': 'John Doe',
      'email': 'john@doe.com',
      'age': 30,
      'height': 180.0,
      'isPremium': true,
      'lastLogin': DateTime.now().millisecondsSinceEpoch
    };
    var config = EbbotConfigurationBuilder()
      .theme(const DarkChatTheme())
      .userAttributes(userAttributes)
      .environment(Environment.staging)
      .build();
    return MaterialApp(
      title: 'Ebbot Chat Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: EbbotUiWidget(botId: 'your-bot-id', config: config),
    );
  }
}
```

#### Passing user information

To feed the bot with more context about the user, you can pass user attributes in the configuration file, the allowed type is `Map<String, dynamic>`. 

#### Theming

Theming the [underlying chat component](https://github.com/flyerhq/flutter_chat_ui) can be done by passing your custom theme to the `theme` builder function.
Visit the `flutter-chat-ui` [documentation page](https://docs.flyer.chat/flutter/chat-ui/themes) to learn more about styling the chat. 

#### Configuring the cloud environment

Configuring the cloud environment is done by passing a configuration property to the `environment` builder function.

Available configuration options are:
| Environment                          | Configuration Host                           | Chat API Host                                 |
| ------------------------------------ | -------------------------------------------- | --------------------------------------------- |
| `Environment.staging`                | https://ebbot-staging.storage.googleapis.com | (https/wss)://staging.ebbot.app/api/asyngular |
| `Environment.release`                | https://ebbot-release.storage.googleapis.com | (https/wss)://release.ebbot.app/api/asyngular |
| `Environment.googleCanadaProduction` | https://ebbot-ca.storage.googleapis.com      | (https/wss)://ca.ebbot.app/api/asyngular      |
| `Environment.googleEUProduction`     | https://ebbot-v2.storage.googleapis.com      | (https/wss)://v2.ebbot.app/api/asyngular      |
| `Environment.ovhEUProduction`        | https://storage.gra.cloud.ovh.net            | (https/wss)://ebbot.eu/api/asyngular          |

The configuration is subject to change, so in order to see the most recent changes, reading the [configuration source code](https://github.com/ebbot-ai/ebbot_dart_client/blob/main/lib/configuration/environment_configuration_config.dart) is the best way to go.

### Demo app

A demo app that implements the `ebbot-flutter-ui` can be found in this repository: https://github.com/ebbot-ai/ebbot_flutter_ui_demo
This is a good starting point for anyone implementing the chat for the first time.