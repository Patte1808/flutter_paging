import 'package:flutter/widgets.dart';
import 'dart:async';
import '../data_load_state.dart';

class ApplicationProvider extends InheritedWidget {
  ApplicationProvider({
    Key key,
    this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  final ApplicationBloc bloc;

  @override
  bool updateShouldNotify(ApplicationProvider oldWidget) {
    return bloc != oldWidget.bloc;
  }
}

class ApplicationBloc {
  ApplicationBloc of(BuildContext context) {
    final ApplicationProvider provider = context.inheritFromWidgetOfExactType(ApplicationProvider);
    return provider.bloc;
  }

  StreamController<DataLoadState> _dataLoadStateController = new StreamController<DataLoadState>.broadcast();
  Sink get inDataLoadState => _dataLoadStateController.sink;
  Stream<DataLoadState> get outDataLoadState => _dataLoadStateController.stream;

  DataLoadState _currentState;
  DataLoadState get currentState => _currentState;

  ApplicationBloc() {
    _dataLoadStateController.add(DataLoadState.INIT);
    _currentState = DataLoadState.INIT;
  }

  void setDataLoadState(DataLoadState dataLoadState) {
    inDataLoadState.add(dataLoadState);
    _currentState = dataLoadState;
  }

  void dispose() {
    _dataLoadStateController.close();
  }
}