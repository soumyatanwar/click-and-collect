//Implemented Floating Action button for easier access (Filter, Search, Cart)
import 'package:flutter/material.dart';
import 'package:Shrine/colors.dart';
import 'package:Shrine/searchbar.dart';
import 'package:Shrine/shopping_cart.dart';
import 'package:Shrine/login.dart';
import 'dart:math' as math;

class AnimatedFab extends StatefulWidget {
  final VoidCallback onClick;
  const AnimatedFab({Key key, this.onClick}) : super(key: key);
  @override
  _AnimatedFabState createState() => new _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = new ColorTween(begin: kShrinePink100, end: Colors.red)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: new AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildExpandedBackground(),
              _buildOption(Icons.search, 0.0),
              _buildOption(Icons.shopping_cart, -math.pi / 3),
              _buildOption(Icons.account_circle, -2 * math.pi / 3),
              _buildFabCore(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, double angle) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }
    return new Transform.rotate(
      angle: angle,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Padding(
          padding: new EdgeInsets.only(top: 8.0),
          child: new IconButton(
            onPressed: (){
              if(icon == Icons.search){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => SearchBar()),
                );
              }
              else if(icon == Icons.shopping_cart){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => ShoppingCartPage()),
                );
              }
              else if(icon == Icons.account_circle){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                );
              }
            },
            icon: new Transform.rotate(
              angle: -angle,
              child: new Icon(
                icon,
                color: kShrineBrown900,
              ),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: new EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedBackground() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return new Container(
      height: size,
      width: size,
      decoration: new BoxDecoration(shape: BoxShape.circle, color: kShrinePink100),
    );
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();
    return new FloatingActionButton(
      onPressed: _onFabTap,
      child: new Transform(
        alignment: Alignment.center,
        transform: new Matrix4.identity()..scale(1.0, scaleFactor),
        child: new Icon(
          _animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: kShrineBrown900,
          size: 26.0,
        ),
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

//  _onIconClick() {
//    widget.onClick();
//    close();
//  }
}

Widget buildFab(){
  return new Positioned(
      bottom: -40.0,
      right: -40.0,
      child: new AnimatedFab(
        //onClick: _changeFilterState,
      ));
}