library drag_to_expand;

import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
part 'controller.dart';



class DragToExpand extends StatefulWidget {
  final DragToExpandController controller;
  final int animationDuration;
  final double minSize;
  final double maxSize;
  final BaseSide baseSide;
  final bool toggleOnTap;
  final Widget draggable, draggableWhenOpened;
  final Widget child;
  final bool clipOverflow;

  DragToExpand({
    Key key,
    this.controller,
    @required this.draggable,
    this.draggableWhenOpened,
    @required this.child,
    this.baseSide = BaseSide.bottom,
    this.animationDuration = 500,
    this.minSize = 0,
    this.maxSize = 300,
    this.toggleOnTap = true,
    this.clipOverflow = true,
  }) : super(key: key); // ValueKey<DragToExpandController>(controller)

  @override
	_DragToExpandState createState() => _DragToExpandState();
}



class _DragToExpandState extends State<DragToExpand> with SingleTickerProviderStateMixin {

  DragToExpandController _controller;


  @override
  void initState() {
    _controller = widget.controller ?? DragToExpandController();
    _controller.addListener(() => setState(() { }));

    _controller.animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );

    super.initState();
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }


  void _onDragUpdate(DragUpdateDetails details) {
    final double value = ( flexDirection() == Axis.vertical ?
      details.delta.dy :
      details.delta.dx ) / widget.maxSize;

    (widget.baseSide == BaseSide.bottom || widget.baseSide == BaseSide.right)
        ?  _controller.animationController.value -= value : _controller.animationController.value += value;
  }

  void _onDragEnd(DragEndDetails details) {
    if (_controller.animationController.isAnimating ||
        _controller.animationController.status == AnimationStatus.completed
    ) {
      // return;
    } else {
      double flingVelocity = ( flexDirection() == Axis.vertical ?
        details.velocity.pixelsPerSecond.dy :
        details.velocity.pixelsPerSecond.dx ) / widget.maxSize;

      flingVelocity *= (widget.baseSide == BaseSide.bottom || widget.baseSide == BaseSide.right) ? 1 : -1;

      if (flingVelocity < 0.0)
          _controller.animationController.fling(velocity: math.max(2.0, -flingVelocity));
      else if (flingVelocity > 0.0)
        _controller.animationController.fling(velocity: math.min(-2.0, -flingVelocity));
      else
        _controller.animationController.fling(velocity: _controller.animationController.value < 0.5 ? -2.0 : 2.0);
    }

    _controller._notifyListeners();
  }

  Axis flexDirection() {
    return (widget.baseSide == BaseSide.bottom || widget.baseSide == BaseSide.top)
        ?  Axis.vertical : Axis.horizontal;
  }
  MainAxisAlignment flexAlignment() {
    return (widget.baseSide == BaseSide.bottom || widget.baseSide == BaseSide.right)
        ?  MainAxisAlignment.end : MainAxisAlignment.start;
  }

  Widget expander() {
    if(widget.draggableWhenOpened == null)
      return widget.draggable;

    return _controller.isOpened ? widget.draggableWhenOpened : widget.draggable;
  }

  List<Widget> widgetsCulumn() {

    List<Widget> ret = [
      Flexible(
        child: AnimatedBuilder(
          animation: _controller.animationController,
          builder: (context, child) {
            return LayoutBuilder(builder: (_, constraint) {
              return Container(
                height: flexDirection() == Axis.vertical ?
                  lerpDouble(widget.minSize, widget.maxSize, _controller.animationController.value) : double.infinity,
                width: flexDirection() == Axis.horizontal ?
                  lerpDouble(widget.minSize, widget.maxSize, _controller.animationController.value) : double.infinity,
                child: widget.clipOverflow == false ?
                  widget.child :
                  Stack(
                    fit: StackFit.expand,
                    overflow: Overflow.clip,
                    children: [
                      Positioned(
                        top: 0,
                        height: flexDirection() == Axis.vertical ? widget.maxSize : constraint.maxHeight,
                        width: flexDirection() == Axis.horizontal ? widget.maxSize : constraint.maxWidth,
                        child: widget.child,
                      )
                    ]
                  )
              );
            });
          },
        ),
      ),

      Container(
        height: flexDirection() == Axis.vertical ? null : double.infinity,
        width: flexDirection() == Axis.horizontal ? null : double.infinity,
        child: GestureDetector(
          onTap: () {
            if(widget.toggleOnTap){
              _controller.toggle();
            }
          },
          onPanUpdate: _onDragUpdate,
          onPanEnd: _onDragEnd,
          child: expander()
        ),
      ),
    ];

    return (widget.baseSide == BaseSide.bottom || widget.baseSide == BaseSide.right)
        ?  ret.reversed.toList() : ret;
  }

  @override
  Widget build(BuildContext context) {

    return Flex(
      direction: flexDirection(),
      mainAxisAlignment: flexAlignment(),
      children: widgetsCulumn()
    );
  }
}
