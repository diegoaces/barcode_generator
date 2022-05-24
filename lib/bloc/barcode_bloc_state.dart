part of 'barcode_bloc_bloc.dart';

@immutable
abstract class BarcodeBlocState {}

class BarcodeBlocInitial extends BarcodeBlocState {}

class BarcodeBlocLoading extends BarcodeBlocState {}

class BarcodeBlocLoaded extends BarcodeBlocState {
  final String data;

  BarcodeBlocLoaded(this.data);
}
