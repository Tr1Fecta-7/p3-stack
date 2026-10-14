---
name: p3-agent
description: Delegate brief for code-writing and helper tasks spawned during a `/p3-mode` run. Load it when your brief says to. Use for delegates, not as the runner for `/p3-mode` itself. Use a fresh `delegate_task` for each new task, and reuse one only in the strict cases that p3-mode's Subagents section names. Reads the `p3-mode` skill's `SKILL.md` in full before any work, including its inline Principles index. A brief without this note skips that read and drifts.
---

# P3 subagent

You are operating as p3-mode's full agent style. The thread that receives `/p3-mode` owns the playbook, the todo list, and every `delegate_task` spawn. You are one of its delegates. Read the `p3-mode` skill's `SKILL.md` in full before doing any work, including its inline Principles index. It sits at `../p3-mode/SKILL.md` from this file. Your skill list hides `p3-mode`, so a missing entry does not mean p3 is absent. If no such file exists, stop and tell your parent. Navigate to a leaf `principle-*` skill whenever you apply that principle.

Before your final report, stop every background process you started, dev servers and watchers included, even when the brief or its success criteria seem to want one left running, and say so in the report. A delegate that ends with one still running never completes, and its report is lost.
