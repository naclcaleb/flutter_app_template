import 'package:flutter/material.dart';
import '../base_page.dart';
import 'tab1_viewmodel.dart';

class Tab1Page extends StatelessWidget {

  const Tab1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      viewModel: () => Tab1ViewModel(),
      buildPage: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: const Text('Tab 1'),
        ),
        body: const Center(
          child: Text('Tab 1'),
        ),
      )
    );
  }
}