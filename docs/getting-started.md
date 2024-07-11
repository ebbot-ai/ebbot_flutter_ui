# Getting started

Ebbot Flutter UI is a flutter ui widget for implementing the Ebbot chat bot.
This widget encapsulates the logic in the `ebbot-dart-client` package and provides an drop-in ready solution for rendering a Ebbot Chat in your Flutter App.

## How to Implement Ebbot Flutter UI in Your App

To integrate the Ebbot Flutter UI into your Flutter application, follow these steps:

1. **Add the dependency**: First, you need to add `ebbot_flutter_ui` to your project's `pubspec.yaml` file under the dependencies section:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     ebbot_flutter_ui:
        git:
            url: https://github.com/ebbot-ai/ebbot_flutter_ui
            ref: v0.1.0

1. **Install the package**: Run the following command in your terminal to install the package:
    ```
    flutter pub get
    ```
2. **Import the package**: In the Dart file where you want to use the Ebbot chat widget, import the package:
    ```dart
    import 'package:ebbot_flutter_ui/v1/ebbot_flutter_ui.dart';
    ```
3. **Use the Ebbot Flutter UI widget**:  You can now use the Ebbot Flutter UI widget in your app. Here is a basic example of how to include it in a Flutter app, along with the minimal configuration needed to implement the widget:
    ```dart
    class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                title: Text('Ebbot Chat Example'),
                ),
                body: EbbotFlutterUi(
                  botId: 'your-bot-id'),
            ),
            );
        }
    }
    ```
4. **Run your app**: Finally, run your app. You should now see the Ebbot UI chat interface integrated into your application.

## Demo app

A demo app that implements the `ebbot-flutter-ui` can be found in this repository: https://github.com/ebbot-ai/ebbot_flutter_ui_demo
This is a good starting point for anyone implementing the chat for the first time.