import 'package:flutter/material.dart';
import 'package:opennutritracker/features/diary/presentation/bloc/calendar_day_bloc.dart';
import 'package:opennutritracker/features/diary/presentation/bloc/diary_bloc.dart';
import 'package:opennutritracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:opennutritracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opennutritracker/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:opennutritracker/generated/l10n.dart';

class CalculationsDialog extends StatefulWidget {
  final SettingsBloc settingsBloc;
  final ProfileBloc profileBloc;
  final HomeBloc homeBloc;
  final DiaryBloc diaryBloc;
  final CalendarDayBloc calendarDayBloc;

  const CalculationsDialog({
    super.key,
    required this.settingsBloc,
    required this.profileBloc,
    required this.homeBloc,
    required this.diaryBloc,
    required this.calendarDayBloc,
  });

  @override
  State<CalculationsDialog> createState() => _CalculationsDialogState();
}

class _CalculationsDialogState extends State<CalculationsDialog> {
  static const double _maxKcalAdjustment = 1000;
  static const double _minKcalAdjustment = -1000;
  static const int _kcalDivisions = 200;
  double _kcalAdjustmentSelection = 0;

  static const double _defaultCarbsPctSelection = 0.6;
  static const double _defaultFatPctSelection = 0.25;
  static const double _defaultProteinPctSelection = 0.15;

  // Macros percentages
  double _carbsPctSelection = _defaultCarbsPctSelection * 100;
  double _proteinPctSelection = _defaultProteinPctSelection * 100;
  double _fatPctSelection = _defaultFatPctSelection * 100;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeKcalAdjustment();
  }

  void _initializeKcalAdjustment() async {
    final kcalAdjustment = await widget.settingsBloc.getKcalAdjustment() *
        1.0; // Convert to double
    final userCarbsPct = await widget.settingsBloc.getUserCarbGoalPct();
    final userProteinPct = await widget.settingsBloc.getUserProteinGoalPct();
    final userFatPct = await widget.settingsBloc.getUserFatGoalPct();

    setState(() {
      _kcalAdjustmentSelection = kcalAdjustment;
      _carbsPctSelection = (userCarbsPct ?? _defaultCarbsPctSelection) * 100;
      _proteinPctSelection =
          (userProteinPct ?? _defaultProteinPctSelection) * 100;
      _fatPctSelection = (userFatPct ?? _defaultFatPctSelection) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              S.of(context).settingsCalculationsLabel,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8), // Add spacing between text and button
          TextButton(
            child: Text(S.of(context).buttonResetLabel),
            onPressed: () {
              setState(() {
                _kcalAdjustmentSelection = 0;
                // Reset macros to default values
                _carbsPctSelection = _defaultCarbsPctSelection * 100;
                _proteinPctSelection = _defaultProteinPctSelection * 100;
                _fatPctSelection = _defaultFatPctSelection * 100;
              });
            },
          ),
        ],
      ),
      content: Wrap(
        children: [
          DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
              enabled: false,
              filled: false,
              labelText: S.of(context).calculationsTDEELabel,
            ),
            items: [
              DropdownMenuItem(
                child: Text(
                  '${S.of(context).calculationsTDEEIOM2006Label} ${S.of(context).calculationsRecommendedLabel}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: null,
          ),
          const SizedBox(height: 64),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${S.of(context).dailyKcalAdjustmentLabel} ${!_kcalAdjustmentSelection.isNegative ? "+" : ""}${_kcalAdjustmentSelection.round()} ${S.of(context).kcalLabel}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 280,
              child: Slider(
                min: _minKcalAdjustment,
                max: _maxKcalAdjustment,
                divisions: _kcalDivisions,
                value: _kcalAdjustmentSelection,
                label:
                    '${_kcalAdjustmentSelection.round()} ${S.of(context).kcalLabel}',
                onChanged: (value) {
                  setState(() {
                    _kcalAdjustmentSelection = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            S.of(context).macroDistributionLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildMacroField(
            S.of(context).carbsLabel,
            _carbsPctSelection,
            Colors.orange,
            (value) => setState(() => _carbsPctSelection = value),
          ),
          const SizedBox(height: 8),
          _buildMacroField(
            S.of(context).fatLabel,
            _fatPctSelection,
            Colors.green,
            (value) => setState(() => _fatPctSelection = value),
          ),
          const SizedBox(height: 8),
          _buildMacroField(
            S.of(context).proteinLabel,
            _proteinPctSelection,
            Colors.blue,
            (value) => setState(() => _proteinPctSelection = value),
          ),
          const SizedBox(height: 8),
          _buildMacroSumIndicator(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).dialogCancelLabel),
        ),
        TextButton(
          onPressed: () {
            _saveCalculationSettings();
          },
          child: Text(S.of(context).dialogOKLabel),
        ),
      ],
    );
  }

  double get _macroSum =>
      _carbsPctSelection + _proteinPctSelection + _fatPctSelection;

  bool get _macroSumValid => _macroSum.round() == 100;

  Widget _buildMacroField(
    String label,
    double value,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        SizedBox(
          width: 70,
          child: TextFormField(
            initialValue: value.round().toString(),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              suffixText: "%",
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              final parsed = double.tryParse(text);
              if (parsed != null && parsed >= 0 && parsed <= 100) {
                onChanged(parsed);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMacroSumIndicator() {
    final sum = _macroSum.round();
    final isValid = sum == 100;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.warning,
          size: 16,
          color: isValid ? Colors.green : Theme.of(context).colorScheme.error,
        ),
        const SizedBox(width: 4),
        Text(
          "Total: $sum%",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isValid
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  void _saveCalculationSettings() {
    if (!_macroSumValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Macro percentages must total 100%")),
      );
      return;
    }
    // Save the calorie offset as full number
    widget.settingsBloc.setKcalAdjustment(
      _kcalAdjustmentSelection.toInt().toDouble(),
    );
    widget.settingsBloc.setMacroGoals(
      _carbsPctSelection,
      _proteinPctSelection,
      _fatPctSelection,
    );

    widget.settingsBloc.add(LoadSettingsEvent());
    // Update other blocs that need the new calorie value
    widget.profileBloc.add(LoadProfileEvent());
    widget.homeBloc.add(LoadItemsEvent());

    // Update tracked day entity
    widget.settingsBloc.updateTrackedDay(DateTime.now());
    widget.diaryBloc.add(LoadDiaryYearEvent());
    widget.calendarDayBloc.add(RefreshCalendarDayEvent());

    Navigator.of(context).pop();
  }
}
