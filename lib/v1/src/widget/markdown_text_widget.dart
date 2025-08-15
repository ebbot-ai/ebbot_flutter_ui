import 'package:ebbot_flutter_ui/v1/src/theme/ebbot_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that renders markdown-formatted text for chat messages.
///
/// This widget supports common markdown syntax including:
/// - Bold text (**text**)
/// - Italic text (*text*)
/// - Links [text](url)
/// - Inline code (`code`)
///
/// The styling is designed to integrate seamlessly with the chat UI
/// and follows the Ebbot design system.
class MarkdownTextWidget extends StatelessWidget {
  /// The markdown text to render
  final String text;

  /// The text color to use for the rendered content
  final Color? textColor;

  /// Whether this is a received message (affects styling)
  final bool isReceived;

  /// Optional padding around the markdown content
  final EdgeInsetsGeometry? padding;

  const MarkdownTextWidget({
    Key? key,
    required this.text,
    this.textColor,
    this.isReceived = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseStyle = isReceived
        ? EbbotTextStyles.receivedMessageBody(textColor ??
            Theme.of(context).textTheme.bodyMedium?.color ??
            Colors.black)
        : EbbotTextStyles.sentMessageBody(textColor ?? Colors.white);

    final markdownWidget = MarkdownBody(
      data: text,
      shrinkWrap: true,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        // Base text style
        p: baseStyle,

        // Bold text styling
        strong: baseStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),

        // Italic text styling
        em: baseStyle.copyWith(
          fontStyle: FontStyle.italic,
        ),

        // Code styling
        code: baseStyle.copyWith(
          fontFamily: 'monospace',
          backgroundColor: isReceived
              ? Colors.grey.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.1),
        ),

        // Link styling
        a: baseStyle.copyWith(
          color: isReceived ? Colors.blue : Colors.white,
          decoration: TextDecoration.underline,
        ),

        // Remove default margins for better chat integration
        pPadding: EdgeInsets.zero,
        blockquotePadding: EdgeInsets.zero,
      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          final uri = Uri.parse(href);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
    );

    // Apply padding if provided
    if (padding != null) {
      return Padding(
        padding: padding!,
        child: markdownWidget,
      );
    }

    return markdownWidget;
  }
}
