import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mindmap/mindmap_file.dart';
import 'package:mindmap/mindmap_widget.dart';
import 'package:mindmap/node.dart';

class MindMapPage extends StatefulWidget {
  MindMapPage({super.key, required this.mmf});
  MindMapFile mmf;
  @override
  State<MindMapPage> createState() => _MindMapPageState();
}

class _MindMapPageState extends State<MindMapPage> {
  late MindMapFile _mmf;
  @override
  void initState() {
    if (widget.mmf == null) {
      _mmf = MindMapFile()
        ..filename = "${DateTime.now().millisecondsSinceEpoch}.json"
        ..title = ""
        ..tree = Node("new project");
    } else {
      _mmf = widget.mmf;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        title: Text(_mmf.title == "" ? "New MindMap" : _mmf.title!),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("save"),
          ),
          TextButton(onPressed: () {}, child: Text("export"))
        ],
      ),
      body: MindMapWidget(tree: _mmf.tree!),
    );
  }
}
