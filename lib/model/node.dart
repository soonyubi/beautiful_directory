import 'dart:ui';

class Node {
  late List<Node> children;
  late String value;
  late Offset centroid;
  late Rect rect;
  late Size visualSize = Size(0, 0);
  Node(this.value) {
    children = List.empty(growable: true);
  }

  Node.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    if (json['children'] != null) {
      children = <Node>[];
      json['children'].forEach((v) {
        children.add(Node.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}

Node? dfs(Node node, bool Function(Node n) predicate) {
  if (node == null) return node;

  if (predicate(node)) return node;
  for (var i = 0; i < node.children.length; i++) {
    final m = dfs(node.children[i], predicate);
    if (m != null) return m;
  }
  return null;
}

void deleteNode(Node node, Offset pos) {
  if (node == null) return;

  var foundAt = -1;
  for (var i = 0; i < node.children.length; i++) {
    if (node.children[i].rect.contains(pos)) {
      foundAt = i;
      break;
    }
  }

  if (foundAt != -1) {
    node.children.removeAt(foundAt);
    return;
  }

  for (var i = 0; i < node.children.length; i++) {
    deleteNode(node.children[i], pos);
  }
}
