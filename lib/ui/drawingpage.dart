import 'package:draw/custompainter/custompainter.dart';
import 'package:draw/custompainter/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  var offsetPos = <GroupColor?>[];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController controller;
  var isopen = false;
  Color _color = Colors.black;
  var strokecontroller = TextEditingController()..text = '3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) {
          return InkWell(
            onTap: () {
              if (isopen == false) {
                controller = Scaffold.of(context).showBottomSheet(
                    (context) => Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(248, 173, 225, 214),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Card(
                                    color: _color,
                                    shape: const CircleBorder(),
                                    child: const SizedBox(
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Scaffold.of(context).showBottomSheet(
                                        (context) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ColorPicker(
                                                pickerAreaHeightPercent: 0.7,
                                                portraitOnly: true,
                                                pickerColor: _color,
                                                onColorChanged: (value) {
                                                  setState(() {
                                                    _color = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text(
                                                'Done',
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            )
                                          ],
                                        ),
                                        constraints: const BoxConstraints(
                                            maxHeight: 500),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.color_lens,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 30,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: 2,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white),
                                        ),
                                        Container(
                                          height: 3,
                                          width: 13,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white),
                                        ),
                                        Container(
                                          height: 4,
                                          width: 15,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Container(
                                      width: 30,
                                      height: 60,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: strokecontroller,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        cursorHeight: 0,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                        onSubmitted: (value) {
                                          strokecontroller.text = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    _color = Colors.white;
                                  },
                                  child: Image.asset(
                                    'assets/eraser.png',
                                    height: 20,
                                    color: Colors.white,
                                  )),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _color = Colors.black;
                                    strokecontroller.text = 5.toString();
                                    offsetPos = [];
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    constraints: const BoxConstraints(maxHeight: 80));
                setState(() {
                  isopen = true;
                });
              } else {
                controller.close();
                setState(() {
                  isopen = false;
                });
              }
            },
            child: const Card(
              shape: CircleBorder(),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.edit,
                  size: 35,
                ),
              ),
            ),
          );
        },
      ),
      body: GestureDetector(
        onPanStart: (details) {
          final box = context.findRenderObject() as RenderBox;
          final point = box.globalToLocal(details.globalPosition);
          setState(() {
            offsetPos.add(
              GroupColor(
                point,
                _color,
                int.parse(strokecontroller.text),
              ),
            );
          });
        },
        onPanUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          final point = box.globalToLocal(details.globalPosition);
          setState(() {
            offsetPos.add(
              GroupColor(
                point,
                _color,
                int.parse(strokecontroller.text),
              ),
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            offsetPos.add(null);
          });
        },
        child: Stack(
          children: [
            Positioned(
              child: Container(),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: Colors.white,
                child: CustomPaint(
                  painter: MyCustomPainter(
                    offsetPos,
                    _color,
                    int.parse(strokecontroller.text),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
