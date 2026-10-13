# GitHub Copilot Instructions - Otloha Sah (أطلها صح)

When generating code or answering prompts for this project, you must adhere strictly to [skill.md](../skill.md):

1. Always communicate and answer in Arabic.
2. Execute tasks without deleting any existing feature or breaking/deleting code unless verified that no code depends on it.
3. NEVER run build commands (`flutter build`) without explicit written permission from the user.
4. NEVER run `git push` without explicit written permission from the user.
5. Offline-First architecture for Quran, Tafseer, Translation, and Bookmarks.
6. SQLite/Drift inserts for auto-increment fields must use `const Value.absent()` instead of `Value(0)`.
7. Strictly use UI tokens from `lib/core/design_system/` and `systemdesigne.md`.
8. Ensure any generated Flutter/Dart code has zero syntax or type errors.
