import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulstan/state_mangment/helpers/main_page_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int? _currentIndex;
  PageStorageBucket _bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageBloc, int>(builder: (context, state) {
      _currentIndex = state;
      return _buildUi();
    });
  }

  _buildUi() => Scaffold(
        body: PageStorage(
          child: context.read<MainPageBloc>().currentPage,
          bucket: _bucket,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex!,
          onTap: (index) => context.read<MainPageBloc>().currentIndex(index),
          items: _items(),
        ),
      );

  List<BottomNavigationBarItem> _items() => [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined,size: 34,),
    label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.qr_code,size: 34,),
    label: 'QR'),
    BottomNavigationBarItem(icon: Icon(Icons.settings,size: 34,),
    label: 'Setting'),
  ];
}
