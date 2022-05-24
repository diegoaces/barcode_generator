import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

part 'read_excel_event.dart';
part 'read_excel_state.dart';

class ReadExcelBloc extends Bloc<ReadExcelEvent, ReadExcelState> {
  ReadExcelBloc() : super(ReadExcelInitial()) {
    on<ReadExcelEventLoad>((event, emit) {
      emit(ReadExcelLoading());

      compute(readExcel, event.bytes).then((data) {
        emit(ReadExcelLoaded(data));
      }).catchError((error) {
        emit(ReadExcelError(error.toString()));
      });
    });
  }

  FutureOr readExcel(Uint8List message) {
    var datas = [""];
    var excel = Excel.decodeBytes(message);
    for (var table in excel.tables.keys) {
      for (List<Data?> row in excel.tables[table]?.rows ?? []) {
        datas.add(row.map((e) => e?.value.toString()).toList().join(',') +
            '\n'.toString());
      }
    }
    return datas;
  }
}
