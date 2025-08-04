import 'package:ebbot_dart_client/entity/button_data/button_data.dart';
import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/service/log_service.dart';
import 'package:ebbot_flutter_ui/v1/src/theme/ebbot_text_styles.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/url_button_widget.dart';
import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  final MessageContent content;
  final EbbotConfiguration configuration;
  final void Function(String, {ButtonData? buttonData}) onURlPressed;
  final void Function(String, {String? state, ButtonData? buttonData})
      onScenarioPressed;
  final void Function(String, String, {ButtonData? buttonData})
      onVariablePressed;

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

  final _serviceLocator = ServiceLocator();
  get _logger => _serviceLocator.getService<LogService>().logger;

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
            var slide = slides[index];

            var urls = slide['urls'];

            List<UrlButtonWidget> urlsList = [];

            if (urls is List) {
              urlsList = urls
                  .map((url) => UrlButtonWidget(
                      url: url,
                      configuration: widget.configuration,
                      onURlPressed: (String url, {ButtonData? buttonData}) {
                        widget.onURlPressed(url, buttonData: buttonData);
                      },
                      onScenarioPressed: (String scenario,
                          {String? state, ButtonData? buttonData}) {
                        widget.onScenarioPressed(scenario,
                            state: state, buttonData: buttonData);
                      },
                      onVariablePressed: (String name, String value,
                          {ButtonData? buttonData}) {
                        widget.onVariablePressed(name, value,
                            buttonData: buttonData);
                      } /*,
                        onButtonClickPressed: (String buttonId, String value) {
                          widget.onVariablePressed(buttonId, value);
                        },*/
                      ))
                  .toList();
            }

            return Column(children: [
              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Text(
                  slides[index]["title"],
                  style: EbbotTextStyles.sectionTitle,
                ),
              ),
              // Description
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Text(
                  slides[index]["description"],
                  textAlign: TextAlign.center,
                  style: EbbotTextStyles.description,
                ),
              ),
              // Image
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  width: double.infinity,
                  child: Image.network(
                    slides[index]["url"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // List of urls
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: urlsList,
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

    return SizedBox(
      height: 500,
      child: Column(
        children: pageChildren,
      ),
    );
  }

  List<Widget> _buildDots(List slides) {
    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();

    final chatStyleConfig = ebbotClientService.client.chatStyleConfig;
    if (chatStyleConfig == null) {
      throw Exception(
          'Chat style configuration is not available. Please ensure it is set up correctly.');
    }

    final primaryColor =
        HexColor.fromHex(chatStyleConfig.regular_btn_background_color);

    List<Widget> dots = [];
    for (int i = 0; i < slides.length; i++) {
      dots.add(
        Container(
          margin: const EdgeInsets.all(5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? primaryColor
                : Colors
                    .grey, // TODO: Maybe use fallback color for not active dots
          ),
        ),
      );
    }
    return dots;
  }
}
