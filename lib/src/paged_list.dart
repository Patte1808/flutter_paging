import 'package:flutter/widgets.dart';
import 'paged_data_source.dart';
import 'data_load_state.dart';
import 'bloc/application_bloc.dart';

class PagedList extends StatefulWidget {
  final Function list;
  final Widget loadingIndicator;
  final PagedDataSource pagedDataSource;

  PagedList({Key key, this.list, this.loadingIndicator, this.pagedDataSource})
      : super(key: key);

  @override
  _PagedListState createState() => _PagedListState();
}

class _PagedListState extends State<PagedList> {
  final bloc = ApplicationBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationProvider(
      child: NotificationListener(
          child: StreamBuilder(
            stream: bloc.outDataLoadState,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                bloc.setDataLoadState(DataLoadState.LOADING);
                widget.pagedDataSource.loadInitial().then((_) {
                  bloc.setDataLoadState(DataLoadState.SUCCESS);
                });
              }

              if (snapshot.data == DataLoadState.LOADING) {
                return Stack(
                  children: <Widget>[
                    widget.list(),
                    widget.loadingIndicator,
                  ],
                );
              }

              return widget.list();
            },
          ),
          onNotification: (ScrollNotification scrollNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              if (bloc.currentState != DataLoadState.LOADING) {
                bloc.setDataLoadState(DataLoadState.LOADING);
                widget.pagedDataSource.loadAfter().then((_) =>
                    bloc.setDataLoadState(DataLoadState.SUCCESS));
              }
            }
          }),
    );
  }
}
