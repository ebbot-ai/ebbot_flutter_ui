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
            title: Text('End conversation', style: TextStyle(fontSize: 14)),
          ),
        ),
        const PopupMenuItem(
          value: ContextMenuOptions.restartChat,
          child: ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Restart chat', style: TextStyle(fontSize: 14)),
          ),
        ),
        const PopupMenuItem(
          value: ContextMenuOptions.downloadTranscript,
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text('Download transcript', style: TextStyle(fontSize: 14)),
          ),
        ),
      ],
    );
  }
}
