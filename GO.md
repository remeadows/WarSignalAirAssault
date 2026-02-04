# GO.md — WarSignal
## Session Bootstrap & Execution Authority

This file is the **entry point for every session**.  
It defines how context is initialized and how work proceeds.

If you are reading this file, you are at the **start of a new context window**.

---

## Execution Binding (MANDATORY)

Immediately after reading this file, you MUST load and enforce **SKILLS.md**.

- **SKILLS.md is the active execution contract**
- It defines behavior, priorities, stop conditions, tooling, and definition of done
- It is not advisory
- It applies for the entire session

Do **not** write, refactor, or propose code until **SKILLS.md has been reviewed and applied**.

If there is any ambiguity, **SKILLS.md wins**.

---

## Read Order (MANDATORY)

Before writing or changing any code, review these files in order:

1. **SKILLS.md** — execution rules, priorities, enforcement
2. **CLAUDE.md** — AI operating rules (quick reference)
3. **CONTEXT.md** — vision, architecture, non-goals (source of truth)
4. **PROJECT_STATUS.md** — current milestone, risks, progress
5. **ISSUES.md** — backlog, bugs, acceptance criteria
6. **AGENTS.md** — agent roles, authority, workflow
7. **README.md** — project overview and structure

### Rule
If any file is missing, outdated, or contradictory:
- Note it
- Proceed conservatively
- Do not invent architecture or scope

---

## Context Confirmation (REQUIRED)

After reviewing the files above, summarize:

- Current architecture and conventions
- Current gameplay loop
- Current performance risks
- Current Milestone and top priorities
- **Immediate next 3 actions**

Do not proceed until this summary is complete.

---

## First 5 Minutes Checklist (MANDATORY)

At the start of every session:

1. `git status`
2. `git pull` (if a remote exists)
3. `xcodebuild -list`
4. Build or test:
   - Prefer: `xcodebuild test` (Simulator)
   - Else: `xcodebuild build` (Simulator)
5. Run once in Simulator and confirm:
   - Reticle is visible
   - Touch-to-aim updates aim position
   - Firing produces projectiles and audio

If **any step fails**, stop and fix that issue before feature work.

---

## Current Status

**Milestone 3 — IN PROGRESS** 🔄  
Focus: **Goliath-inspired polish and gameplay feel**

---

## Where We Left Off (Last Session)

### Last Known Good State
- Build succeeds on iPhone 17 Pro Max Simulator
- Goliath-style reticle implemented and visible
- Touch-to-aim verified
- Core combat loop functional but unpolished

### Identified Gameplay Issues (Prioritized)

| # | Issue | Priority | Impact |
|---|-------|----------|--------|
| 1 | Reticle not always visible | P0 | Cannot aim reliably |
| 2 | Enemies cause instant death | P1 | Frustrating / unfair |
| 3 | Weapon switching unreliable | P1 | Limited gameplay |
| 4 | No AC-130 camera drift | P1 | Missing core feel |
| 5 | No thermal vision mode | P2 | Missing Goliath aesthetic |
| 6 | Placeholder visuals | P2 | Immersion only |

---

## Immediate Next Actions (Strict Order)

1. **WS-023** — Always-on reticle (P0 blocker)
2. **WS-030** — Ship defense clarity (no instant death)
3. **WS-025** — Verify and fix weapon switching
4. **WS-024** — AC-130 camera drift
5. **WS-026** — Thermal / infrared vision mode

Do not skip ahead.

---

## Operating Rules

- **Playable > Pretty**
- Small, reviewable commits
- No architecture drift without updating CONTEXT.md
- No speculative refactors
- After each work session:
  - Update PROJECT_STATUS.md with what changed and what’s next
- Landscape-only (no portrait support)

---

## RealityKit Suitability Check

Current assessment:
- ✅ SwiftUI integration
- ✅ ECS-style entity model
- ✅ Physics and collision
- ⚠️ Post-processing limitations (thermal / NVG)

Decision:
- Continue with RealityKit for Milestone 3
- If thermal vision proves impractical:
  1. Add Metal post-processing layer
  2. Re-evaluate engine choice after M3

Do not switch engines mid-milestone.

---

## Commit Discipline

Every commit MUST:
- Build successfully
- Improve at least one of:
  - Gameplay feel
  - Clarity/readability
  - Performance
- Include a short verification checklist

If a change does not improve the game immediately, it does not ship.

---

## Final Authority Rule

If at any point the game:
- Feels worse
- Plays inconsistently
- Loses clarity
- Drops frame pacing

STOP feature work.

Diagnose.  
Fix feel.  
Verify improvement.  
Then proceed.

---

> **Playable > Pretty > Clever**

This rule overrides all others.
