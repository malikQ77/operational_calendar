import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'Widgets/home.dart' as Home;
import 'Routes/routesHandler.dart' as RoutesHandler;

void main() {
  runApp(Calendar());
}



class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Operational Calendar',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFFFFFFF, {
          50: Color(0xFFFFFFFF),
          100: Color(0xFFFFFFFF),
          200: Color(0xFFFFFFFF),
          300: Color(0xFFFFFFFF),
          400: Color(0xFFFFFFFF),
          500: Color(0xFFFFFFFF),
          600: Color(0xFFFFFFFF),
          700: Color(0xFFFFFFFF),
          800: Color(0xFFFFFFFF),
          900: Color(0xFFFFFFFF),
        }),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalendarApp(title: 'Operational Calendar'),
    );
  }
}


class AnimatedClass {
  final String label;
  final Color color;
  final Widget child;

  const AnimatedClass({
    @required this.label,
    @required this.color,
    @required this.child,
  });
}


class CalendarApp extends StatefulWidget {
  CalendarApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CalendarAppState createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp>
    with TickerProviderStateMixin {


  List<AnimatedClass> animatedText() => <AnimatedClass>[

    AnimatedClass(
      label: 'Typer',
      color: Colors.white,
      child: SizedBox(
        child: TyperAnimatedTextKit(
          isRepeatingAnimation: false,
          repeatForever: false,
          text: [
            'operational calendar',
          ],
          onFinished: () {

            Navigator.of(context).push(RoutesHandler.route(Home.HomePage()));
          },
          speed: const Duration(milliseconds: 100),
          textStyle: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Aramco',
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 1.0,
                  color: Color(0xffdedede),
                ),
              ],
              color: const Color(0xff5b5a5f)),
        ),
      ),
    ),
  ];


  List<AnimatedClass> _animation;


  @override
  void initState() {
    super.initState();
    _animation = animatedText();
  }


  Widget build(BuildContext context) {
    final animatedTextExample = _animation[0];
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 200),
                  fadeIn: true,
                  slidingCurve: Curves.fastLinearToSlowEaseIn,
                  slidingBeginOffset: const Offset(0, 0),
                  child: Image.asset(
                    'assets/saudi-aramco-logo.png',
                    width: 175,
                    height: 60,
                  ),
                ),
              ),
              new Container(
                decoration: BoxDecoration(color: animatedTextExample.color),
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 1000),
                  fadeIn: true,
                  slidingCurve: Curves.fastLinearToSlowEaseIn,
                  slidingBeginOffset: const Offset(0.0, 0),
                  child: Center(child: animatedTextExample.child),
                ),
              ),
            ],
          ),
          Positioned.fill(
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text("Version 1.0"),
              ))
        ]
        )
    );
  }
}

