import 'package:equatable/equatable.dart';

class NavBarState extends Equatable {
  final int index;
  NavBarState({required this.index});
  @override
  List<Object> get props => [index];
}
