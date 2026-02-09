import 'package:flutter/material.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
import 'package:car_rongsok_app/shared/widgets/app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool automaticLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
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
    final titleWidget = AppText(
      title ?? context.l10n.customAppBarTitle,
      style: AppTextStyle.titleMedium,
    );

    // * MenuButton hanya ditampilkan jika actions kosong
    final menuButton = Builder(
      builder: (innerContext) => IconButton(
        icon: const Icon(Icons.menu),
        tooltip: context.l10n.customAppBarOpenMenu,
        onPressed: () {
          Scaffold.of(innerContext).openEndDrawer();
        },
      ),
    );

    final allActions = actions != null
        ? actions
        : [menuButton, const SizedBox(width: 4)];

    return AppBar(
      title: titleWidget,
      actions: allActions,
      automaticallyImplyLeading: automaticLeading,
      leading: leading,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }
}
