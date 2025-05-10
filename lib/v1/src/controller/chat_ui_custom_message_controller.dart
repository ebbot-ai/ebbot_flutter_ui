import 'package:ebbot_dart_client/entity/button_data/button_data.dart';
import 'package:ebbot_dart_client/entity/message/message.dart';
import 'package:ebbot_flutter_ui/v1/configuration/ebbot_configuration.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/carousel_widget.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/list_widget.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/rating_widget.dart';
import 'package:ebbot_flutter_ui/v1/src/widget/url_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:url_launcher/url_launcher.dart';

// A controller for handling custom flutter chat ui messages
class ChatUiCustomMessageController {
  final EbbotConfiguration configuration;
  final Function() handleRestartConversation;
  final _serviceLocator = ServiceLocator();

  ChatUiCustomMessageController(
      {required this.configuration, required this.handleRestartConversation});

  Widget processMessage(types.CustomMessage message,
      {required int messageWidth}) {
    if (message.metadata == null) {
      return Container();
    }

    MessageContent content = MessageContent.fromJson(message.metadata!);

    switch (content.type) {
      case 'url':
        return _processUrl(content);
      case 'rating_request':
        return _processRatingRequest(content);
      case 'carousel':
        return _processCarousel(content);
      case 'list':
        return _processList(content);
      default:
        return Container();
    }
  }

  Widget _processList(MessageContent content) {
    return ListWidget(content: content, configuration: configuration);
  }

  Widget _processCarousel(MessageContent content) {
    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    return CarouselWidget(
      content: content,
      configuration: configuration,
      onURlPressed: (String url, {ButtonData? buttonData}) async {
        _processUrlClick(url, buttonData: buttonData);
      },
      onScenarioPressed: (String scenario,
          {String? state, ButtonData? buttonData}) {
        client.sendScenarioMessage(scenario,
            state: state, buttonData: buttonData);
      },
      onVariablePressed: (String name, String value, {ButtonData? buttonData}) {
        client.sendVariableMessage(name, value, buttonData: buttonData);
      },
    );
  }

  Widget _processRatingRequest(MessageContent content) {
    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    return RatingWidget(
      content: content,
      configuration: configuration,
      onRatingChanged: (rating) {
        client.sendRatingMessage(rating);
      },
    );
  }

  Widget _processUrl(MessageContent content) {
    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    return UrlBoxWidget(
        content: content,
        configuration: configuration,
        onURlPressed: (url, {ButtonData? buttonData}) async {
          _processUrlClick(url, buttonData: buttonData);
        },
        onScenarioPressed: (scenario, {String? state, ButtonData? buttonData}) {
          client.sendScenarioMessage(scenario,
              state: state, buttonData: buttonData);
        },
        onVariablePressed: (name, value, {ButtonData? buttonData}) {
          client.sendVariableMessage(name, value, buttonData: buttonData);
        });
  }

  void _processUrlClick(String url, {ButtonData? buttonData}) async {
    final client = _serviceLocator.getService<EbbotDartClientService>().client;
    var uri = Uri.parse(url);

    // This is a bit hacky, for the other types of buttons we send a message back over the websocket
    // which contains the button data, but for url buttons we just open the url directly
    // so we need to send the button data here
    if (buttonData != null) {
      client.sendButtonClickedMessage(buttonData);
    }

    // If uri protocol is ebbot://reset, reset the conversation by letting the parent know
    if (uri.scheme == 'ebbot' && uri.host == 'reset') {
      handleRestartConversation();
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
