# Getting Started

Ebbot Flutter UI is a Flutter UI widget for implementing the Ebbot chat bot. This widget encapsulates the logic in the `ebbot_dart_client` package and provides a drop-in ready solution for rendering an Ebbot Chat in your Flutter App.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Basic Implementation](#basic-implementation)
- [Demo Application](#demo-application)
- [Next Steps](#next-steps)

## Prerequisites

Before getting started, ensure you have:
- Flutter SDK >=3.2.6 <4.0.0
- A valid Ebbot bot ID
- Access to the Ebbot Flutter UI repository

## Installation

### 1. Add the dependency

Add `ebbot_flutter_ui` to your project's `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  ebbot_flutter_ui:
    git:
      url: https://github.com/ebbot-ai/ebbot_flutter_ui
      ref: main  # or specify a version tag like v0.2.6
```

### 2. Install the package

Run the following command in your terminal:

```bash
flutter pub get
```

### 3. Import the package

In your Dart file, import the library:

```dart
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';
```

## Basic Implementation

Here's a minimal example to get you started:

```dart
import 'package:flutter/material.dart';
import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebbot Chat Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ebbot Chat Example'),
        ),
        body: EbbotFlutterUi(
          botId: 'your-bot-id',
          configuration: EbbotConfigurationBuilder()
            .environment(Environment.production)
            .build(),
        ),
      ),
    );
  }
}
```

### Running your app

After implementing the code above, run your app:

```bash
flutter run
```

You should now see the Ebbot chat interface integrated into your application.

## Demo Application

A complete example application is available in two locations:

1. **In this repository**: Check the [`example/`](../example/) directory for a fully functional demo app
2. **Standalone repository**: https://github.com/ebbot-ai/ebbot_flutter_ui_demo

The example demonstrates:
- Basic setup and configuration
- Multiple environment configurations
- User attribute passing
- Custom callbacks
- Multi-page integration

## Next Steps

Now that you have the basic implementation working, explore these topics:

- [**Basic Configuration**](./basics.md) - Learn about configuration options
- [**Styling and Theming**](./styling.md) - Customize the chat appearance
- [**User Attributes**](./user-attributes.md) - Pass user data for personalization
- [**Callbacks**](./callbacks.md) - Handle chat events
- [**API Controller**](./api-controller.md) - Control the chat programmatically

For a complete implementation example with all features, see the [Advanced Configuration](./advanced.md) guide.