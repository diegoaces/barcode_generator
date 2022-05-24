part of 'read_excel_bloc.dart';

@immutable
abstract class ReadExcelEvent {}

class ReadExcelEventLoad extends ReadExcelEvent {
  final Uint8List bytes;

  ReadExcelEventLoad(this.bytes);
}

class ReadExcelEventSelected extends ReadExcelEvent {
  final String data;

  ReadExcelEventSelected(this.data);
}
