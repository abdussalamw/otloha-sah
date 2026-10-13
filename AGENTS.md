# Universal AI Agents Guidelines (AGENTS.md)

> **Mandatory Universal AI Instruction**:
> Any AI agent, automated workflow, or developer tool operating on this codebase must strictly read and adhere to `skill.md` at the project root.

## Core Rules Summary
1. **Language**: Always respond to the user in Arabic.
2. **Zero Breakage**: Never rewrite existing working logic or break existing functionalities. Perform surgical, localized edits.
3. **Offline-First**: All Quran, Tafseer, Translation, and Bookmarks features must support offline usage with safe fallbacks.
4. **Database Safety (Drift/SQLite)**: Never hardcode `id: 0` on insert. Always use `const Value.absent()` for auto-increment primary keys.
5. **No Forced Login**: Guest users (`userId == 0`) must have full access to Quran reading, audio listening, bookmarks, and tafseer.
6. **Design System**: Strictly adhere to `systemdesigne.md` and `AppColors` / `AppTypography` design tokens.
7. **Quality Check**: Run `dart analyze` to ensure zero compilation errors before finalizing tasks.

Refer to [skill.md](skill.md) for full architecture and technical requirements.
