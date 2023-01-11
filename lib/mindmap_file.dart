import 'package:mindmap/model/node.dart';

class MindMapFile {
  String? filename;
  String? title;
  String? screenShot;
  Node? tree;

  MindMapFile();

  MindMapFile.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    title = json['title'];
    screenShot = json['screenShot'];
    final t = json['tree'];
    if (t != null) {
      tree = Node.fromJson(t);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'title': title,
      'screenShot': screenShot,
      'tree': tree!.toJson()
    };
  }
}
