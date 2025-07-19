
// Demo app

import 'package:ebbot_flutter_ui/ebbot_flutter_ui.dart';
import 'package:ebbot_flutter_ui/v1/src/util/extension.dart';
import 'package:flutter/material.dart';

class EbbotDemoAppWithPages extends StatelessWidget {
  final String botId;
  final EbbotConfiguration configuration;

  const EbbotDemoAppWithPages({
    super.key,
    required this.botId,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebbot Stateful chat with pages demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: HexColor.fromHex("#046C4C"),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: EbbotFlutterUi(
                    botId: botId,
                    configuration: configuration,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EbbotDemoAppWithPagesHome extends StatefulWidget {
  final String botId;
  final EbbotConfiguration configuration;
  const EbbotDemoAppWithPagesHome(
      {super.key, required this.botId, required this.configuration});
  @override
  EbbotDemoAppWithPagesHomeState createState() =>
      EbbotDemoAppWithPagesHomeState();
}

class EbbotDemoAppWithPagesHomeState extends State<EbbotDemoAppWithPagesHome> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebbot Chat Demo'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const ContentPage(
              key: PageStorageKey('Page1'), color: Colors.red, title: 'Page 1'),
          const ContentPage(
              key: PageStorageKey('Page2'),
              color: Colors.green,
              title: 'Page 2'),
          Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: EbbotFlutterUi(
                  key: const PageStorageKey('ChatPage'),
                  botId: widget.botId,
                  configuration: widget.configuration))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Page 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Page 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}

class ContentPage extends StatefulWidget {
  final Color color;
  final String title;

  const ContentPage({super.key, required this.color, required this.title});

  @override
  ContentPageState createState() => ContentPageState();
}

class ContentPageState extends State<ContentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Container(
        color: widget.color,
        child: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
