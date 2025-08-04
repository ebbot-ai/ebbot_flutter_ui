import 'package:ebbot_flutter_ui/v1/src/theme/ebbot_text_styles.dart';
import 'package:flutter/material.dart';

enum ContextMenuOptions { restartChat, downloadTranscript, endConversation }

class ContextMenuWidget extends StatelessWidget {
  const ContextMenuWidget({super.key, required this.onSelected});

  final Function(ContextMenuOptions) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ContextMenuOptions>(
      icon: const Icon(Icons.more_horiz, size: 30),
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: ContextMenuOptions.endConversation,
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('End conversation', style: EbbotTextStyles.menuItem),
          ),
        ),
        const PopupMenuItem(
          value: ContextMenuOptions.restartChat,
          child: ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Restart chat', style: EbbotTextStyles.menuItem),
          ),
        ),
        const PopupMenuItem(
          value: ContextMenuOptions.downloadTranscript,
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text('Download transcript', style: EbbotTextStyles.menuItem),
          ),
        ),
      ],
    );
  }
}
