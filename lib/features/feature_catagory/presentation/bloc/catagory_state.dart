part of 'catagory_bloc.dart';

class CatagoryState {
  final CatagoryStatus catagoryStatus;
  CatagoryState({required this.catagoryStatus});

  CatagoryState copyWith({CatagoryStatus? catagoryStatus}) {
    return CatagoryState(catagoryStatus: catagoryStatus ?? this.catagoryStatus);
  }
}
