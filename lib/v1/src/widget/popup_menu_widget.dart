import 'package:flutter/material.dart';

enum PopupMenuOptions { restartChat, downloadTranscript, endConversation }

class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key, required this.onSelected});

  final Function(PopupMenuOptions) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupMenuOptions>(
      icon: const Icon(Icons.more_horiz, size: 30),
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: PopupMenuOptions.endConversation,
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('End conversation'),
          ),
        ),
        const PopupMenuItem(
          value: PopupMenuOptions.restartChat,
          child: ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Restart chat'),
          ),
        ),
        const PopupMenuItem(
          value: PopupMenuOptions.downloadTranscript,
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text('Download transcript'),
          ),
        ),
      ],
    );
  }
}
