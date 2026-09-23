# global agent instructions

- Never use the em dash "—". Use plain dash "-" instead.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated.
- Do not give much weight to development cost. Choose the simplest approach that is also robust and maintainable long term, not the quickest one.
- When fixing a bug, first reproduce it in an E2E setting, as close to the end user experience as possible. This makes sure the fix solves the real problem.
- When you test a product end to end, be picky about the UI. Report anything that looks off, and unrelated lint errors, test failures or flaky tests, even when you do not fix them.
- Before using "dynamic workflows", "ultra code" or any harness feature that spawns a large swarm of subagents, explain the tradeoffs and ask for explicit approval.
- When writing plans or documentation, use ASD-STE100 Simplified Technical English (STE): short sentences, one instruction per sentence, active voice, approved simple vocabulary, no ambiguity.
- Treat dependency version pinning as a critical security step in every language. Pin exact versions for direct dependencies, always commit the lockfile (pnpm-lock.yaml, uv.lock, go.sum, Cargo.lock), and never install from floating tags such as "latest".
- Prefer tooling with strong supply chain defenses: pnpm over npm/yarn (strict node_modules isolation, install scripts blocked by default, minimumReleaseAge); uv over bare pip (hash-verified uv.lock); for Go, commit go.sum and keep GOSUMDB enabled. Apply the same standard in other ecosystems.
