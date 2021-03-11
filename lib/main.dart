import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/home.dart' as Home;
import 'Routes/routesHandler.dart' as RoutesHandler;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });

  String title;
  String body;

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      title: json["notification"]["title"],
      body: json["notification"]["body"],
    );
  }
}

Future<void> main() async {
  runApp(Calendar());
  FirebaseMessaging _messaging = FirebaseMessaging();
  await Firebase.initializeApp();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettingsIOs = IOSInitializationSettings();
  var initSetttings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOs);

  flutterLocalNotificationsPlugin.initialize(initSetttings,
      onSelectNotification: null);
  _messaging.configure(onMessage: (message) async {
    print('onMessage received: $message');

    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, message["notification"]["title"], message["notification"]["body"], platform,
        payload: 'Welcome to the Local Notification demo');
    // Parse the message received
    PushNotification notification = PushNotification.fromJson(message);
    print(notification);
  });

  SharedPreferences.setMockInitialValues({});
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('user_id', null);
  prefs.setBool('is_login', false);

  _messaging.getToken().then((token) {
    print('Token: $token');
  }).catchError((e) {
    print(e);
  });
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
                Navigator.of(context)
                    .push(RoutesHandler.route(Home.HomePage()));
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
        ]));
  }
}
