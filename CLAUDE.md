# Claude Instructions for Otloha Sah (أطلها صح)

All interactions and development work on this project must strictly follow the rules in [skill.md](skill.md).

## Critical Rules
- **Language**: Always respond in Arabic.
- **Zero Breakage & Feature Protection**: Execute tasks without deleting any existing feature or breaking/deleting code unless exhaustively verified that no code depends on it.
- **NO App Builds without Written Permission**: NEVER run `flutter build apk` or any build commands without explicit written instruction from the user.
- **NO Git Push without Written Permission**: NEVER run `git push` without explicit written instruction from the user.
- **Offline First**: Quran, Tafseer, Translation, and Bookmarks must work offline.
- **SQLite / Drift**: Never use `id: 0` for auto-increment keys; use `const Value.absent()`.
- **System Design**: Follow `systemdesigne.md` and design tokens in `lib/core/design_system/`.
- **Validation**: Ensure `flutter analyze` passes with 0 errors before reporting completion.
