# p3-stack

p3-stack is [pstack](https://github.com/cursor/plugins/tree/main/pstack) rebuilt for T3 Code. Same engineering discipline, native T3 orchestration.

pstack is poteto's answer to AI slop code. It turns an agent into an engineering team: one mode skill that routes to playbooks, principles that ground every decision, and verification strict enough that you can parallelize with confidence. p3-stack keeps that system and rewires the mechanics to T3 Code's primitives:

- **Delegation.** `delegate_task` child agents replace Cursor's Task tool, with per-role providers and models resolved from `orchestrator_capabilities`. Cross-model panels are native.
- **Worktrees.** `t3_thread_launch` binds a worker to its own worktree and branch. One writer per worktree, enforced by the app instead of by advice.
- **Watching.** `watch_pull_request` wakes the thread when checks finish, someone comments, or the branch conflicts. No polling loops.
- **Scheduling.** `schedule_task` runs audits and overnight cadences even when no turn is active. No `/loop`.
- **Memory.** `t3_thread_read` and `t3_thread_search` replace mining Cursor transcript files.
- **Proof.** `preview_*` browser tools and `device_*` simulators replace external control skills. Screenshots and recordings land in the thread.

## Install

```bash
git clone https://github.com/Tr1Fecta-7/p3-stack.git
cd p3-stack
./install.sh --global --claude                 # every project on this machine
./install.sh --project /path/to/repo --claude  # one repo only
```

T3 Code does not load skills itself. Each thread's provider does, from its own folder:

- Claude threads run on the Claude Agent SDK, which reads `.claude/skills/` (and Claude plugins), the same as Claude Code. Pass `--claude`.
- Codex and other agents that follow the `.agents/skills/` convention read `.agents/skills/`. The script always links there.

`install.sh` has no default scope. Pass `--global` to link every `skills/*` directory under your home folder, or `--project /path/to/repo` to link it under that repo. Without either it prints usage and exits. Re-running the script relinks existing symlinks and skips anything that is not one.

## Get started

1. Run `/setup-p3`. It reads `orchestrator_capabilities` and writes `p3-models.md`, mapping each role (code, judgment, the review panels) to a provider and model you actually have.
2. Use `/p3-mode` whenever you want rigorous work. It reads the request, picks a playbook, and runs the other skills as the steps need them.
3. Stuck or unsure which skill fits? Ask `/p3-help`.

## The mode

`p3-mode` routes every task. Its playbooks: investigation, bug fix, perf issue, hillclimb, runtime forensics, trace forensics, feature, refactoring, prototype, visual parity, authoring a skill, eval, babysit, shipping, autonomous run, orchestrate, autopilot-full, autopilot-stack, session pickup, pause safely, multi-phase plan, worktree cleanup, opening a PR.

The thread that receives `/p3-mode` runs the playbook. It owns the todo list and every `delegate_task` spawn. The [`p3-agent`](skills/p3-agent/SKILL.md) skill wraps the delegates a run spawns: each brief opens with "Load the `p3-agent` skill first." Never delegate the playbook itself to it.

## Skills

architect, arena, automate-me, benchmark-checklist, blast-radius, bro, correct, create-formal-verification-skill, create-verification-skill, figure-it-out, how, in-your-own-words, interrogate, ketchup, maintain-formal-verification-skill, maintain-verification-skill, make-bot-ui, no-comments, p3-agent, p3-help, recall, reflect, setup-p3, sharpen, show-me-your-work, swarm, tdd, teach, technical-writing, typescript-best-practices, unslop, why.

## Principles

The twenty-four principle skills are indexed inside `p3-mode` and referenced by the other skills by name.

## Staying current with pstack

[`UPSTREAM`](UPSTREAM) pins the pstack commit this repo matches, and [`CHANGES.md`](CHANGES.md) records every sync and every p3-only change.

```bash
scripts/upstream.sh status   # upstream commits since the pin
scripts/upstream.sh files    # changed upstream files mapped to p3-stack paths
scripts/upstream.sh diff     # the upstream diff to port
scripts/upstream.sh pin      # move the pin once the port is done
```

Port each diff through the Cursor to T3 Code map in [AGENTS.md](AGENTS.md#syncing-with-upstream-pstack), never by copying upstream files.

## Credit

p3-stack adapts [pstack](https://github.com/cursor/plugins/tree/main/pstack) by [poteto](https://x.com/poteto). The skills, principles, and language are hers; the T3 Code rewiring is this repo's. MIT, see [LICENSE](LICENSE).
