import 'package:flutter/material.dart';

/// Centralized font size definitions for the Ebbot Flutter UI.
/// This ensures consistency across all widgets and makes it easy to
/// adjust font sizes globally.
class EbbotFontSizes {
  /// Small text size - used for typing indicators and captions
  static const double small = 12.0;

  /// Body text size - used for messages, buttons, and descriptions
  static const double body = 14.0;

  /// Subtitle text size - used for section titles and major buttons
  static const double subtitle = 16.0;

  /// Title text size - used for page titles
  static const double title = 20.0;

  /// Large title text size - used for main page titles
  static const double largeTitle = 24.0;
}

/// Pre-defined text styles for common use cases throughout the app.
/// These styles ensure consistency and make it easy to update
/// the appearance of text globally.
class EbbotTextStyles {
  /// Standard message body text style
  static const TextStyle messageBody = TextStyle(
    fontSize: EbbotFontSizes.body,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Received message body text style with neutral color
  static TextStyle receivedMessageBody(Color color) => TextStyle(
        color: color,
        fontSize: EbbotFontSizes.body,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  /// Sent message body text style with neutral color
  static TextStyle sentMessageBody(Color color) => TextStyle(
        color: color,
        fontSize: EbbotFontSizes.body,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  /// Button text style
  static const TextStyle button = TextStyle(
    fontSize: EbbotFontSizes.body,
    fontWeight: FontWeight.bold,
  );

  /// Disabled button text style
  static const TextStyle buttonDisabled = TextStyle(
    fontSize: EbbotFontSizes.body,
    fontWeight: FontWeight.normal,
  );

  /// Section title text style
  static const TextStyle sectionTitle = TextStyle(
    fontSize: EbbotFontSizes.subtitle,
    fontWeight: FontWeight.bold,
  );

  /// Page title text style
  static const TextStyle pageTitle = TextStyle(
    fontSize: EbbotFontSizes.largeTitle,
    fontWeight: FontWeight.bold,
  );

  /// Subtitle text style
  static const TextStyle subtitle = TextStyle(
    fontSize: EbbotFontSizes.subtitle,
    fontWeight: FontWeight.bold,
    height: 1,
  );

  /// Small text style for typing indicators
  static const TextStyle typingIndicator = TextStyle(
    fontSize: EbbotFontSizes.small,
    fontWeight: FontWeight.w500,
  );

  /// Menu item text style
  static const TextStyle menuItem = TextStyle(
    fontSize: EbbotFontSizes.body,
  );

  /// Description text style
  static const TextStyle description = TextStyle(
    fontSize: EbbotFontSizes.body,
  );
}