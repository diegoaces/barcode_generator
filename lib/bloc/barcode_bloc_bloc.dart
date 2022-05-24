import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'barcode_bloc_event.dart';
part 'barcode_bloc_state.dart';

class BarcodeBloc extends Bloc<BarcodeBlocEvent, BarcodeBlocState> {
  BarcodeBloc() : super(BarcodeBlocInitial()) {
    on<BarcodeBlocEvent>((event, emit) {});
    on<BarcodeBlocEventSelected>((event, emit) {
      emit(BarcodeBlocLoading());
      emit(BarcodeBlocLoaded(event.data));
    });
  }
}
