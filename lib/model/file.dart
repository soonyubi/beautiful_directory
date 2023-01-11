import 'package:mindmap/model/node.dart';

class File {
  String? projectname;
  String? color;
  Node? tree;

  File();

  File.fromJson(Map<String, dynamic> json) {
    projectname = json['title'];
    color = json['color'];
    final t = json['tree'];
    if (t != null) {
      tree = Node.fromJson(t);
    }
  }

  Map<String, dynamic> toJson() {
    return {'title': projectname, 'color': color, 'tree': tree!.toJson()};
  }
}
