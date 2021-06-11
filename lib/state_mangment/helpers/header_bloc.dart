import 'package:bloc/bloc.dart';
import 'package:gulstan/models/header.dart';

class HeaderBloc extends Cubit<Header> {
  HeaderBloc() : super(Header('', ''));
  update(String title, String imagUrl) => emit(Header(title, imagUrl));
}
