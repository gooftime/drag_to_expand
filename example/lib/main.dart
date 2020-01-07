import 'package:drag_to_expand/drag_to_expand.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DragToExpandController _dragToExpandController;
  DragToExpandController _dragToExpandController2;
  StreamController<String> bgImageStream;

  @override
  void initState() {
    _dragToExpandController = DragToExpandController();
    _dragToExpandController2 = DragToExpandController();

    bgImageStream = StreamController<String>();

    super.initState();
  }
  @override
  dispose() {
    _dragToExpandController.dispose();
    _dragToExpandController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('drag_to_expand example'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          StreamBuilder<String>(
            stream: bgImageStream.stream,
            initialData: 'https://picsum.photos/500?image=35',
            builder: (context, asyncSnapshot) {
              return Image.network(asyncSnapshot.data, fit: BoxFit.fill,);
            }
          ),


          Align(
            alignment: Alignment.topCenter,
            child: DragToExpand(
              controller: _dragToExpandController,
              minSize: 0,
              maxSize: 100,
              baseSide: BaseSide.top,
              toggleOnTap: true,
              draggable: Center(
                child: Container(
                  height: 50,
                  width: 60,
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: Center(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 40,
                      )
                    )
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (BuildContext ctxt, int index) {
                    int randomImage = math.Random().nextInt(100);
                    return GestureDetector(
                      onTap: () {
                        _dragToExpandController.isOpened = false;
                        _dragToExpandController2.isOpened = true;
                        bgImageStream.add('https://picsum.photos/500?image=$randomImage');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(8.0),
                          child: Image.network('https://picsum.photos/150?image=$randomImage'),
                        )
                      )
                    );
                  }
                ),
              ),
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DragToExpand(
                controller: _dragToExpandController2,
                minSize: 0,
                maxSize: 330,
                baseSide: BaseSide.bottom,
                toggleOnTap: true,
                draggable: Container(
                  height: 40,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)
                      )
                    ),
                    child: Center(
                      child: Text('Read about photo',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                        ),
                      ),
                    )
                  ),
                ),
                draggableWhenOpened: Container(
                  height: 40,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)
                      )
                    ),
                    child: Center(
                      child: Text('Hide',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[300],
                        ),
                      ),
                    )
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  color: Colors.black45,
                  child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut '
                  + 'labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                  + 'nisi ut aliquip ex ea commodo consequat. \n\n Duis aute irure dolor in reprehenderit in voluptate velit '
                  + 'esse cillum dolore eu fugiat nulla pariatur. \n\n'
                  + 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  )
                ),
              )
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 70,
              child: DragToExpand(
                minSize: 0,
                maxSize: 170,
                baseSide: BaseSide.right,
                toggleOnTap: true,
                // clipOverflow: false,
                draggable: Container(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)
                      )
                    ),
                    child: Icon(Icons.share, color: Colors.blueAccent[100],)
                  ),
                ),
                child: Container(
                  color: Colors.black38,
                  padding: EdgeInsets.only(right: 15),
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Icon(Icons.thumb_up, color: Colors.white,),
                      ),
                      Flexible(
                        flex: 1,
                        child: Icon(Icons.sms, color: Colors.white,),
                      ),
                      Flexible(
                        flex: 1,
                        child: Icon(Icons.not_listed_location, color: Colors.white,),
                      ),
                      Flexible(
                        flex: 1,
                        child: Icon(Icons.star, color: Colors.yellowAccent),
                      ),
                    ],
                  )
                )
              )
            ),
          ),


        ],
      ),
    );
  }
}