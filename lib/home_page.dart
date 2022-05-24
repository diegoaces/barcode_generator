import 'package:barcode_generator/searchablelist_widget.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfw;

import 'bloc/barcode_bloc_bloc.dart';
import 'bloc/read_excel_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Generator'),
      ),
      body: Row(
        children: [
          //search bar
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<ReadExcelBloc, ReadExcelState>(
                builder: (context, state) {
                  if (state is ReadExcelInitial) {
                    return Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(text: 'Presiona el botón '),
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.0),
                                child: Icon(
                                  Icons.upload,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            TextSpan(text: 'para seleccionar un archivo.'),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ReadExcelLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is ReadExcelLoaded) {
                    return SearchableList(
                      codeList: state.data,
                    );
                  } else if (state is ReadExcelError) {
                    return Text(state.error);
                  } else {
                    return const Text('Error no se pudo leer el archivo.');
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: BlocBuilder<BarcodeBloc, BarcodeBlocState>(
                  builder: (context, state) {
                    if (state is BarcodeBlocLoaded) {
                      var texts = state.data.split(",");

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BarcodeWidget(
                                barcode: Barcode.code93(),
                                data: texts.first,
                                width: 300,
                                height: 100,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _exportPdf(state.data);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Descargar formato 3x1."),
                                Icon(Icons.file_download),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _exportPdf2(state.data);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Descargar formato grande."),
                                Icon(Icons.file_download),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return const Text('Selecciona un item del listado.');
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? pickedFile = await FilePicker?.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['xlsx'],
            allowMultiple: false,
          );
          if (pickedFile != null) {
            var bytes = pickedFile.files.single.bytes;
            if (bytes != null) {
              BlocProvider.of<ReadExcelBloc>(context)
                  .add(ReadExcelEventLoad(bytes));
            }
          }
        },
        child: const Icon(Icons.upload),
      ),
    );
  }

  Future<void> _exportPdf(String data) async {
    var texts = data.split(",");

    final pdf = pdfw.Document(
      author: 'DIEGO ACUÑA',
      keywords: 'barcode, dart, code93',
      title: 'Barcode code93',
    );

    pdf.addPage(_barcode(texts));

    final path = await getSavePath();
    if (path != null) {
      final file = XFile.fromData(
        await pdf.save(),
        name: '${texts.first}.pdf',
        mimeType: 'application/pdf',
      );
      await file.saveTo(path);
    }
  }

  Future<void> _exportPdf2(String data) async {
    var texts = data.split(",");

    final pdf = pdfw.Document(
      author: 'DIEGO ACUÑA',
      keywords: 'barcode, dart, code93',
      title: 'Barcode code93',
    );

    pdf.addPage(_barcode2(texts));

    final path = await getSavePath();
    if (path != null) {
      final file = XFile.fromData(
        await pdf.save(),
        name: '${texts.first}_vfull.pdf',
        mimeType: 'application/pdf',
      );
      await file.saveTo(path);
    }
  }

  _barcode(List<String> texts) {
    return pdfw.Page(
      pageFormat: const PdfPageFormat(
        110 * PdfPageFormat.mm,
        25 * PdfPageFormat.mm,
      ),
      build: (context) => pdfw.Center(
        child: pdfw.Row(
          mainAxisAlignment: pdfw.MainAxisAlignment.spaceAround,
          children: [
            _barcodeItem(texts),
            _barcodeItem(texts),
            _barcodeItem(texts),
          ],
        ),
      ),
    );
  }

  _barcode2(List<String> texts) {
    return pdfw.Page(
      pageFormat: const PdfPageFormat(
        85.6 * PdfPageFormat.mm,
        30 * PdfPageFormat.mm,
      ),
      build: (context) => pdfw.Center(
        child: pdfw.Row(
          mainAxisAlignment: pdfw.MainAxisAlignment.spaceAround,
          children: [
            _barcodeItem2(texts),
          ],
        ),
      ),
    );
  }

  _barcodeItem(texts) {
    return pdfw.Column(
      mainAxisAlignment: pdfw.MainAxisAlignment.center,
      children: [
        pdfw.Text(texts.first,
            style: const pdfw.TextStyle(
              fontSize: 1.5 * PdfPageFormat.mm,
            )),
        pdfw.Container(height: 1 * PdfPageFormat.mm),
        pdfw.BarcodeWidget(
          barcode: Barcode.code93(),
          data: texts.first,
          width: 32 * PdfPageFormat.mm,
          height: 10 * PdfPageFormat.mm,
          drawText: false,
        ),
        pdfw.Container(height: 1 * PdfPageFormat.mm),
        pdfw.Text(
          "\$ ${texts[2]}",
          style: pdfw.TextStyle(
            fontSize: 3 * PdfPageFormat.mm,
            fontWeight: pdfw.FontWeight.bold,
          ),
        ),
        pdfw.Text(
          texts[1],
          style: const pdfw.TextStyle(
            fontSize: 1.2 * PdfPageFormat.mm,
          ),
        ),
      ],
    );
  }

  _barcodeItem2(texts) {
    return pdfw.Column(
      mainAxisAlignment: pdfw.MainAxisAlignment.center,
      children: [
        pdfw.Text(texts.first,
            style: const pdfw.TextStyle(
              fontSize: 2 * PdfPageFormat.mm,
            )),
        pdfw.Container(height: 1 * PdfPageFormat.mm),
        pdfw.BarcodeWidget(
          barcode: Barcode.code93(),
          data: texts.first,
          width: 70 * PdfPageFormat.mm,
          height: 15 * PdfPageFormat.mm,
          drawText: false,
        ),
        pdfw.Container(height: 1 * PdfPageFormat.mm),
        pdfw.Text(
          "\$ ${texts[2]}",
          style: pdfw.TextStyle(
            fontSize: 4 * PdfPageFormat.mm,
            fontWeight: pdfw.FontWeight.bold,
          ),
        ),
        pdfw.Text(
          texts[1],
          style: const pdfw.TextStyle(
            fontSize: 2 * PdfPageFormat.mm,
          ),
        ),
      ],
    );
  }
}
