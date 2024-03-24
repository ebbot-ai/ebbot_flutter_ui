library EbbotUiWidget;
import 'package:ebbot_demo/ebbot_ui_widget.dart';
import 'package:ebbot_demo/main.dart';
import 'package:flutter/material.dart';

class EbbotUiWidgetFullscreen extends StatelessWidget {
  
  final String botId;
  final double widthRatio = 0.9;
  final double heightRatio = 0.9;

  EbbotUiWidgetFullscreen({required this.botId});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect( // Apply clip to ensure rounded corners for content
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: MediaQuery.of(context).size.width * widthRatio, // 80% of screen width
          height: MediaQuery.of(context).size.height * heightRatio, // 80% of screen height
          child: Column(
            children: [
              // Dismiss button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              // Content
              Expanded(
                child: EbbotUiWidget(botId: botId), // Assuming EbbotUiWidget is your chat UI
              ),
            ],
          ),
        ),
      ),
    );
  }
}