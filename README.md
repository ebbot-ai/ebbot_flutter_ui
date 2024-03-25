# ebbot-flutter-ui

A flutter ui widget for implementing the Ebbot chatbot.
This widget encapsulates the logic in the `ebbot-dart-client`package and provides an drop-in ready solution for rendering a Ebbot Chat in your flutter App.

## Notable echincal dependencies
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

As of now, the only configurable option is to change the underlying theme in `flutter-chat-ui` by passing it as a configuration option:
```
class EbbotDemoApp extends StatelessWidget {
  const EbbotDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    var config = EbbotConfigurationBuilder().theme(const DarkChatTheme()).build();
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
