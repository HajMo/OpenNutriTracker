import 'package:equatable/equatable.dart';
import 'package:opennutritracker/core/data/dbo/config_dbo.dart';
import 'package:opennutritracker/core/domain/entity/app_theme_entity.dart';

class ConfigEntity extends Equatable {
  final bool hasAcceptedDisclaimer;
  final bool hasAcceptedPolicy;
  final bool hasAcceptedSendAnonymousData;
  final AppThemeEntity appTheme;
  final bool usesImperialUnits;
  final double? userKcalAdjustment;
  final double? userCarbGoalPct;
  final double? userProteinGoalPct;
  final double? userFatGoalPct;
  final double? waterGoalMl;
  final String? breakfastReminderTime;
  final String? lunchReminderTime;
  final String? dinnerReminderTime;

  const ConfigEntity(
    this.hasAcceptedDisclaimer,
    this.hasAcceptedPolicy,
    this.hasAcceptedSendAnonymousData,
    this.appTheme, {
    this.usesImperialUnits = false,
    this.userKcalAdjustment,
    this.userCarbGoalPct,
    this.userProteinGoalPct,
    this.userFatGoalPct,
    this.waterGoalMl,
    this.breakfastReminderTime,
    this.lunchReminderTime,
    this.dinnerReminderTime,
  });

  factory ConfigEntity.fromConfigDBO(ConfigDBO dbo) => ConfigEntity(
        dbo.hasAcceptedDisclaimer,
        dbo.hasAcceptedPolicy,
        dbo.hasAcceptedSendAnonymousData,
        AppThemeEntity.fromAppThemeDBO(dbo.selectedAppTheme),
        usesImperialUnits: dbo.usesImperialUnits ?? false,
        userKcalAdjustment: dbo.userKcalAdjustment,
        userCarbGoalPct: dbo.userCarbGoalPct,
        userProteinGoalPct: dbo.userProteinGoalPct,
        userFatGoalPct: dbo.userFatGoalPct,
        waterGoalMl: dbo.waterGoalMl,
        breakfastReminderTime: dbo.breakfastReminderTime,
        lunchReminderTime: dbo.lunchReminderTime,
        dinnerReminderTime: dbo.dinnerReminderTime,
      );

  @override
  List<Object?> get props => [
        hasAcceptedDisclaimer,
        hasAcceptedPolicy,
        hasAcceptedSendAnonymousData,
        usesImperialUnits,
        userKcalAdjustment,
        userCarbGoalPct,
        userProteinGoalPct,
        userFatGoalPct,
      ];
}
