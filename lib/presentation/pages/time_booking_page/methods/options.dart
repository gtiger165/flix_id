import 'package:flix_id/presentation/widgets/selectable_card.dart';
import 'package:flutter/material.dart';

import '../../../misc/methods.dart';

List<Widget> options<T>({
  required String title,
  required List<T> options,
  required T? selectedItem,
  String Function(T object)? converter,
  bool Function(T object)? isOptionEnable,
  required void Function(T object) onTap,
}) =>
    [
      Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      verticalSpace(10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(
                      left: e == options.first ? 24 : 0,
                      right: e == options.last ? 24 : 10),
                  child: SelectableCard(
                    text: converter != null ? converter(e) : e.toString(),
                    onTap: () => onTap(e),
                    isSelected: selectedItem == e,
                    isEnable: isOptionEnable?.call(e) ?? true,
                  ),
                ),
              )
              .toList(),
        ),
      )
    ];
