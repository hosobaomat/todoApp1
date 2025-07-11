import 'package:bloc/bloc.dart';

class BottomNavCubit extends Cubit<int> {// Cubit<int> để quản lý trạng thái của tab hiện tại
  BottomNavCubit() : super(0); // Mặc định là tab đầu tiên truyen vao 0

  void changeTab(int index) => emit(index);
}
