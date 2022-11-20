import 'package:deall/core/core.dart';
import 'package:flutter/material.dart';

class DeallChip extends StatelessWidget {
  const DeallChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;

  final bool selected;

  final Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? context.res.colors.white : context.res.colors.textBlack;
    return ChoiceChip(
      label: Text(
        text,
      ),
      labelStyle: context.res.styles.button3.copyWith(color: color),
      selected: selected,
      onSelected: onSelected ?? (val) {},
      selectedColor: context.res.colors.lightOrange1,
      backgroundColor: context.res.colors.lightOrange2,
    );
  }
}
