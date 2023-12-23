import 'package:flutter/material.dart';
import '../base_page.dart';
import 'tab2_viewmodel.dart';

class Tab2Page extends StatelessWidget {

  const Tab2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      viewModel: () => Tab2ViewModel(),
      buildPage: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: const Text('Tab 2'),
        ),
        body: const Center(
          child: Text('Tab 2'),
        ),
      )
    );
  }
}