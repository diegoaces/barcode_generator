import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/barcode_bloc_bloc.dart';

class SearchableList extends StatefulWidget {
  final List<String> codeList;

  const SearchableList({
    Key? key,
    required this.codeList,
  }) : super(
          key: key,
        );

  @override
  State<SearchableList> createState() => _SearchableListState();
}

class _SearchableListState extends State<SearchableList> {
  TextEditingController editingController = TextEditingController();
  var items = [];
  @override
  void initState() {
    items.addAll(widget.codeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: editingController,
            onChanged: (value) {
              filterItems(value);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Buscar',
            ),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Text("No hay coincidencias.")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    String item = items[index];
                    List<String> cols = item.split(',');

                    if (cols.length == 1) {
                      cols.add("");
                      cols.add("");
                    }
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(flex: 1, child: Text(cols[0])),
                              Expanded(flex: 2, child: Text(cols[1])),
                              Expanded(flex: 1, child: Text(cols[2])),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => BlocProvider.of<BarcodeBloc>(context)
                          .add(BarcodeBlocEventSelected(items[index])),
                    );
                  }),
        ),
      ],
    );
  }

  void filterItems(String query) {
    List<String> searchList = [];
    searchList.addAll(widget.codeList);

    if (query.isNotEmpty) {
      setState(() {
        items.clear();
        items.addAll(searchList
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList());
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.codeList);
      });
    }
  }
}
