import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {

  final String initialText, finalText;
  final ButtonStyle buttonStyle;
  final IconData iconData;
  final double iconSize;
  final Duration animationDuration;
  final Function onTap;


  AnimatedButton({
    this.initialText, 
    this.finalText, 
    this.buttonStyle, 
    this.iconData, 
    this.iconSize, 
    this.animationDuration,
    this.onTap
    });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {

  AnimationController _controller;
  ButtonState _currentState;
  Duration _smallDuration;
  Animation<double>  _scaleFinalTextAnimation;
  int refresh = 0;

  @override
  void initState() {
    super.initState();
    _currentState = ButtonState.SHOW_ONLY_TEXT;
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _smallDuration = Duration(milliseconds: (widget.animationDuration.inMilliseconds * 0.2).round());
    _controller.addListener(() {
      double controllerValue = _controller.value;
      if(controllerValue < 0.5) {
        setState(() {
          _currentState = ButtonState.SHOW_ONLY_ICON;
        });
      } else if( controllerValue > 0.5 ){
        setState(() {
          _currentState = ButtonState.SHOW_TEXT_ICON;
          });
      }
    });

    _controller.addStatusListener((currentState){
      if(currentState == AnimationStatus.completed){
        setState((){
          refresh = 1;
        });
        return widget.onTap();
      }
    });

    _scaleFinalTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.buttonStyle.elevation,
      borderRadius: BorderRadius.all(Radius.circular(widget.buttonStyle.borderRadius)),
      child: InkWell(
        onTap: (){
          if(refresh == 1){
            print('refresh');
            setState((){
              refresh = 0;
              _controller.reset();
              _currentState = ButtonState.SHOW_ONLY_TEXT;
              
            });
          }else{
            print('in here');
            _controller.forward();
          }
          // setState(() {
          // _currentState = ButtonState.SHOW_ONLY_ICON;
          // });
        },
        child: AnimatedContainer(
          duration: _smallDuration,
          height: widget.iconSize + 16,
          decoration: BoxDecoration(
            color: (_currentState == ButtonState.SHOW_ONLY_ICON || _currentState == ButtonState.SHOW_TEXT_ICON) ? widget.buttonStyle.secondaryColor : widget.buttonStyle.primaryColor,
            border: Border.all(
              color: (_currentState == ButtonState.SHOW_ONLY_ICON || _currentState == ButtonState.SHOW_TEXT_ICON) ? widget.buttonStyle.primaryColor : Colors.transparent
            ),
            borderRadius: BorderRadius.all(Radius.circular(widget.buttonStyle.borderRadius)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal:(_currentState == ButtonState.SHOW_ONLY_ICON) ? 16.0 : 48.0, 
            vertical: 8.0
          ),
          child: AnimatedSize(
            vsync: this,
            curve: Curves.easeIn,
            duration: _smallDuration,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (_currentState == ButtonState.SHOW_ONLY_ICON || _currentState == ButtonState.SHOW_TEXT_ICON) 
                ? Icon(
                    widget.iconData, 
                    size: widget.iconSize, 
                    color: widget.buttonStyle.primaryColor
                  ) 
                : Container(),
                SizedBox(
                  width: _currentState == ButtonState.SHOW_TEXT_ICON ? 30.0 : 0.0,
                ),
                getTextWidget(),
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget getTextWidget(){
    if(_currentState == ButtonState.SHOW_ONLY_TEXT){
      return Text(
          widget.initialText, 
          style: widget.buttonStyle.initialTextStyle
      );
    }else if( _currentState == ButtonState.SHOW_TEXT_ICON){
      return ScaleTransition(
        scale: _scaleFinalTextAnimation,
        child: Text(
            widget.finalText, 
            style: widget.buttonStyle.finalTextStyle
        ),
      );
    }else{
      return Container();
    }
  }

}

class ButtonStyle{
  final TextStyle initialTextStyle, finalTextStyle;
  final Color primaryColor, secondaryColor;
  final double elevation, borderRadius;

  ButtonStyle({this.initialTextStyle, this.finalTextStyle, this.primaryColor, this.secondaryColor, this.elevation, this.borderRadius});


}

enum ButtonState{
  SHOW_ONLY_TEXT,
  SHOW_ONLY_ICON,
  SHOW_TEXT_ICON
}