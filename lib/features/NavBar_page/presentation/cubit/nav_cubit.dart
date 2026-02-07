import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secupass/features/NavBar_page/presentation/cubit/nav_state.dart';

class NavBarCubit extends Cubit<NavBarState> {
  NavBarCubit() : super(NavBarState(index: 0));
  updateIndex(int newIndex) {
    emit(NavBarState(index: newIndex));
  }
}
