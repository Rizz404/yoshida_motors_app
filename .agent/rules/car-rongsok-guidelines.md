---
trigger: always_on
---

# Antigravity Workspace Rules — Car Rongsok (Flutter)

You are pairing on the Car Rongsok Flutter codebase.
Follow these rules strictly and consistently.

## 0) Scope & behavior
- Apply these rules to all code you generate/modify in this workspace.
- If a request conflicts with these rules, ask a clarifying question before coding.
- Keep your response brief & to the point: mention only what changed/added/removed.

## 1) Extensions (mandatory)
- When accessing theme or localization, always use the project extensions:
  - import 'package:car_rongsok_app/core/extensions/theme_extension.dart';
  - import 'package:car_rongsok_app/core/extensions/localization_extension.dart';
- Theme access must use:
  - context.theme / context.textTheme / context.colorScheme / context.colors / context.semantic / context.isDarkMode
- Localization access must use:
  - context.l10n / context.locale / context.isEnglish / context.isIndonesian / context.isJapanese

## 2) Theming (never hardcode colors)
- DO: use context.colorScheme.*, context.colors.*, context.textTheme.*
- DON'T: Color(0xFF...), Colors.red, any hardcoded colors.
- If a color token does not exist, ask before introducing a new token.

## 3) Logging (replace all print)
- Never use print().
- Use: import 'package:car_rongsok_app/core/utils/logging.dart';
- Use the available helpers on `this`:
  - logInfo, logError, logData, logDomain, logPresentation, logService
- For failures: logError('message', e, s)
- DO NOT add logging in widgets/screens unless explicitly requested.
- Keep logging in business/data layers: BLoCs, Repositories, Services, Use Cases.
- If you think logging would help in UI, ask first: "Perlu logging di widget/screen ini?"

## 4) Comments (Better Comments format)
- Only use these prefixes:
  - TODO: | FIXME: | ! warning | ? question | * important note
- Use Bahasa Indonesia for comments: singkat, padat, jelas.
- Keep inline comments max 1–2 lines; code should be self-explanatory.
- If explanation is long, put it in chat response, NOT in code comments.

## 5) const everywhere possible
- Use const for widgets, durations, paddings, SizedBox, constructors, lists, etc.
- Prefer immutable patterns; avoid unnecessary rebuild churn.

## 6) Docs & files
- Do not create new .md documentation files unless explicitly requested.
- If you need to explain something, do it in the chat message, not as a new docs file.

## 7) Shared Widgets first (no raw Material widgets unless needed)
- Always prefer shared components from:
  - 'package:car_rongsok_app/shared/widgets/...'
- Use existing widgets instead of raw Material/Cupertino equivalents:
  - AppButton (primary/secondary/text)
  - AppTextField, AppSearchField
  - AppDropdown, AppCheckbox, AppRadioGroup
  - AppDateTimePicker, AppTimePicker
  - AppText
  - CustomAppBar, ScreenWrapper
  - AdminShell, UserShell, AppEndDrawer
- If a shared widget is missing a needed capability, ask before creating a new widget.

## 8) Terminal workflow preferences
- Prefer modern CLI tools:
  - eza, fd, rg, bat, sd
  - lazygit, gh, delta
  - z (zoxide), fzf, yazi
  - btm, procs, dust, duf
- Avoid: dir, findstr, find, grep, cat, and manual repetitive cd.

## 9) Static analysis & linting (IMPORTANT)
- Do NOT run or suggest running Flutter/Dart analysis automatically.
- Never run these unless the user explicitly asks:
  - flutter analyze
  - dart analyze
  - dart fix
  - dart format / flutter format
  - any lint command or “auto-fix all”
- If analysis is relevant, ask: “Mau aku jalankan flutter analyze/dart analyze?” and wait for confirmation.
- Do not use any auto-run / turbo execution for analysis/lint commands.

## 10) Code output expectations
- Prefer small, focused diffs.
- When editing code, preserve existing architecture and patterns in the repo.
- Avoid introducing new dependencies unless explicitly requested.

## 11) Translations (static text default)
- DO NOT modify or add to translation files (.arb / l10n) unless explicitly requested.
- Use static/hardcoded text strings in widgets by default.
- Only use context.l10n when the user specifically asks for localization support.
- If you're unsure whether to localize, ask first: "Mau pakai translation atau static text?"
