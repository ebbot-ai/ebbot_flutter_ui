import 'package:ebbot_dart_client/entity/chat_config/chat_style_v2_config.dart';
import 'package:ebbot_flutter_ui/v1/src/initializer/service_locator.dart';
import 'package:ebbot_flutter_ui/v1/src/service/ebbot_dart_client_service.dart';
import 'package:ebbot_flutter_ui/v1/src/theme/ebbot_text_styles.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:flutter/material.dart';

class StartPageWidget extends StatefulWidget {
  final VoidCallback? onStartConversation;
  final Function({String? scenario, String? url})? onCardButtonPressed;

  StartPageWidget(
      {Key? key, this.onStartConversation, this.onCardButtonPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StartPageWidgetState();
}

class _StartPageWidgetState extends State<StartPageWidget> {
  final ServiceLocator _serviceLocator = ServiceLocator();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final ebbotClientService =
        _serviceLocator.getService<EbbotDartClientService>();

    final styleConfig = ebbotClientService.client.chatStyleConfig;

    if (styleConfig == null) {
      throw Exception(
          'Chat style configuration is not available. Please ensure it is set up correctly.');
    }

    final headerText = styleConfig.header_text;
    final headerTitle = styleConfig.header_title;
    final avatarImageUrl = styleConfig.avatar.src;

    final startConversationTextColor =
        HexColor.fromHex(styleConfig.regular_btn_text_color);
    final startConversationBackgroundColor =
        HexColor.fromHex(styleConfig.regular_btn_background_color);

    final avatarImage = avatarImageUrl != null
        ? Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ClipOval(
              child: Image.network(
                avatarImageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ))
        : Container();

    final logoImageUrl = styleConfig.logo.src;
    final logoImageContainer = logoImageUrl != null
        ? Container(
            padding: const EdgeInsets.only(bottom: 20, left: 20, top: 0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 100,
              ),
              child: Image.network(
                logoImageUrl,
                fit: BoxFit.contain,
              ),
            ),
          )
        : Container();

    final headerBackgroundColor = HexColor.fromHex(styleConfig.header_color);

    final cards = styleConfig.start_page_link_cards;
    final cardIconBackgroundColor =
        HexColor.fromHex(styleConfig.icon_plate_color);
    final cardIconTextColor = HexColor.fromHex(styleConfig.icon_icon_color);

    final cardWidgets =
        _buildCardButtons(cards, cardIconBackgroundColor, cardIconTextColor);

    final infoTextCardWidget = _buildInfoTextWidget(styleConfig);

    final cardChildren = <Widget>[
      infoTextCardWidget,
      ...cardWidgets,
    ];

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: headerBackgroundColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(100, 40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: logoImageContainer,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      avatarImage,
                      Text(
                        headerTitle,
                        style: EbbotTextStyles.pageTitle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        headerText,
                        textAlign: TextAlign.center,
                        style: EbbotTextStyles.subtitle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // This is the scrollable area for cards
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -20),
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: cardChildren,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: startConversationBackgroundColor,
                foregroundColor: startConversationTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                widget.onStartConversation?.call();
              },
              child: Text("Start conversation",
                  style: EbbotTextStyles.sectionTitle),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCardButtons(List<StartPageLinkCard> cards,
      Color cardIconBackgroundColor, Color cardIconColor) {
    final iconMappings = {
      'tips': Icons.lightbulb_outline,
      'cart': Icons.shopping_cart_outlined,
      'warning': Icons.warning_amber_outlined,
    };

    final children = cards.map((card) {
      final icon = iconMappings[card.icon] ?? Icons.help_outline;
      final scenario = card.scenario == '' ? null : card.scenario;
      final url = card.url == '' ? null : card.url;
      final cardText = card.text == '' ? null : card.text;
      return _buildCardButton(
        icon,
        card.title,
        cardIconBackgroundColor,
        cardIconColor,
        scenario: scenario,
        url: url,
        text: cardText,
      );
    }).toList();

    return children;
  }

  Widget _buildInfoTextWidget(ChatStyleConfigV2 config) {
    if (!config.info_section_enabled) {
      // If the info section is not enabled, do not show the widget
      return Container();
    }

    if (!config.alert_time_window.shouldShow) {
      // Outside the time window, do not show the widget
      return Container();
    }

    final cardIconBackgroundColor = HexColor.fromHex(config.icon_plate_color);
    final cardIconColor = HexColor.fromHex(config.icon_icon_color);

    final title = config.info_section_title;
    final subtitle = config.info_section_text;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x21535353),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        leading: CircleAvatar(
          backgroundColor: cardIconBackgroundColor,
          child: Icon(Icons.warning, color: cardIconColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _buildCardButton(
    IconData icon,
    String title,
    Color cardIconBackgroundColor,
    Color cardIconColor, {
    String? scenario,
    String? url,
    String? text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x21535353),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        leading: CircleAvatar(
          backgroundColor: cardIconBackgroundColor,
          child: Icon(icon, color: cardIconColor),
        ),
        title: Text(title),
        subtitle: text != null ? Text(text) : null,
        onTap: () {
          widget.onCardButtonPressed?.call(scenario: scenario, url: url);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
