import 'package:auto_route/auto_route.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool automaticLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.automaticLeading = true,
    this.leading,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final defaultTitleWidget = AppText(
      title ?? context.l10n.customAppBarTitle,
      style: AppTextStyle.titleMedium,
    );

    final defaultLeading = Builder(
      builder: (innerContext) {
        final router = AutoRouter.of(innerContext);
        if (router.canPop()) {
          return const BackButton();
        }
        return IconButton(
          icon: const Icon(Icons.menu),
          tooltip: context.l10n.customAppBarOpenMenu,
          onPressed: () {
            Scaffold.of(innerContext).openDrawer();
          },
        );
      },
    );

    return AppBar(
      title: titleWidget ?? defaultTitleWidget,
      actions: actions,
      automaticallyImplyLeading: automaticLeading,
      leading: leading ?? (automaticLeading ? defaultLeading : null),
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }
}
