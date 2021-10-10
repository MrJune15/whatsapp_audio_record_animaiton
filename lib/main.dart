import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double _rightPosition = 16;
  double _bottomPosition = 8;
  double _radius = 25;
  double _lockRadius = 0;
  double _fractionOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  bottom: 66, left: 16, right: 16, top: 16),
              child: ListView(
                children: [ChatAudioListTile()],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                margin: const EdgeInsets.only(
                    right: 16, left: 16, bottom: 8, top: 8),
                width: double.maxFinite,
                height: 50,
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Write a message...',
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: 50,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: _rightPosition,
              bottom: _bottomPosition,
              child: GestureDetector(
                onLongPressMoveUpdate: (details) {
                  var hPosition = details.offsetFromOrigin.dx * -1;
                  var vPosition = details.offsetFromOrigin.dy * -1;

                  print(
                      'hPosition : $hPosition , vPosition : $vPosition, _rightPosition : $_rightPosition');

                  if (hPosition < context.size!.width * .35) {
                    setState(() {
                      _rightPosition = hPosition < 16 ? 16 : hPosition;
                    });
                  }
                },
                onLongPressEnd: (detail) {
                  print('onLongPressEnd : ${detail.localPosition}');

                  setState(() {
                    _radius = 25;
                    _rightPosition = 16;
                    _bottomPosition = 8;
                    _fractionOffset = 0;
                    _lockRadius = 0;
                  });
                },
                onLongPress: () {
                  setState(() {
                    _radius = 50;
                    _rightPosition = 16;
                    _bottomPosition = 8;
                    _fractionOffset = .2;
                    _lockRadius = 20;
                  });
                },
                child: FractionalTranslation(
                  translation: Offset(_fractionOffset, _fractionOffset),
                  child: CircleAvatar(
                    child: Icon(Icons.mic),
                    radius: _radius,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 130,
              child: CircleAvatar(
                child: Icon(
                  Icons.lock_open_rounded,
                  size: _lockRadius,
                ),
                radius: _lockRadius,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatAudioListTile extends StatelessWidget {
  const ChatAudioListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ChatTileClipper(),
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(left: 100),
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            CircleAvatar(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.play_circle_fill),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatTileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    Path path = Path()
      ..lineTo(0, 0)
      ..lineTo(width - 12, 0)
      ..lineTo(width - 12, height - 8)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
