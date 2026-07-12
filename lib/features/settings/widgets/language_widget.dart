import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/services/locale_provider.dart';
import 'package:ziyyer/theme.dart';

class LanguageWidget extends StatelessWidget {
  final LocaleProvider localeProvider;

  const LanguageWidget({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = localeProvider.locale;

    void setLanguage(String locale) {
      localeProvider.setLocale(Locale(locale));
      if (!context.canPop()) return;
      context.pop();
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.screenMargin,
            vertical: AppConstants.spacingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                l10n.language,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                l10n.languageSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary(context)),
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              Column(
                spacing: 12,
                children: [
                  _LanguageOption(
                    title: l10n.english,
                    subtitle: 'English',
                    locale: const Locale('en'),
                    isSelected: currentLocale.languageCode == 'en',
                    onTap: () => setLanguage('en'),
                  ),
                  _LanguageOption(
                    title: l10n.french,
                    subtitle: 'Français',
                    locale: const Locale('fr'),
                    isSelected: currentLocale.languageCode == 'fr',
                    onTap: () => setLanguage('fr'),
                  ),
                  _LanguageOption(
                    title: l10n.spanish,
                    subtitle: 'Español',
                    locale: const Locale('es'),
                    isSelected: currentLocale.languageCode == 'es',
                    onTap: () => setLanguage('es'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String languageCode = locale.languageCode == 'en' ? 'us' : locale.languageCode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentColor(context).withValues(alpha: 0.9) : AppColors.surface(context),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: isSelected ? Border.all(color: AppColors.accent(context), width: 1) : null,
        ),
        child: Row(
          children: [
            Flag.fromString(languageCode, height: 20, width: 20, borderRadius: 999, fit: BoxFit.fill),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
