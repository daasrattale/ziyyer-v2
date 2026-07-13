import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class BudgetHealthSection extends StatefulWidget {
  final double spent;
  final double definedAmount;
  final String currencySymbol;

  const BudgetHealthSection({
    super.key,
    required this.spent,
    required this.definedAmount,
    required this.currencySymbol,
  });

  @override
  State<BudgetHealthSection> createState() => _BudgetHealthSectionState();
}

class _BudgetHealthSectionState extends State<BudgetHealthSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gaugeController;
  late final Animation<double> _gaugeAnimation;

  @override
  void initState() {
    super.initState();
    _gaugeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _gaugeAnimation = CurvedAnimation(
      parent: _gaugeController,
      curve: Curves.easeOutCubic,
    );
    _gaugeController.forward();
  }

  @override
  void didUpdateWidget(covariant BudgetHealthSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spent != widget.spent) {
      _gaugeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _gaugeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final ratio = widget.definedAmount > 0
        ? (widget.spent / widget.definedAmount).clamp(0.0, 1.5)
        : 0.0;
    final healthStatus = _healthStatus(ratio);
    final healthColor = _healthColor(healthStatus);
    final remaining = widget.definedAmount - widget.spent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          border: Border.all(color: AppColors.divider(context), width: 1),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: AppLocalizations.of(context)!.budgetHealth,
              accentColor: healthColor,
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Center(
              child: AnimatedBuilder(
                animation: _gaugeAnimation,
                builder: (context, _) {
                  final animatedRatio = ratio * _gaugeAnimation.value;
                  return SizedBox(
                    width: 160,
                    height: 160,
                    child: CustomPaint(
                      painter: _GaugePainter(
                        ratio: animatedRatio,
                        color: healthColor,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              healthStatus == 'critical'
                                  ? Icons.warning_rounded
                                  : healthStatus == 'warning'
                                      ? Icons.info_rounded
                                      : Icons.check_circle_rounded,
                              color: healthColor,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${(animatedRatio * 100).toInt()}%',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: healthColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              healthStatus == 'critical'
                                  ? AppLocalizations.of(context)!.critical
                                  : healthStatus == 'warning'
                                      ? AppLocalizations.of(context)!.warning
                                      : AppLocalizations.of(context)!.healthy,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary(context),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Divider(color: AppColors.divider(context), height: 1),
            const SizedBox(height: AppConstants.spacingLarge),
            Row(
              children: [
                _HealthStat(
                  label: AppLocalizations.of(context)!.spent,
                  amount: widget.spent,
                  currency: widget.currencySymbol,
                  color: AppColors.expense,
                ),
                const SizedBox(width: AppConstants.spacingLarge),
                _HealthStat(
                  label: AppLocalizations.of(context)!.remaining,
                  amount: remaining,
                  currency: widget.currencySymbol,
                  color: remaining >= 0 ? AppColors.income : AppColors.expense,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _healthStatus(double ratio) {
    if (ratio > 0.9) return 'critical';
    if (ratio > 0.7) return 'warning';
    return 'healthy';
  }

  Color _healthColor(String status) {
    if (status == 'critical') return AppColors.expense;
    if (status == 'warning') return AppColors.info;
    return AppColors.income;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color accentColor;

  const _SectionHeader({
    required this.title,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppConstants.spacingMedium),
        Text(
          title.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary(context),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _HealthStat extends StatelessWidget {
  final String label;
  final double amount;
  final String currency;
  final Color color;

  const _HealthStat({
    required this.label,
    required this.amount,
    required this.currency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.background(context),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius - 4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary(context),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currency,
                    style: textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    AmountFormatter.formatAmount(amount.abs()),
                    style: textTheme.titleLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
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

class _GaugePainter extends CustomPainter {
  final double ratio;
  final Color color;

  _GaugePainter({required this.ratio, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Track
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint..color = Colors.grey.shade200);

    // Progress
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final sweepAngle = 2 * 3.14159 * ratio.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.ratio != ratio || oldDelegate.color != color;
}
