# Changes

Every pstack sync and every p3-only change, newest first. `UPSTREAM` holds the pstack commit the latest sync reached. See [AGENTS.md](AGENTS.md#syncing-with-upstream-pstack) for the sync steps.

## 2026-10-15: sync pstack 0.15.24 → 0.15.25

Upstream range `1e5c90a..e5136d8` (cursor/plugins, `pstack/`).

### Ported

- **Ketchup explains changes with pictures** (afd51cf). The reply helps the user understand each change, not only where it stands. Screenshots and videos are embedded inline first, then any diagram that explains a change, then one short bullet per thing the user asked for. Action items are plain bullets, and the word limit no longer counts visuals. T3 wiring kept: captures come from `preview_*` and `device_screenshot` and are embedded with Markdown and an absolute path; diagrams and charts use `html_render` after `html_preview`, not `/visualize`; state comes from `list_thread_pull_requests`, `task_status`, and `t3_thread_read`.
- **Four principles restated as reasoning, not rules** (e5136d8). `attack-the-premise` tests the shared premise directly instead of taking a census of actors. `fix-root-causes` fixes the first place the system went wrong, and allows a guard when the state it handles is legitimate. `make-operations-idempotent` derives each step from the state that exists. `test-behavior-not-implementation` judges a test by two imagined edits: break the behavior, and change only the internals. `correct` and `p3-mode`'s principle index follow. Copied verbatim.

### Skipped

- **Version bump** (6ce45c5) and `docs/guide/08-principles.md`, which p3 does not ship.

## 2026-10-14: sync pstack 0.15.23 → 0.15.24

Upstream range `5108b71..1e5c90a` (cursor/plugins, `pstack/`).

### Ported

- **New skill `sharpen`** (79afd75). Typed-only. Before starting, aims the task the way a top expert would, at what the user is really after, without overspecifying it, and always keeps one outside check. Added to `p3-help`'s table, the recipes, and the README skill list.
- **Match the model to the job** (ce649c0). `p3-mode`'s Subagents section starts each spawn from the role's `p3-models.md` line, then raises or lowers the effort level for the job. Upstream changes the slug (`-xhigh`). p3 sets the level through `delegate_task`'s `target.options` (`effort` or `reasoningEffort`), using the ids `orchestrator_capabilities` lists. Verification stays on the `swarm workers` line. Every routed skill and playbook that spawns delegates points at the rule.
- **One full swarm per PR** (ce649c0). `multi-phase-plan`'s skeleton and `autopilot-full` run the full swarm once at the code-ready head, and again only for new behavior, a redesign, or a large diff. A rebase, a conflict fix, or a minor fix gets one verifier.
- **Shipping cut to six steps** (ce649c0). After a merge, the child PR is retargeted to trunk, its patch moves onto the merge result, and it is pushed with `--force-with-lease`; the patch-id rule decides whether its verdict survives. `opening-a-pr` points stacked children at that step. T3 wiring kept: `link_pull_request`, `list_thread_pull_requests`, `delegate_task` verifiers on `preview_*`/`device_*`, and `watch_pull_request` where upstream runs its `watch-pr` script under `/loop`.
- **Autopilot playbooks cut to their principles** (ce649c0, 8043881). `autopilot-stack` now states only where it differs from `autopilot-full`. New rules: pin `--force-with-lease` to the SHA you last pushed or took over, rebase at merge prep only when trunk's changes can affect the patch, and a tick or reply that changed something catches the operator up per `ketchup`. T3 wiring kept: `delegate_task` owners, `schedule_task` for the hourly audit, `task_status`/`t3_thread_read` probes, `task_cancel`, `watch_pull_request`, and re-reading playbooks from the installed skill.
- **Orchestrate drops Graphite wording** (ce649c0). The stacker owns every topology change (chain rebases, force-pushes, retargets, merges), and the brief's FORBIDDEN line bans PR retargets and merges.

### p3-only

- **Fast mode only where `p3-models.md` says so.** Upstream also switches a delegate to fast mode when the job is urgent (CI or trunk red, a person blocked). p3 does not, since fast mode costs more. An entry marked `fast`, as in `cursor/grok-4.6 (high, fast)`, passes the model's fast option (`fastMode: true` or `serviceTier: "priority"`). An entry without it passes none, so it runs at the speed set for that model in T3. `setup-p3` documents the marker, offers it only for models with a fast option, keeps it on re-runs, and never adds it by default. The routed skills say "pick each delegate's reasoning level for the job", without speed.
- **Where to read `p3-models.md`.** `p3-mode` reads the project's file first, then `~/.agents/p3-models.md`. Before, only `setup-p3` named the global location.
- **Where autopilot owners keep their trail.** Upstream puts each owner's decision trail and its delegates' records in "the root agent's store", a Cursor path. T3 has no such store, so the root creates a run folder outside the repo and names its absolute path in every brief. This replaces the uncommitted `decisions.tsv` and `children.tsv` the owners returned with their reports.
- **Fix-forward goes to a fresh owner.** Upstream sends a swarm's findings to the running owner. A T3 delegate cannot take new instructions mid-run, so p3 keeps sending them to a fresh owner with consolidated scope, as before.

### Skipped

- **Origin forge support** (ce649c0 `worktree-audit.sh`, `orch frontier --forge origin`). p3 uses `gh` only.
- **`composer-*` and `cursor-grok-*` slug families** (ce649c0). p3 has no slug-family fallback in `arena` or `interrogate`; it falls back through `orchestrator_capabilities`.
- **`orch` and `watch-pr` script changes** (ce649c0). p3 ships neither.
- **Version bump** (1e5c90a). Cursor packaging.

## 2026-10-14: sync pstack 0.15.21 → 0.15.23

Upstream range `1dcc2ba..5108b71` (cursor/plugins, `pstack/`).

### Ported

- **New skill `in-your-own-words`** (7d8d909, dbf4981). Typed-only. Restates the user's goals and the problem before work starts. Added to `p3-help`'s table, the recipes, and the README skill list.
- **`ketchup` reads like `/bro` in under 150 words** (d00ba6e, c86f349). One visual of at most four boxes for what happened, two lines per action item, and a before/after visual per item. T3 wiring kept: `list_thread_pull_requests`, `task_status` and `t3_thread_read` for state, `preview_*`/`device_screenshot` captures, and `html_preview` + `html_render` for charts where upstream says `/visualize`. `p3-help`'s `/ketchup` row follows.
- **`principle-fix-root-causes`** (36cecbf). After a deep dig, propose the cheap, always-on signal that would have shown the deciding fact at first look.
- **`p3-agent` can find `p3-mode` without a catalog entry** (b93e811). Upstream's fallback searches `~/.cursor/plugins/` when the parent gave no path. p3 points at `../p3-mode/SKILL.md` from `p3-agent`'s own file instead, since `install.sh` links both side by side, and keeps upstream's "your skill list hides it" and "stop and tell your parent". This is not the absolute path in every prompt that the 0.15.21 sync skipped.

### Skipped

- **Frontmatter cleanup and `/` menu note** (b93e811). Upstream drops `mode` and `reminder` from `poteto-mode`; `p3-mode` never had them. The README's "pick from the `/` menu so Cursor attaches the skill" is Cursor-only.
- **Version bumps and plugin manifests** (3177dab, 5108b71). Cursor packaging.

## 2026-10-13: sync pstack 0.15.20 → 0.15.21

Upstream range `1b6d44f..1dcc2ba` (cursor/plugins, `pstack/`).

### Ported

- **Where leaf skills live** (364a77e). `p3-mode` says bundled skills live at `../<name>/SKILL.md` from its own file, so a worker can reach a principle leaf even though leaves are typed-only and never appear in its skill list.

### Skipped

- **Absolute path in every delegate prompt** (364a77e). Upstream has the parent paste `poteto-mode`'s absolute path into each `poteto-agent` prompt, and `poteto-agent` reads from it. p3 already solves this with the model-invocable `p3-agent` skill: a brief opens with "Load the `p3-agent` skill first", and the skill sits next to `p3-mode`. Revisit if workers stop finding `p3-mode` by name.
- **Version bump** (997ffc7). Cursor packaging.

### p3-only

- **Delegates end with nothing running.** A Claude delegate that ends its turn with a background process still running (a dev server started with Bash's background option) never completes: `task_status` stays `running` with `workState: "waiting_for_children"` and `latestTerminalStatus: "completed"`, and the report it ended on is never published. Codex delegates are not affected. `p3-agent` now tells delegates to stop every background process they started before reporting, even when the brief asks otherwise. `p3-mode` tells the parent never to brief a delegate to leave a process running, and how to recover a stuck task (read the branch and `git status`, then `task_cancel`, which also stops the process). Tested in T3 with Haiku and Opus delegates, each change alone. With only the `p3-agent` rule, 5 of 5 stopped their server and completed, including the ones whose brief said to leave it running, but a parent reading `p3-mode` told the user the stuck task was "not done yet" and never cancelled it. With only the `p3-mode` paragraph, the parent recovered correctly, but only 2 of 5 delegates stopped their server, and both "leave it running" briefs got stuck. Both are kept.

## 2026-10-12: upstream parity pass and p3-only fixes

### Upstream parity

A file-by-file comparison of all 112 ported files against pstack 0.15.20 found content the initial port lost, plus a few p3-only slips. 21 of 24 principles and all of `how`/`why` were already clean.

- **Restored upstream content.**
  - `autopilot-full`: the owner's `children.tsv` ledger (step 2), which `autopilot-stack` already referenced, and the per-tick stuck test over it (step 6), using `task_status` and `task_cancel`.
  - `setup-p3` loads from the user's words again, as upstream's `setup-pstack` does. `p3-help` says "Only `/setup-p3` loads from the user's words" again.
  - `automate-me`: the rule that keeps `description` one YAML scalar. Upstream's pointer to Cursor's built-in `create-skill` is dropped.
  - `no-comments`: eval runs need caller pre-approval too.
  - `session-pickup`: upstream's cross-project privacy rule, as "do not pass another project's `projectId`" to `t3_thread_search`.
  - `typescript-best-practices`: the `paths` frontmatter.
- **Shipped two upstream scripts the port had skipped as Cursor-only.** `skills/p3-mode/scripts/check-plan.mjs` is upstream's plan checker, with the program marker `/loop 1h` changed to `schedule_task` and the live-lanes line matching the `swarm workers` role. `multi-phase-plan` step 6 runs it again instead of a shorter hand checklist. `skills/p3-mode/scripts/worktree-audit.sh` is upstream's audit, with the Cursor transcript scan replaced by "anything changed in the last four days" and the bucket renamed `verify-recent-thread`. `worktree-cleanup` runs it again, which defines the buckets the playbook names. `scripts/upstream.sh` maps both, so upstream fixes reach them. `watch-pr` and `orch` stay unported, since `watch_pull_request` and T3's thread tools replace them.
- **Fixed.**
  - `swarm` says `inherit-parent`, not `inherit`.
  - `architect`'s runner prompt links `rationale-template.md` correctly.
  - `p3-help` links this repo, not `uzairansaruzi/p3-stack`.
  - Four playbooks lose stray skill frontmatter.
- **Claude-thread skill folders.** `create-verification-skill` writes `.agents/skills/verify-<app>/` and links it from `.claude/skills/`, `automate-me` searches and links both folders, `maintain-verification-skill` expects the link, and `reflect`'s reviewers count skills read from `.claude/skills/` or loaded by name.

### p3-only

- **Long programs re-read playbooks from the installed skills.** `multi-phase-plan`, `autopilot-full` and `autopilot-stack` told the root to re-read playbooks with `git show origin/main:skills/p3-mode/...`, a path that exists only in the p3-stack repo, not in the project a plan runs in. They now re-read from the installed skills folder, which follows the p3-stack checkout. `check-plan.mjs` looks for `p3-mode/playbooks/` instead of `git show origin/main:`. Upstream has the same pattern with its own repo path.
- `CHANGES.md` drops the `Unreleased` heading. Installed skills link to the checkout, so a change merged to `main` is live after a pull, and every entry goes under a dated heading.

- `install.sh --claude` also links the skills into `.claude/skills/` (under `$HOME`, or the repo with `--project`), since Claude Code does not read `.agents/skills/`.
- README, `install.sh`, `p3-help` and `AGENTS.md`: T3 Code loads skills through each thread's provider, so Claude threads read `~/.claude/skills/` and Codex reads `~/.agents/skills/`. The old text said T3 Code reads `~/.agents/skills/`.
- **`agents/p3-agent.md` is now the `p3-agent` skill.** The initial port told the parent to "point the worker at `agents/p3-agent.md`", and the note told the worker to read `skills/p3-mode/SKILL.md`. Both paths only resolve inside the p3-stack repo, and `install.sh` never installed `agents/`, so a worker in another project skipped p3-mode or searched the whole disk for it. A skill installs next to `p3-mode` and the principles, so a brief now opens with "Load the `p3-agent` skill first", by name, as Cursor spawns `poteto-agent` by name. `p3-agent` is model-invocable so workers can load it. `scripts/upstream.sh` maps upstream's `agents/poteto-agent.md` to it.
- **The `p3-agent` text follows upstream again.** Its body is upstream's `poteto-agent.md` paragraph with T3 terms, including "the `p3-mode` skill's `SKILL.md`" instead of a path. The description regains upstream's fresh-delegate rule and "a brief without this note skips that read and drifts". The port's extra paragraph on brief scope and git is gone, since every brief already carries its constraints.
- **`agents/comment-sicko.md` moved to `skills/no-comments/references/comment-sicko.md`**, the only skill that uses it, so `no-comments` reads it from its own folder. `scripts/upstream.sh` maps it.
- `autopilot-stack`: the comment pass runs `/no-comments`, as upstream does, instead of pointing at `agents/comment-sicko.md`.

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
