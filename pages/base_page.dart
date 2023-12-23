import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../model/services/navigation_chain_service.dart';
import '../pages/base_viewmodel.dart';
import '../service_locator.dart';

//Used to allow pages to determine if they are root pages or not
class BasePageParentIndicator extends InheritedWidget {

  const BasePageParentIndicator({super.key, required super.child});

  static maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BasePageParentIndicator>();
  }

  static of(BuildContext context) {
    final BasePageParentIndicator? result = context.dependOnInheritedWidgetOfExactType<BasePageParentIndicator>();
    assert(result != null, 'No SophiaPage found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant BasePageParentIndicator oldWidget) {
    return false;
  }

}

//Allows us to call init() on the ViewModel and tie in other lifecycle methods if desired
class BasePage<T extends BaseViewModel> extends StatefulWidget {

  final T Function() _viewModel;
  final Widget Function(BuildContext context, T viewModel) buildPage;

  const BasePage({super.key, required T Function() viewModel, required this.buildPage}) : _viewModel = viewModel;

  @override
  State<BasePage<T>> createState() => _BasePageState<T>();
}

class _BasePageState<T extends BaseViewModel> extends State<BasePage<T>> {

  final NavigationChainService _navigationChainService = sl();

  T? _viewModelInstance;

  @override
  void initState() {
    super.initState();

    _viewModelInstance = widget._viewModel();
    _viewModelInstance?.init();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Register with the navigation chain service
    _navigationChainService.registerPage(context);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModelInstance?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageParentIndicator(
      child: ChangeNotifierProvider.value(value: _viewModelInstance, child: Consumer<T>(
        builder: (context, viewModel, child) {
          return widget.buildPage(context, viewModel);
        },
      )),
    );
  }
}