// import '../localization/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // AppLocalizations get l10n => AppLocalizations.of(this);
}
