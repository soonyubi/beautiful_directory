import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mindmap/mindmap_widget.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController tc = TextEditingController();
  String project_name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 300,
            child: const Center(
              child: Text("Beautiful Directory",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 100,
                  )),
            ),
          ),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(30),
              foregroundColor: Colors.yellow,
            ),
            onPressed: () {
              Get.dialog(Dialog(
                child: Container(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("새 프로젝트 생성"),
                          TextField(
                            autofocus: true,
                            controller: tc,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    project_name = tc.text;
                                    print(project_name);
                                  });
                                  Get.to(MindMapWidget(),
                                      arguments: project_name);
                                },
                                child: Text("add"),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ));
            },
            icon: Icon(Icons.add, size: 30),
            label: Text(
              "add new project",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          Divider(color: Colors.yellow),
        ],
      ),
    );
  }
}
