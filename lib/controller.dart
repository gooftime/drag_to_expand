part of drag_to_expand;


enum BaseSide {
  top,
  bottom,
  left,
  right
}


class DragToExpandController extends ChangeNotifier{

  AnimationController animationController;


  DragToExpandController();


  bool get isOpened => animationController.status == AnimationStatus.forward
    || animationController.status == AnimationStatus.completed;
  set isOpened(bool v) {
    if(isOpened == v){ }
    else {
      toggle();
    }
  }

  void toggle() {
    animationController.fling(velocity: isOpened ? -2 : 2);
    notifyListeners();
  }


  void _notifyListeners(){
    notifyListeners();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

}