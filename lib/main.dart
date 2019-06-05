import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Duration animationDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 300);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey(); //<--Create a key
  Rect rect; //<--Declare field of rect

  void _onTap() async {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));  //<-- set rect to be size of fab
    WidgetsBinding.instance.addPostFrameCallback((_) {                //<-- on the next frame...
      setState(() =>
      rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide)); //<-- set rect to be big
      Future.delayed(animationDuration + delay, _goToNextPage); //<-- after delay, go to next page
    });


  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: NewPage()))
        .then((_) => setState(() => rect = null));
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration, //<--specify the animation duration
      left: rect.left,
      //<-- Margin from left
      right: MediaQuery.of(context).size.width - rect.right,
      //<-- Margin from right
      top: rect.top,
      //<-- Margin from top
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      //<-- Margin from bottom
      child: Container(
        //<-- Blue cirle
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(title: Text('Fab overlay transition')),
          body: Center(child: Text('This is first page')),
          floatingActionButton: RectGetter(
            key: rectGetterKey,
            child: FloatingActionButton(
              onPressed: _onTap,
              child: Icon(Icons.mail_outline),
            ),
          ),
        ),
        _ripple(), //<-- Add the ripple widget
      ],
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NewPage'),
      ),
    );
  }
}
