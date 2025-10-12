import 'package:flutter/material.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:opennutritracker/generated/l10n.dart';

class SetHeightDialog extends StatefulWidget {
  static const _heightRangeCM = 100.0;
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
    final minValue = widget.usesImperialUnits
        ? widget.userHeight - SetHeightDialog._heightRangeFt
        : widget.userHeight - SetHeightDialog._heightRangeCM;

    final maxValue = widget.usesImperialUnits
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
                // Prevent negative minimum height
                minValue: minValue < 0 ? 1 : minValue, // setting it to 1, because 0 triggers zero-division error
                maxValue: maxValue,
                divisions: 400,
                suffix: widget.usesImperialUnits
                    ? S.of(context).ftLabel
                    : S.of(context).cmLabel,
                onChanged: (value) {
                  setState(() {
                    // Prevent negative height values
                    selectedHeight = value < 0 ? 1 : value;
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
            // TODO validate selected height
            Navigator.pop(context, selectedHeight);
          },
          child: Text(S.of(context).dialogOKLabel),
        ),
      ],
    );
  }
}