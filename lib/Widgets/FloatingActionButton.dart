import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:aramco_calendar/Widgets/Login.dart' as Login;
import 'package:aramco_calendar/Routes/routesHandler.dart' as RoutesHandler;
import 'package:flutter_session/flutter_session.dart';

class FloatingActionButton extends StatefulWidget {
  Function callback_FloatingActionButton;


  FloatingActionButton(this.callback_FloatingActionButton);

  @override
  _FloatingActionButtonState createState() => new _FloatingActionButtonState();
}
class _FloatingActionButtonState extends State<FloatingActionButton>  with SingleTickerProviderStateMixin {

  Animation<double> _animation;
  AnimationController _animationController;

  bool _isBubbleClicked = false;
  bool _isLogin = false;
  bool _showAddTask = false;
  bool _showAddEvent = false;
  bool _showAddReminder = false;

  @override
  void initState() {


    FlutterSession().get("is_login").then((value){
      if(value != null){
        _isLogin = value;
      }else{
        _isLogin = false;
      }
    });


    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    final curvedAnimation =
    CurvedAnimation(curve: Curves.slowMiddle, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);




    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new FloatingActionBubble(
      // Menu items
      // isBubbleClicked: _isBubbleClicked,
      items: <Bubble>[
        Bubble(
          title: "Reminder",
          iconColor: Colors.white,
          bubbleColor: Colors.indigo,
          icon: Icons.timer_rounded,
          titleStyle: TextStyle(fontSize: 12, color: Colors.white),
          onPress: () {
            setState(() {
              _isBubbleClicked = !_isBubbleClicked;
            });
            _animationController.reverse();
            _isLogin
                ? setState(() {
              _isBubbleClicked = !_isBubbleClicked;
              _showAddReminder = true;
            })
                : Navigator.of(context)
                .push(RoutesHandler.route(Login.Login()));
            this.widget.callback_FloatingActionButton(_isLogin , _showAddTask , _showAddEvent , _showAddReminder);
          },
        ),
        Bubble(
          title: "Task",
          iconColor: Colors.white,
          bubbleColor: Colors.purple,
          icon: Icons.assignment_turned_in_outlined,
          titleStyle: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          onPress: () {
            _animationController.reverse();
            _isLogin
                ? setState(() {
              _isBubbleClicked = !_isBubbleClicked;
              _showAddTask = true;
            })
                : Navigator.of(context)
                .push(RoutesHandler.route(Login.Login()));

            this.widget.callback_FloatingActionButton(_isLogin , _showAddTask , _showAddEvent , _showAddReminder);
          },
        ),
        Bubble(
          title: "Event",
          iconColor: Colors.white,
          bubbleColor: Colors.deepOrange,
          icon: Icons.event_outlined,
          titleStyle: TextStyle(fontSize: 12, color: Colors.white),
          onPress: () {
            setState(() {
              _animationController.reverse();
              _isLogin
                  ? setState(() {
                _isBubbleClicked = !_isBubbleClicked;
                _showAddEvent = true;
              })
                  : Navigator.of(context)
                  .push(RoutesHandler.route(Login.Login()));
              _isBubbleClicked = !_isBubbleClicked;
            });
            this.widget.callback_FloatingActionButton(_isLogin , _showAddTask , _showAddEvent , _showAddReminder);
          },
        ),
      ],

      animation: _animation,

      onPress: () {
        _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward();

        setState(() {
          _showAddTask = false;
          _showAddEvent = false;
          _isBubbleClicked = !_isBubbleClicked;
        });

        this.widget.callback_FloatingActionButton(_isLogin , _showAddTask , _showAddEvent , _showAddReminder);
      },

      iconColor: Colors.white,
      iconData: _isBubbleClicked ? Icons.close : Icons.add,
      backGroundColor:
      _isBubbleClicked ? Color(0xFF84bd00) : Color(0xFF00a3e0),
    );
  }
}