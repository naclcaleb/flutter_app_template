import 'package:flutter/material.dart';

class BottomDrawer extends StatefulWidget {

  final DraggableScrollableController? controller;
  final double initialSize;
  final Widget drawerContent;
  final Widget child;

  const BottomDrawer({super.key, this.controller, this.initialSize = 0, required this.drawerContent, required this.child});

  @override
  State<BottomDrawer> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child,),
        Positioned.fill(
          bottom: 0,
          left: 0,
          right: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return DraggableScrollableSheet(
                controller: widget.controller,
                minChildSize: 0,
                maxChildSize: 0.93,
                snapSizes: [
                  18 / constraints.maxHeight,
                  118 / constraints.maxHeight
                ],
                snap: true,
                initialChildSize: widget.initialSize,
                snapAnimationDuration: const Duration(milliseconds: 100),
                builder: (context, scrollController) {
                  return GestureDetector(
                    onTap: () { /*This just prevents any parent gesturedetectors from being triggered*/ },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, -3)
                          )
                        ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Container(
                                    height: 7,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                  const Spacer()
                                ],
                              ),
                            ),
                            widget.drawerContent,
                          ],
                        ),
                      ),
                    ),
                  );
                }
              );
            }
          ),
        )
      ],
    );
  }
}