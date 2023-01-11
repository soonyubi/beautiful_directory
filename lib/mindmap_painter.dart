import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindmap/model/node.dart';

class MindMapPainter extends CustomPainter {
  final Node tree;
  final Offset canvasStart;
  final double canvasScale;
  MindMapPainter(this.tree, this.canvasStart, this.canvasScale);

  final rectPaint = Paint()..style = PaintingStyle.fill;
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    throw UnimplementedError();
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBackGround(canvas, size);

    // canvas.save();
    // canvas.scale(canvasScale, canvasScale);

    drawCells(canvas, size);
  }

  void drawBackGround(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    rectPaint.shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [0.0, 1.0],
        colors: [Color(0xff662397), Color(0xffdc6c62)]).createShader(rect);
    canvas.drawRect(rect, Paint()..color = Colors.black);
  }

  final CellW = 150.0;
  final CellH = 50.0;
  final cellPaintBorder = Paint()
    ..color = Colors.black54
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;
  final cellPaintFill = Paint()
    ..color = Colors.white54
    ..style = PaintingStyle.fill;
  final textStyle = TextStyle(
      fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold);
  final padding = 10.0;

  void drawCells(Canvas canvas, Size size) {
    final center =
        Offset(padding + CellW / 2.0, size.height / 2.0) + canvasStart;

    // measureCell(tree);
    // drawCell(canvas, center, tree);
    drawCell2(canvas, center, tree, true);
  }

// 60 ~ 112 is for balanced mindmap tree

  // Size measureCell(Node n) {
  //   if (n == null) return Size(0, 0);

  //   var subTreeSize = Size(0, 0);
  //   n.children.forEach((element) {
  //     final sz = measureCell(element);
  //     subTreeSize = Size(subTreeSize.width, subTreeSize.height + sz.height);
  //   });
  //   final count = n.children.length;
  //   subTreeSize =
  //       Size(subTreeSize.width, subTreeSize.height + (count - 1) * padding);
  //   final height = subTreeSize.height > CellH ? subTreeSize.height : CellH;

  //   n.visualSize = Size(subTreeSize.width, height);
  //   // print("${n.value} sub tree size -> ${n.visualSize}");
  //   return n.visualSize;
  // }

  // final displacementFactor = 1;
  // void drawCell(Canvas canvas, Offset center, Node node) {
  //   if (node == null) return;

  //   // draw rect
  //   final rect = Rect.fromCenter(center: center, width: CellW, height: CellH);
  //   final rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));
  //   // canvas.drawRRect(rrect, cellPaintFill);
  //   canvas.drawRRect(rrect, cellPaintBorder);
  //   node.centroid = center;
  //   node.rect = rect;

  //   drawTextCentered(canvas, center, node.value, textStyle, rect.width);

  //   final totalHeight = node.visualSize.height;
  //   print(
  //       "${node.value} --> totalHeight =$totalHeight // totalWidth = ${node.visualSize.width}");
  //   final distance = rect.width * 2.0 * displacementFactor;
  //   // print("rect width : ${rect.width}");
  //   var pos = Offset(distance, -totalHeight / 2.0);
  //   node.children.forEach((n) {
  //     final sz = n.visualSize;
  //     final vD = Offset(0, sz.height + padding);
  //     var c = center + pos + Offset(sz.width, sz.height / 2.0);
  //     canvas.drawLine(
  //         center + Offset(rect.width / 2.0, 0),
  //         c + Offset(-rect.width / 2.0, 0),
  //         cellPaintBorder..color = Colors.white54);
  //     drawCell(canvas, c, n);
  //     pos += vD;
  //   });
  // }

  int drawCell2(Canvas canvas, Offset center, Node node, bool root) {
    if (node == null) return 0;

    final rect = Rect.fromCenter(center: center, width: CellW, height: CellH);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));
    // canvas.drawRRect(rrect, cellPaintBorder);
    node.centroid = center;
    node.rect = rect;
    if (!root)
      canvas.drawLine(
          center - Offset(rect.width, 0),
          center - Offset(rect.width / 10.0, 0),
          cellPaintBorder..color = Colors.white);
    drawTextCentered(canvas, center, node.value, textStyle, rect.width);

    Offset prev_center = center + Offset(CellW, 0);

    var t = 1.0 * CellH;
    var nodesum = 0;
    node.children.forEach((element) {
      Offset new_center = center + Offset(CellW, t);
      canvas.drawLine(
          prev_center - Offset(rect.width, -rect.height / 2.0),
          new_center - Offset(rect.width, 0),
          cellPaintBorder..color = Colors.white);
      var subNode = drawCell2(canvas, new_center, element, false);

      nodesum += subNode;
      t += subNode * CellH;
    });
    return nodesum + 1;
  }

  TextPainter measureText(String s, TextStyle style, double maxWidth) {
    final span = TextSpan(text: s, style: style);

    final tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  TextPainter measureIcon(IconData icon) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: 20.0, fontFamily: icon.fontFamily));
    textPainter.layout();
    return textPainter;
  }

  paintText(Canvas canvas, TextPainter tp, Offset position) {
    tp.paint(canvas, position);
  }

  paintIcon(Canvas canvas, TextPainter tp, Offset position) {
    tp.paint(canvas, position);
  }

  void drawTextCentered(Canvas canvas, Offset position, String text,
      TextStyle style, double maxWidth) {
    final tp = measureText(text, style, maxWidth);
    final tp2 = measureIcon(Icons.file_copy);
    final pos = position + Offset(-tp.width / 2.0, -tp.height / 2.0);
    final pos2 = position + Offset(-tp.width / 1.3, -tp.height / 2.0);
    paintText(canvas, tp, pos);
    paintIcon(canvas, tp2, pos2);
    // paintIcon(canvas, tp2, pos2);
  }
}
