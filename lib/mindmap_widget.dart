import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mindmap/mindmap_painter.dart';
import 'package:mindmap/node.dart';

class MindMapWidget extends StatefulWidget {
  MindMapWidget({super.key, required this.tree});
  Node tree;
  @override
  State<MindMapWidget> createState() => _MindMapWidgetState();
}

class _MindMapWidgetState extends State<MindMapWidget> {
  FocusNode _node = FocusNode();
  bool _focused = false;
  final _controller = TextEditingController();
  final _textStyle = TextStyle(color: Colors.black, fontSize: 30);
  void _handleFocusChange() {}
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Node tree = Node("Begin Here");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("project"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: handleOnTapUp,
              // onTap: handleOnTap,
              onDoubleTap: handleOnDoubleTap,
              onLongPressEnd: handleLongPressEnd,
              onDoubleTapDown: handleOnDoubleTapDown,
              onScaleStart: handleScaleStart,
              onScaleEnd: handleScaleEnd,
              onScaleUpdate: handleScaleUpdate,

              child: CustomPaint(
                child: Container(),
                painter: MindMapPainter(tree, canvasStart, scale),
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildTextField(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleEditMode(String s) {
    if (_focused) {
      _node.unfocus();
    } else {
      _controller.text = s;
      _node.requestFocus();
    }
    setState(() {
      _focused = !_focused;
    });
  }

  void handleOnTapUp(TapUpDetails details) {
    // add a child

    final n = dfs(tree, (Node m) {
      final inside = m.rect.contains(details.localPosition);
      print("[$inside] rect -> ${m.rect} pos -> ${details.localPosition}");
      return inside;
    });

    if (n != null) {
      print("Adding a new Child to cell with : ${n.value}");
      setState(() {
        n.children.add(Node(""));
      });
    } else {
      print("Not tapped inside a node");
    }
  }

  Node? _selectedNode;
  void handleOnDoubleTapDown(TapDownDetails details) {
    // edit value

    print(
        "handleOnDoubleTapDown global-position : ${details.globalPosition} local-position : ${details.localPosition}");

    _selectedNode = dfs(tree, (Node m) {
      final inside = m.rect.contains(details.localPosition);
      print("[$inside] rect -> ${m.rect} pos -> ${details.localPosition}");
      return inside;
    });

    if (_selectedNode != null) {
      toggleEditMode(_selectedNode!.value);
    }
  }

  _buildTextField() {
    if (_focused) {
      return TextField(
        controller: _controller,
        onSubmitted: handleTextFieldInput,
        focusNode: _node,
        style: _textStyle,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.only(left: 10.0, bottom: 8.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10))),
      );
    } else {
      return Container();
    }
  }

  void handleTextFieldInput(String value) {
    print("Text is $value");

    if (_selectedNode != null) {
      _selectedNode!.value = value.trim();
      _selectedNode = null;
    }
    toggleEditMode("");
  }

  void handleOnDoubleTap() {}
  Offset canvasStart = Offset(0, -360);
  double scale = 1.0;
  double? prevScale;
  Offset? prevFocalPoint;
  void handleScaleStart(ScaleStartDetails details) {
    print("handleScaleStart ${details.focalPoint}");
    prevFocalPoint = details.focalPoint;
    prevScale = scale;
  }

  void handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (prevFocalPoint != null) {
        canvasStart += details.focalPoint - prevFocalPoint!;
        prevFocalPoint = details.focalPoint;

        scale = prevScale! * details.scale;
      }
    });
    print("Canvas Start Position : $canvasStart");
    print("handle Scale update : $scale");
  }

  void handleScaleEnd(ScaleEndDetails details) {
    prevFocalPoint = null;
    prevScale = null;
  }

  void handleLongPressEnd(LongPressEndDetails details) {
    // delete node
    deleteNode(tree, details.localPosition / scale);
    setState(() {});
  }
}
