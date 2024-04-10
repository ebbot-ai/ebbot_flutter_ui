import 'package:ebbot_dart_client/entities/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;

  const Carousel({Key? key, required this.content, required this.configuration})
      : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final content = widget.content;

    if (content.value['slides'] is! List) {
      return Container();
    }

    List slides = content.value['slides'];

    List<Widget> pageChildren = [
      Expanded(
        child: PageView.builder(
          itemCount: slides.length,
          controller: _controller,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                // Image
                Expanded(
                  child: Image.network(
                    slides[index]["url"],
                    fit: BoxFit.cover,
                  ),
                ),
                // Title
                Text(
                  slides[index]["title"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                // Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    slides[index]["description"],
                    textAlign: TextAlign.center,
                  ),
                ),
                // Text Message
                Text(
                  "Your text message here",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            );
          },
        ),
      )
    ];

    if (slides.isNotEmpty) {
      pageChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDots(slides),
        ),
      );
    }

    return Container(
      height: 400,
      child: Column(
        children: pageChildren,
      ),
    );
  }

  List<Widget> _buildDots(List slides) {
    final theme = widget.configuration.theme;
    List<Widget> dots = [];
    for (int i = 0; i < slides.length; i++) {
      dots.add(
        Container(
          margin: EdgeInsets.all(5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? theme.primaryColor
                : theme.receivedMessageBodyTextStyle.color,
          ),
        ),
      );
    }
    return dots;
  }
}
