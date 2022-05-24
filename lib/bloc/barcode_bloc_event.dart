part of 'barcode_bloc_bloc.dart';

@immutable
abstract class BarcodeBlocEvent {}

class BarcodeBlocEventSelected extends BarcodeBlocEvent {
  final String data;

  BarcodeBlocEventSelected(this.data);
}
