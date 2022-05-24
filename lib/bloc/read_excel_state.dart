part of 'read_excel_bloc.dart';

@immutable
abstract class ReadExcelState {}

class ReadExcelInitial extends ReadExcelState {}

class ReadExcelLoading extends ReadExcelState {}

class ReadExcelLoaded extends ReadExcelState {
  final List<String> data;

  ReadExcelLoaded(this.data);
}

class ReadExcelError extends ReadExcelState {
  final String error;

  ReadExcelError(this.error);
}

class ReadExcelSelected extends ReadExcelState {
  final String data;

  ReadExcelSelected(this.data);
}
