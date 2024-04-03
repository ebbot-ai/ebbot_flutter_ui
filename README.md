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

As of now, the only configurable options are to change the underlying theme in `flutter-chat-ui` or by setting the cloud environment the App is running against.

```
class EbbotDemoApp extends StatelessWidget {
  const EbbotDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    var config = EbbotConfigurationBuilder()
      .theme(const DarkChatTheme())
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

#### Theming

Theming the [underlying chat component](https://github.com/flyerhq/flutter_chat_ui) can be done by passing your custom theme to the `theme` builder function.
Visit the `flutter-chat-ui` [documentation page](https://docs.flyer.chat/flutter/chat-ui/themes) to learn more about styling the chat. 

#### Configuring the cloud environment

Configuring the cloud environment is done by passing a configuration property to the `environment` builder function.

Available configuration options are:
| Environment                          | Host                                         |
| ------------------------------------ | -------------------------------------------- |
| `Environment.staging`                | https://ebbot-staging.storage.googleapis.com |
| `Environment.release`                | https://ebbot-release.storage.googleapis.com |
| `Environment.googleCanadaProduction` | https://ebbot-ca.storage.googleapis.com      |
| `Environment.googleEUProduction`     | https://ebbot-v2.storage.googleapis.com      |
| `Environment.ovhEUProduction`        | https://storage.gra.cloud.ovh.net            |

The configuration is subject to change, so in order to see the most recent changes, reading the [configuration source code](https://github.com/ebbot-ai/ebbot_dart_client/blob/main/lib/configuration/environment_configuration_config.dart) is the best way to go.

### Demo app

A demo app that implements the `ebbot-flutter-ui` can be found in this repository: https://github.com/ebbot-ai/ebbot_flutter_ui_demo
This is a good starting point for anyone implementing the chat for the first time.