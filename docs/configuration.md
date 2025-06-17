- [Configuration](#configuration)
  - [Styling and theming](#styling-and-theming)
  - [Passing custom user specific attributes](#passing-custom-user-specific-attributes)
  - [Configuring the cloud environment](#configuring-the-cloud-environment)
  - [Enter pressed behaviour](#enter-pressed-behaviour)
  - [Adding a callback handler](#adding-a-callback-handler)
    - [Callback function descriptions](#callback-function-descriptions)
  - [API Controller](#api-controller)
  - [Configuring logging](#configuring-logging)
  - [Configuring chat behaviour](#configuring-chat-behaviour)
  - [Putting everything together](#putting-everything-together)


# Configuration

Configuring Ebbot Flutter UI is done by passing a `EbbotConfiguration` instance to the the `EbbotFlutterUi` widget.

The Ebbot Flutter UI widget has the following configuration options:
- change the underlying theme in `flyer-chat`
- passing user specific attributes
- setting the cloud environment the App is running against
- adding a callback handler for certain events
- controlling certain parts of the application through an api controller

## Styling and theming

As Ebbot Flutter UI is using the `flyer-chat` component under the hood, styling it is done by configure a theme and passing it in the configuration builder like so:
```dart
var config = EbbotConfigurationBuilder()
    .theme(const DarkChatTheme())
    .build();
```

Consult the `flyer-chat` [themeing guide](https://docs.flyer.chat/flutter/chat-ui/themes) for more in depth information on how to style the chat widget.

## Passing custom user specific attributes

To feed the bot with more context about the user, you can pass user attributes in the configuration file, the allowed type is `Map<String, dynamic>`:

```dart
var userAttributes = {
      'name': 'John Doe',
      'email': 'john@doe.com',
      'age': 30,
      'height': 180.0,
      'isPremium': true,
      'lastLogin': DateTime.now().millisecondsSinceEpoch
    };
var config = EbbotConfigurationBuilder()
      .userAttributes(userAttributes)
      .build();
```

## Configuring the cloud environment

Configuring the cloud environment is done by passing a configuration property to the `environment` builder function.

Available configuration options are:
| Environment                          | Configuration Host                           | Chat API Host                                 |
| ------------------------------------ | -------------------------------------------- | --------------------------------------------- |
| `Environment.staging`                | https://ebbot-staging.storage.googleapis.com | (https/wss)://staging.ebbot.app/api/asyngular |
| `Environment.release`                | https://ebbot-release.storage.googleapis.com | (https/wss)://release.ebbot.app/api/asyngular |
| `Environment.googleCanadaProduction` | https://ebbot-ca.storage.googleapis.com      | (https/wss)://ca.ebbot.app/api/asyngular      |
| `Environment.googleEUProduction`     | https://ebbot-v2.storage.googleapis.com      | (https/wss)://v2.ebbot.app/api/asyngular      |
| `Environment.ovhEUProduction`        | https://storage.gra.cloud.ovh.net            | (https/wss)://ebbot.eu/api/asyngular          |

## Enter pressed behaviour

To configure what should happen when enter on the keyboard has been pressed, you can pass the following options:

```dart
var ebbotBehaviourInput = EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
      .build();
```

| Enum Value                                    | Description                                       |
| --------------------------------------------- | ------------------------------------------------- |
| `EbbotBehaviourInputEnterPressed.sendMessage` | Indicates that pressing enter sends a message.    |
| `EbbotBehaviourInputEnterPressed.newline`     | Indicates that pressing enter inserts a new line. |



## Adding a callback handler

Sometimes, it is useful to know what is happening in the widget and when it is happening. To address this, you can pass a callback object when configuring the app:

```dart

// Callback functions


Future<void> onLoadError(EbbotLoadError error) async {
  print(
      "CALLBACK: onLoadError: ${error.type}, ${error.stackTrace} caused by ${error.cause}");
}

Future<void> onLoad() async {
  print("CALLBACK: onLoad");
}

Future<void> onRestartConversation() async {
  print("CALLBACK: onRestartConversation");
}

Future<void> onEndConversation() async {
  print("CALLBACK: onEndConversation");
}

Future<void> onMessage(String message) async {
  print("CALLBACK: onMessage: $message");
}

Future<void> onBotMessage(String message) async {
  print("CALLBACK: onBotMessage: $message");
}

Future<void> onUserMessage(String message) async {
  print("CALLBACK: onUserMessage: $message");
}

Future<void> onStartConversation(String message) async {
  print("CALLBACK: onStartConversation");
}

// Callback configuration object

 var callback = EbbotCallbackBuilder()
      .onLoadError(onLoadError)
      .onLoad(onLoad)
      .onRestartConversation(onRestartConversation)
      .onEndConversation(onEndConversation)
      .onMessage(onMessage)
      .onBotMessage(onBotMessage)
      .onUserMessage(onUserMessage)
      .onStartConversation(onStartConversation)
      .build();

```

### Callback function descriptions


| Method                  | Description                                                      | Parameters                                                                                                         |
| ----------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `onLoadError`           | Called when there is an error during the widget loading process. | `error`: An `EbbotLoadError` object containing details about the error.                                            |
| `onLoad`                | Called when the widget has successfully loaded.                  | No parameters.                                                                                                     |
| `onRestartConversation` | Called when the conversation is restarted.                       | No parameters.                                                                                                     |
| `onEndConversation`     | Called when a conversation ends.                                 | No parameters.                                                                                                     |
| `onMessage`             | Called when a general message is received.                       | `message`: A string containing the message received.                                                               |
| `onBotMessage`          | Called when a message from the bot is received.                  | `message`: A string containing the bot's message.                                                                  |
| `onUserMessage`         | Called when a message from the user is received.                 | `message`: A string containing the user's message.                                                                 |
| `onStartConversation`   | Called when a new conversation starts.                           | No parameters.                                                                                                     |
| `onSessionData`         | Called when the session data is available.                       | `chatId`: The chat ID of the session, which can be provided when initing a chat widget, to restore a chat session. |


## API Controller

In order to communciate with the widget, you can pass an instance of an API controller:
```dart
var apiController = EbbotApiController();
var configuration = EbbotConfigurationBuilder()
      .apiController(apiController)
      .build();
```
> [!IMPORTANT]
> The API controller can only be called once the widget has been fully loaded, which is known when  `onLoad` callback has been invoked or by calling the `isInitialized` method.

| Method                | Description                                       | Parameters                                                                               |
| --------------------- | ------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `isInitialized`       | Checks if the widget is initialized.              | No parameters. Returns `bool`.                                                           |
| `restartConversation` | Restarts the conversation.                        | No parameters.                                                                           |
| `endConversation`     | Ends the current conversation.                    | No parameters.                                                                           |
| `showTranscript`      | Presents the user with the chat transcript.       | No parameters.                                                                           |
| `sendMessage`         | Sends a message to the conversation.              | `message`: A `String` containing the message to be sent.                                 |
| `setUserAttributes`   | Sets attributes for the user in the conversation. | `attributes`: A `Map<String, dynamic>` containing the attributes to be set for the user. |
| `triggerScenario`     | Triggers a specific scenario in the conversation. | `scenarioId`: A `String` identifying the scenario to be triggered.                       |


## Configuring logging
```dart
var logConfiguration = EbbotLogConfigurationBuilder().logLevel(Level.info).enabled(true).build();
```

## Configuring chat behaviour
Currently, there is basic support for customizing the rating icons from the default stars, basically whatever that is a widget. Please note that the provided widget will be sized to fit within 30x30.
```dart
final ratingSelected = Image.asset("assets/sunglasses.png");
final rating =
      Opacity(opacity: 0.5, child: Image.asset("assets/sunglasses.png"));

var chat =
      EbbotChatBuilder().rating(rating).ratingSelected(ratingSelected).build();
```

## Putting everything together

The following is a full fledged example with all configurable options passed to the widget:

```dart

Future<void> onLoadError(EbbotLoadError error) async {
  print(
      "CALLBACK: onLoadError: ${error.type}, ${error.stackTrace} caused by ${error.cause}");
}

Future<void> onLoad() async {
  print("CALLBACK: onLoad");
}

Future<void> onRestartConversation() async {
  print("CALLBACK: onRestartConversation");
}

Future<void> onEndConversation() async {
  print("CALLBACK: onEndConversation");
}

Future<void> onMessage(String message) async {
  print("CALLBACK: onMessage: $message");
}

Future<void> onBotMessage(String message) async {
  print("CALLBACK: onBotMessage: $message");
}

Future<void> onUserMessage(String message) async {
  print("CALLBACK: onUserMessage: $message");
}

Future<void> onStartConversation(String message) async {
  print("CALLBACK: onStartConversation");
}

Future<void> onSessionData(String chatId) async {
  print("CALLBACK: onSessionData, chatId: $chatId");
}

var userAttributes = {
    'name': 'John Doe',
    'email': 'john@doe.com',
    'age': 30,
    'height': 180.0,
    'isPremium': true,
    'lastLogin': DateTime.now().millisecondsSinceEpoch
  };

  var userConfiguration =
      EbbotUserConfigurationBuilder().userAttributes(userAttributes).build();

  var session

  var callback = EbbotCallbackBuilder()
      .onLoadError(onLoadError)
      .onLoad(onLoad)
      .onRestartConversation(onRestartConversation)
      .onEndConversation(onEndConversation)
      .onMessage(onMessage)
      .onBotMessage(onBotMessage)
      .onUserMessage(onUserMessage)
      .onStartConversation(onStartConversation)
      .onSessionData(onSessionData)
      .build();

  var ebbotBehaviourInput = EbbotBehaviourInputBuilder()
      .enterPressed(EbbotBehaviourInputEnterPressed.sendMessage)
      .build();
  var behaviour = EbbotBehaviourBuilder()
      .showContextMenu(true) // Disable this if you want to use the apiController instead
      .input(ebbotBehaviourInput).build();

  var logConfiguration = EbbotLogConfigurationBuilder().logLevel(EbbotLogLevel.info).enabled(true).build();

  final ratingSelected = Image.asset("assets/sunglasses.png");
  final rating =
        Opacity(opacity: 0.5, child: Image.asset("assets/sunglasses.png"));

  var chat = EbbotChatBuilder()
        .rating(rating)
        .ratingSelected(ratingSelected).build();
  var someChatId = ""; // Provide your chatId here, it can be obtained from the onSessionData callback
  var session = EbbotSessionBuilder().chatId(someChatId).build();

  var configuration = EbbotConfigurationBuilder()
      .apiController(apiController)
      .environment(Environment.ovhEUProduction)
      .userConfiguration(userConfiguration)
      .behaviour(behaviour)
      .theme(const DarkChatTheme())
      .callback(callback)
      .logConfiguration(logConfiguration)
      .chat(chat)
      .build();


  class MyApp extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
            return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                title: Text('Ebbot Chat Example'),
                ),
                body: EbbotFlutterUi(
                  botId: 'your-bot-id')
                  configuration: configuration,
            ),
            );
        }
    }

```

