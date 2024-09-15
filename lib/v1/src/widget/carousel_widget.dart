import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/url_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CarouselWidget extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;
  final void Function(String) onURlPressed;
  final void Function(String) onScenarioPressed;
  final void Function(String, String) onVariablePressed;

  const CarouselWidget(
      {Key? key,
      required this.content,
      required this.configuration,
      required this.onURlPressed,
      required this.onScenarioPressed,
      required this.onVariablePressed})
      : super(key: key);

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;

  final logger = GetIt.I.get<LogService>().logger;

  @override
  Widget build(BuildContext context) {
    logger?.i("Building carousel, page: $_currentPage");
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
            logger?.i("Page changed to $page, current page: $_currentPage");
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            var slide = slides[index];

            var urls = slide['urls'];

            List<UrlButtonWidget> urlsList = [];

            if (urls is List) {
              urlsList = urls
                  .map((url) => UrlButtonWidget(
                        url: url,
                        configuration: widget.configuration,
                        onURlPressed: (String url) {
                          widget.onURlPressed(url);
                        },
                        onScenarioPressed: (String scenario) {
                          widget.onScenarioPressed(scenario);
                        },
                        onVariablePressed: (String name, String value) {
                          widget.onVariablePressed(name, value);
                        },
                        onButtonClickPressed: (String buttonId, String value) {
                          widget.onVariablePressed(buttonId, value);
                        },
                      ))
                  .toList();
            }

            return Column(children: [
              // Title
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Text(
                  slides[index]["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // Description
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Text(
                  slides[index]["description"],
                  textAlign: TextAlign.center,
                ),
              ),
              // Image
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  width: double.infinity,
                  child: Image.network(
                    slides[index]["url"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // List of urls
              Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Column(
                    children: urlsList,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ))
            ]);
          },
        ),
      )
    ];

    if (slides.length > 1) {
      pageChildren.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDots(slides),
        ),
      ));
    }

    return Container(
      height: 500,
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
            color: _currentPage == i ? theme.primaryColor : Colors.grey,
          ),
        ),
      );
    }
    return dots;
  }
}
