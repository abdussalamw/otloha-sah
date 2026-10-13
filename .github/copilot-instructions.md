# GitHub Copilot Instructions - Otloha Sah (أطلها صح)

When generating code or answering prompts for this project, you must adhere strictly to [skill.md](../skill.md):

1. Always communicate and answer in Arabic.
2. Adhere strictly to the Zero Breakage principle.
3. Offline-First architecture for Quran, Tafseer, Translation, and Bookmarks.
4. SQLite/Drift inserts for auto-increment fields must use `const Value.absent()` instead of `Value(0)`.
5. Strictly use UI tokens from `lib/core/design_system/` and `systemdesigne.md`.
6. Ensure any generated Flutter/Dart code has zero syntax or type errors.
