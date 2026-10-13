# Claude Instructions for Otloha Sah (أطلها صح)

All interactions and development work on this project must strictly follow the rules in [skill.md](skill.md).

## Critical Rules
- **Language**: Always respond in Arabic.
- **Zero Breakage**: Read entire files before editing. Do not overwrite or remove existing comments and logic.
- **Offline First**: Quran, Tafseer, Translation, and Bookmarks must work offline.
- **SQLite / Drift**: Never use `id: 0` for auto-increment keys; use `const Value.absent()`.
- **System Design**: Follow `systemdesigne.md` and design tokens in `lib/core/design_system/`.
- **Validation**: Ensure `flutter analyze` passes with 0 errors before reporting completion.
