import 'package:flutter/material.dart';

class DeallRadioButton extends StatelessWidget {
  const DeallRadioButton({
    super.key,
    required this.value,
    this.groupValue,
    required this.title,
    this.onChanged,
  });

  // Value of the radio button
  final Object value;

  // Group value only one can be choosen
  final Object? groupValue;

  // Title for radio button
  final String title;

  final Function(Object?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Expanded(
              child: Text(
            title,
          ))
        ],
      ),
    );
  }
}
