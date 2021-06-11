import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainPageBloc extends Cubit<int> {
  List<Widget Function()>? _pageToCompose;
  Widget get currentPage => _pageToCompose![state]();
  MainPageBloc({@required pageToCompose}) : super(0) {
    this._pageToCompose = pageToCompose;
  }
  void currentIndex(int index) => emit(index);
}
