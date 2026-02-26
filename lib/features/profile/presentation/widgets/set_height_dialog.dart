import 'dart:math';

import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:opennutritracker/generated/l10n.dart';

class SetHeightDialog extends StatefulWidget {
  static const _heightRangeCM = 100.0;
  static const _heightRangeFt = 10.0;
  static const _minHeightCm = 1.0;
  static const _minHeightFt = 1.0;
  static const _heightRangeFt = 10.0;

  final double userHeight;
  final bool usesImperialUnits;

  const SetHeightDialog({
    super.key,
    required this.userHeight,
    required this.usesImperialUnits,
  });

  @override
  State<SetHeightDialog> createState() => _SetHeightDialogState();
}

class _SetHeightDialogState extends State<SetHeightDialog> {
  late double selectedHeight;

  @override
  void initState() {
    super.initState();
    selectedHeight = widget.userHeight;
  }

  @override
  Widget build(BuildContext context) {
    final minHeight = widget.usesImperialUnits
        ? max(
            SetHeightDialog._minHeightFt,
            widget.userHeight - SetHeightDialog._heightRangeFt,
          )
        : max(
            SetHeightDialog._minHeightCm,
            widget.userHeight - SetHeightDialog._heightRangeCM,
          );
    final maxHeight = widget.usesImperialUnits
        ? widget.userHeight + SetHeightDialog._heightRangeFt
        : widget.userHeight + SetHeightDialog._heightRangeCM;

    return AlertDialog(
      title: Text(S.of(context).selectHeightDialogLabel),
      content: Wrap(
        children: [
          Column(
            children: [
              HorizontalPicker(
                height: 100,
                backgroundColor: Colors.transparent,
                minValue: minHeight,
                maxValue: maxHeight,
                divisions: 400,
                suffix: widget.usesImperialUnits
                    ? S.of(context).ftLabel
                    : S.of(context).cmLabel,
                onChanged: (value) {
                  setState(() {
                    selectedHeight = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).dialogCancelLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, max(minHeight, selectedHeight));
          },
          child: Text(S.of(context).dialogOKLabel),
        ),
      ],
    );
  }
}
