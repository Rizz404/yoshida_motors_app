// Copilot Guidelines - Car Rongsok

// 1) Extensions (mandatory)
import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
// Access: context.theme|textTheme|colorScheme|colors|semantic|isDarkMode
// Access: context.l10n|locale|isEnglish|isIndonesian|isJapanese

// 2) Theming (never hardcode colors!)
// ✅ DO: context.colorScheme.primary, context.colors.surface, context.textTheme.bodyMedium
// ❌ DON'T: Color(0xFF...), Colors.red, hardcoded colors

// 3) Logging (replace all print!)
import 'package:car_rongsok_app/core/utils/logging.dart';
// Use: logInfo|logError|logData|logDomain|logPresentation|logService
// Example: logService('Process started'); logError('Failed', e, s);
// ❌ DON'T: Add logging in widgets/screens unless explicitly requested
// ✅ DO: Keep logging in BLoCs, Repositories, Services, Use Cases only
// If unsure about UI logging, ask first: "Perlu logging di widget/screen ini?"

// 4) Comments (Better Comments format)
// TODO: | FIXME: | ! warning | ? question | * important note

// 5) const everywhere possible
// const SizedBox(height: 16), const Duration(milliseconds: 300)

// 6) Response: brief & to the point
// Only mention what changed/added/removed, no lengthy explanations

// 7) Docs: NO .md files unless explicitly requested
// Keep inline comments 1-2 lines max, code should be self-explanatory

// 8) Shared Widgets (use existing components first!)
// Import from: 'package:car_rongsok_app/shared/widgets/...'
// Available:
// - AppButton (primary/secondary/text buttons)
// - AppTextField, AppSearchField (text inputs)
// - AppDropdown, AppCheckbox, AppRadioGroup (form controls)
// - AppDateTimePicker, AppTimePicker (date/time)
// - AppText (themed text widget)
// - CustomAppBar, ScreenWrapper (layout)
// - AdminShell, UserShell, AppEndDrawer (navigation shells)
// ✅ DO: Use these widgets instead of raw Material/Cupertino widgets
// ❌ DON'T: Create new TextField, Dropdown, Button when app widgets exist

// 9) Terminal: use modern CLI tools
// Files: eza, fd, rg, bat, sd | Git: lazygit, gh, delta
// Nav: z (zoxide), fzf, yazi | Dev: glow, jq, tldr, micro
// Monitor: btm, procs, dust, duf
// ❌ Avoid: dir, findstr, find, grep, cat, manual cd

// 10) Text/Localization (IMPORTANT!)
// ✅ DO: Use static text strings by default ('Submit', 'Cancel', etc.)
// ❌ DON'T: Use context.l10n or edit .arb files UNLESS explicitly asked
// Only use translation when user specifically requests it

// Quick examples:
Widget build(BuildContext context) => Container(
  color: context.colors.surface,
  child: AppText('Title', style: AppStyle.titleMedium), // static text
);

AppButton(
  text: 'Submit', // static text unless told to translate
  onPressed: onSubmit,
)

// Logging example (BLoC/Service only, NOT in widgets):
class UserBloc extends Bloc<UserEvent, UserState> {
  Future<void> _onLoad(UserLoad event, Emitter<UserState> emit) async {
    logInfo('Loading user data'); // ✅ OK in BLoC
    try {
      final user = await repository.getUser();
      emit(UserLoaded(user));
    } catch (e, s) {
      logError('Failed to load user', e, s);
    }
  }
}

// Terminal workflows:
// fd -e dart | rg "TODO"  // find TODOs
// eza --tree -L 3 lib/    // show structure
// z sigma                 // jump to project
// lazygit                 // interactive git
