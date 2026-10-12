# Changes

Every pstack sync and every p3-only change, newest first. `UPSTREAM` holds the pstack commit the latest sync reached. See [AGENTS.md](AGENTS.md#syncing-with-upstream-pstack) for the sync steps.

## Unreleased

Nothing yet.

## 2026-10-12: sync pstack 0.15.10 → 0.15.20

Upstream range `4e5b1cf..1b6d44f` (cursor/plugins, `pstack/`).

### p3-only

- Add `UPSTREAM` (the pin) and `scripts/upstream.sh` (`status`, `files`, `diff`, `pin`) for tracking pstack.
- Add this file, the "Syncing with upstream pstack" section of `AGENTS.md`, and the "Staying current with pstack" section of the README.
- README: clone from `Tr1Fecta-7/p3-stack`, list `ketchup`, and state that the thread receiving `/p3-mode` runs the playbook.

### Ported

- **New skill `ketchup`** (978ca6e, ea32d95). Catches the user up on everything since their last message, with an executive summary per action item. Before/after visuals use `preview_*`/`device_screenshot` captures and `html_preview` + `html_render` collages. State is read with `list_thread_pull_requests`, `task_status`, and `t3_thread_read`.
- **`p3-help`** (00b52d9, 807c031, 1e56b29). Typed-only (`disable-model-invocation: true`). New `references/prompting.md` and `references/recipes.md`, with `/loop` rewritten as "run until done". Asks once per thread about `/setup-p3` when `p3-models.md` is missing. Adds a `/ketchup` row and a `/ketchup` vs `/recall` close call.
- **The thread runs `/p3-mode`, and `p3-agent` is only a delegate** (2bd5dd4). Applied in `p3-mode/SKILL.md` and `agents/p3-agent.md`.
- **`worktree-cleanup`** (cf9a111, 08bd59b). Judge merge state against the default branch (`origin/HEAD`, then `origin/main`, then `origin/master`) or the PR target, after fetching it. Upstream fixed this in `worktree-audit.sh`; p3 carries it as prose. Intro cut.
- **`create-verification-skill`** (c49b37a). Ready means usable from an empty data dir, not a port answering. An unsatisfiable journey reports failure with the reason in Gotchas. Setup done only by a stand-in stays unverified until the real target is run.
- **`unslop`** (bc697d0). "Must always apply." is dropped from the description.
- **`setup-p3`** (df58112). The budget-to-effort map is now unlimited/large/medium/small → max/xhigh/high/medium, and the default budget is `large (xhigh)`.
- **Token-cutting distillation** (00b14f1, 08bd59b), carried through with T3 wiring kept:
  - `p3-mode`: principle leaf names and playbook paths derived from titles.
  - `babysit`, `opening-a-pr`, `trace-forensics`.
  - `architect` (+ runner prompt), `arena`, `benchmark-checklist`, `blast-radius`, `figure-it-out`, `technical-writing`.
  - `how` (+ explorer prompt), `interrogate` (+ reviewer prompt, rubric), `reflect` (+ all four reviewer/synthesizer prompts).
  - `why` (+ epistemics, investigator and synthesizer prompts, and the code-archaeology, datadog, incident-postmortem, sentry and slack sources).
  - Thirteen principles: build-the-lever, encode-lessons-in-structure, exhaust-the-design-space, explain-the-number, guard-the-context-window, laziness-protocol, minimize-reader-load, model-the-domain, never-block-on-the-human, redesign-from-first-principles, subtract-before-you-add, test-behavior-not-implementation, type-system-discipline.

### Skipped

- **Model defaults** (df58112: drop Sol, Opus `xhigh`, Grok). p3 resolves roles through `setup-p3`, so there are no slugs to swap. Upstream also shrank `interrogate` from three reviewers to two. p3 still sizes panels at one entry per detected provider, up to three. Edit the `interrogate reviewers` line in `p3-models.md` to change it.
- **Comment Sicko id rename** (de2dba6). p3 passes `agents/comment-sicko.md` as `delegate_task` brief text and has no agent id.
- **Script-only fixes** (ff8f83d watch-pr pagination, 87c8103 check-plan fenced blocks). p3 replaces `watch-pr` with `watch_pull_request` and does not ship `check-plan.mjs`.
- **Cursor packaging** (e5a02f8 Agent Plugins manifest, 1b6d44f version bump), plus the `docs/guide` refresh (2cbf585). p3 ships no Cursor manifests and no guide.
- `reflect` step 1's transcript-JSONL discovery. p3 reads threads with `t3_thread_read` and `t3_thread_search`.

## 2026-10-05: initial port of pstack 0.15.10

Ported from upstream `4e5b1cf` (pstack 0.15.10) by Uzair Ansar in `uzairansaruzi/p3-stack` (`c4824d3`, `09909eb`). It renames `poteto-mode`, `poteto-agent`, `poteto-help` and `setup-pstack` to `p3-mode`, `p3-agent`, `p3-help` and `setup-p3`, and rewires every Cursor mechanism to T3 Code per the map in `AGENTS.md`.
