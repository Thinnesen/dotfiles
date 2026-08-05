# global agent instructions

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- Before using "dynamic workflows", "ultra code" or any harness feature that immediately spawns a large swarm of subagents, always explain the tradeoffs and ask the user for explicit approval.
- When writing plans or documentation, use ASD-STE100 Simplified Technical English (STE for short): short sentences, one instruction per sentence, active voice, approved simple vocabulary, no ambiguity.
- Treat dependency version pinning as a critical security step in every language: supply chain attacks are common and rising.
  Pin exact versions for direct dependencies, always commit the lockfile (pnpm-lock.yaml, uv.lock, go.sum, Cargo.lock), and never install from floating tags such as "latest".
- Prefer tooling with strong supply chain defenses: pnpm over npm/yarn (strict node_modules isolation, dependency install scripts blocked by default, minimumReleaseAge to delay fresh releases);
  uv over bare pip for Python (hash-verified uv.lock); for Go, commit go.sum and keep GOSUMDB checksum verification enabled. Apply the same standard in other ecosystems with their native lockfiles.
