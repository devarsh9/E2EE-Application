/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class FadeAnimation extends StatelessWidget{
  final double delay;
  final Widget child;
  FadeAnimation(this.delay,this.child);

  get context => null;

  get animation => null;
  @override
  Widget build(BuildContext content){
    final tween=MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 500),Tween(begin: 0.0,end: 1.0)),
      Track("translate").add(
          Duration(milliseconds: 500),Tween(begin: -30.0,end: 0.0),
          curve:Curves.easeOut)
    ]);
    return ControlledAnimation(
      delay:Duration(milliseconds: (500*delay).round()),
      duration:tween.duration,
      tween:tween,
      child:child,
      builderWithChild:{context, child, animation}=>Opacity(
    opacity:animation["opacity"],
      child:Transform.translate(
          offset:Offset(0,animation["translateY"]),
          child:child
      ),
    ),
    );
  }

// Track(String s) {}

// Widget ControlledAnimation({Duration delay, duration, tween, Widget child, Set builderWithChild}) {}

//MultitrackTween(List list) {}
}
}*/