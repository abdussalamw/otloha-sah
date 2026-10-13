# Universal AI Agents Guidelines (AGENTS.md)

> **Mandatory Universal AI Instruction**:
> Any AI agent, automated workflow, or developer tool operating on this codebase must strictly read and adhere to `skill.md` at the project root.

## Core Rules Summary
1. **Language**: Always respond to the user in Arabic.
2. **Execute Requirements with Zero Breakage**: Fulfill tasks without deleting any feature or breaking/deleting any code, unless strictly verified that no other code or dependency relies upon it. Never rewrite entire existing files unnecessarily.
3. **NO App Builds Without Written Permission**: Absolutely never run build commands (`flutter build apk`, `flutter build appbundle`, etc.) unless the user gives explicit written instructions.
4. **NO Git Push Without Written Permission**: Absolutely never execute `git push` to any remote repository unless the user gives explicit written instructions.
5. **Offline-First**: All Quran, Tafseer, Translation, and Bookmarks features must support offline usage with safe fallbacks.
6. **Database Safety (Drift/SQLite)**: Never hardcode `id: 0` on insert. Always use `const Value.absent()` for auto-increment primary keys.
7. **No Forced Login**: Guest users (`userId == 0`) must have full access to Quran reading, audio listening, bookmarks, and tafseer.
8. **Design System**: Strictly adhere to `systemdesigne.md` and `AppColors` / `AppTypography` design tokens.
9. **Quality Check**: Run `dart analyze` to ensure zero compilation errors before finalizing tasks.

Refer to [skill.md](skill.md) for full architecture and technical requirements.
