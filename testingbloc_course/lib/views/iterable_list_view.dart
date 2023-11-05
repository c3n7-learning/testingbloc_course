import 'package:flutter/material.dart';

class IterableListView<T> extends StatelessWidget {
  final Iterable<T> iterable;

  const IterableListView({super.key, required this.iterable});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: iterable.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(iterable.elementAt(index).toString()),
        );
      },
    );
  }
}

extension ToListView<T> on Iterable<T> {
  Widget toListView() => IterableListView(iterable: this);
}
