part of 'catagory_bloc.dart';

abstract class CatagoryEvent {}

class LoadCatagoryEvent extends CatagoryEvent {
  final CatagoryParams catagoryParams;
  LoadCatagoryEvent(this.catagoryParams);
}
