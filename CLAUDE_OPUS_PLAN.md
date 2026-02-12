# CLAUDE_OPUS_PLAN.md

**To:** Russ Meadows, Founder — WarSignalLabs  
**From:** Claude Opus 4.6 (Candidate for Project Manager)  
**Date:** February 12, 2026  
**Subject:** Project Management Plan — WarSignal AirAssault

---

## 1. Understanding the PM Challenge

### Why This Project Is Harder Than Traditional Solo Dev

This isn't a single-developer project with one context window. It's a **distributed system of stateless agents** coordinating through documents. That distinction drives every failure mode I need to defend against.

**The core problem:** Six AI agents, each with amnesia between sessions, no shared memory, no ability to talk to each other, producing interdependent outputs that must integrate cleanly into a single Xcode project — managed by one human who is simultaneously founder, decision-maker, playtester, and asset reviewer.

**Specific failure modes I'm defending against:**

| # | Failure Mode | How It Kills the Project | v1 Evidence |
|---|---|---|---|
| 1 | **Agent drift** — an agent reinterprets a locked spec | Cascading inconsistencies discovered late during integration | v1 had no specs; systems fought each other |
| 2 | **Integration mismatch** — outputs from two agents don't fit together | Claude Code burns sessions debugging contract violations instead of building features | v1 had multiple systems implemented simultaneously with no validation |
| 3 | **Russ bottleneck** — too many decisions queued, project stalls waiting for approvals | Velocity drops to zero; momentum dies | v1 stalled from circular development |
| 4 | **Scope creep via suggestion** — agents propose expansions outside their lane | Features multiply, complexity compounds, timeline explodes | — |
| 5 | **Context window amnesia** — agent loses state between sessions, redoes or contradicts previous work | Circular development; the exact v1 failure pattern | v1's primary cause of death |
| 6 | **Playtest gate failure** — a phase makes the game feel worse, but gets committed anyway | Compounding gameplay regressions; the game never feels right | v1 shipped nothing playable |
| 7 | **Document rot** — canonical docs diverge from actual implementation | Agents build against stale specs; trust in docs collapses | — |
| 8 | **Single-threaded human** — Russ context-switches between PM, art reviewer, narrative approver, and playtester | Decision fatigue, inconsistent approvals, burnout | Solo founder reality |

**What makes this different from a human team:** Human teams have ambient knowledge transfer — hallway conversations, shared Slack channels, the ability to ask "hey, what did you mean by X?" AI agents have none of that. Every piece of context must be explicitly written, versioned, and delivered in a briefing packet. If it's not in the packet, it doesn't exist.

**What makes this different from v1:** v1 failed because there was no plan, no specs, no validation between steps, and no stop conditions. This time we have the documentation suite. My job is to make sure those documents actually govern execution rather than sitting inert in a repo.

---

## 2. Project State Assessment

### Phase 0 Status Audit

I've reviewed all canonical docs and all 5 agent plans. Here's the actual state:

| Phase 0 Checklist Item | Status | Blocker? |
|---|---|---|
| **0.1 — Game Design Lock** | | |
| Core gameplay loop documented | ✅ Done (GAME_DESIGN.md) | No |
| 10 level concepts defined | ✅ Done | No |
| Weapon specs finalized | ✅ Done (3 weapons, tiers, costs) | No |
| Enemy types defined | ✅ Done (11 types with stats) | No |
| Characters assigned roles | ⚠️ 4 unassigned (Malus, AXIOM, Tee, Rusty) | **YES — Russ** |
| Aircraft defenses defined | ✅ Done | No |
| Ground team upgrades defined | ✅ Done | No |
| Economy defined | ⚠️ Drafted, Gemini found 26K credit deficit | **YES — Russ** |
| HUD layout finalized | ⚠️ Grok has spec, unapproved | **YES — Russ** |
| Controls finalized | ✅ Done | No |
| **0.2 — Asset Planning** | | |
| ASSET_MANIFEST.md complete | ✅ Drafted (~75 images) | No |
| Asset list approved by Russ | ❌ Not done | **YES — Russ** |
| Character images — keep or regen? | ❌ Not done | **YES — Russ** |
| **0.3 — Architecture Lock** | | |
| Engine documented | ✅ Done (SceneKit) | No |
| Folder structure finalized | ✅ Done | No |
| Data flow reviewed | ✅ Done | No |
| All systems scoped | ✅ Done | No |
| **0.4 — Milestone Plan Lock** | | |
| MILESTONES.md reviewed | ✅ Done (99 tasks, 8 phases) | No |
| Russ approved milestones | ❌ Not done | **YES — Russ** |
| **0.5 — Narrative & Lore** | | |
| Briefing format defined | ⚠️ GPT proposed, unapproved | **YES — Russ** |
| Universe context provided | ⚠️ Partial | Russ |
| Character voice notes | ❌ Not done | **YES — Russ** |
| 10-level story arc | ⚠️ GPT proposed, unapproved | **YES — Russ** |

### Critical Path to Phase 1

Every blocker above converges on one person: **Russ**. The critical path is Russ's approval queue.

**The optimal sequence to unblock everything:**

```
SPRINT 0A — "The Decision Session" (single Russ session, ~90 min)
├── 1. Review GPT character proposals (Malus, AXIOM, Tee, Rusty)     → ACCEPT / MODIFY / REJECT
├── 2. Review existing character images                               → KEEP / REGENERATE per character
├── 3. Review GPT 10-level narrative arc                              → ACCEPT / MODIFY
├── 4. Review Gemini economy rebalance (credit deficit fix)           → ACCEPT / MODIFY
├── 5. Review Grok visual identity (color palette, HUD spec)         → ACCEPT / MODIFY
└── 6. Review + approve asset manifest                                → ACCEPT with changes noted

SPRINT 0B — "Agent Revisions" (parallel, no Russ needed)
├── GPT revises narrative per Russ feedback
├── Gemini finalizes economy numbers per Russ feedback
├── Grok finalizes visual identity per Russ feedback
└── Codex finalizes protocol interfaces (no Russ dependency)

SPRINT 0C — "Final Lock" (single Russ review, ~30 min)
├── Approve revised narrative arc
├── Approve revised economy model
├── Approve milestone plan
└── Sign off on Phase 0 completion → PHASE 1 GO

SPRINT 0D — Phase 1 Kickoff
├── Opus creates Phase 1 briefing packets
├── Claude Code creates Xcode project
└── Development begins
```

**Key insight:** Sprints 0A and 0C are the only sessions requiring Russ. Everything else can proceed asynchronously. I've designed this to minimize Russ's decision surface to two focused sessions totaling ~2 hours.

---

## 3. Agent Management Strategy

### The Fundamental Constraint

These agents cannot talk to each other. They have no shared memory. They forget everything between sessions. The only things that persist are:

1. **Canonical documents** — the source of truth
2. **HANDOFF.md** — the shared work log
3. **Briefing packets** — my per-agent context injections

This means my communication architecture must be **hub-and-spoke**, not mesh:

```
                    ┌─────────────────┐
                    │      RUSS        │
                    │  (Final Authority)│
                    └────────┬────────┘
                             │ Decisions
                             ▼
                    ┌─────────────────┐
                    │   OPUS (PM)      │
                    │ Hub + Reviewer   │
                    └──┬──┬──┬──┬──┬──┘
           ┌───────────┘  │  │  │  └───────────┐
           ▼              ▼  ▼  ▼              ▼
     ┌──────────┐  ┌────┐┌────┐┌─────┐  ┌──────────┐
     │Claude Code│  │GPT ││Grok││Gemin│  │  Codex   │
     │(Lead Dev) │  │Narr││Art ││Econ │  │(Utility) │
     └──────────┘  └────┘└────┘└─────┘  └──────────┘
           ▲                                    │
           │         ┌──────────┐               │
           └─────────│Gemini CLI│◄──────────────┘
                     │  (QA)    │
                     └──────────┘
```

### Per-Agent Management Approach

| Agent | Context Limit Risk | Primary Output | Management Strategy |
|---|---|---|---|
| **Claude Code** | Low (CLI, persistent project) | Swift code, Xcode builds | Longest context, most capable. Gets full HANDOFF.md + phase briefing. Single-task assignments with explicit acceptance criteria. |
| **GPT** | Medium (session-based) | Narrative text, dialogue scripts | Strong creative instinct but prone to scope expansion. Needs hard lane constraints. Review for tone consistency + character fidelity. |
| **Grok** | Medium (session-based) | Visual specs, color systems, prompts | Good systems thinking but may over-specify. Needs clear "spec only, no implementation" boundaries. Review against ARCHITECTURE.md. |
| **Gemini** | Medium (session-based) | Economy JSON, balance spreadsheets | Strong analytical output. Validate math independently. Cross-check against GAME_DESIGN.md numbers. |
| **Codex** | Low (CLI) | Swift protocols, utilities | Highly focused output. Low drift risk. Review for API surface cleanliness and ARCHITECTURE.md compliance. |
| **Gemini CLI** | Low (CLI) | Test checklists, perf benchmarks | Methodical but verbose. Needs explicit "deliverable format" constraints. Review for actionability. |

### Communication Architecture

**Inbound to agent:** Briefing packet (context + task + constraints + deliverable format + stop conditions)

**Outbound from agent:** Deliverable file dropped in `/active/{agent}/`

**Review loop:** Opus reviews → APPROVED (promoted to `/canonical/`) or NEEDS REVISION (feedback packet sent back)

**Cross-agent state:** HANDOFF.md is the single source of truth. Every agent reads it at session start. Every agent appends to it at session end. I maintain it as PM.

**Conflict resolution:** I resolve agent-vs-agent conflicts by reference to canonical docs. If canonical docs don't cover it, I package the decision for Russ.

---

## 4. Briefing Packet Methodology

### What Makes a Good Briefing Packet

A briefing packet is the **entire world** an agent sees. If it's not in the packet, the agent doesn't know about it. Every packet must answer:

1. **WHO are you?** — Role, authority, boundaries
2. **WHERE are we?** — Current project phase, what just happened, what's blocked
3. **WHAT do you need to produce?** — Explicit deliverable with format spec
4. **WHAT are the constraints?** — What you CANNOT change, what's locked
5. **WHAT does "done" look like?** — Acceptance criteria, not vibes
6. **WHEN do you stop?** — Explicit stop conditions to prevent drift

### Minimum Information Set

```
BRIEFING_PACKET := {
    agent_role:         string       // Who you are
    phase:              int          // Current phase
    task_id:            string       // From MILESTONES.md
    task_description:   string       // What to build
    relevant_docs:      [string]     // Excerpts from canonical docs (not "go read X")
    constraints:        [string]     // Hard boundaries
    deliverable_format: string       // Exact filename, structure, content spec
    acceptance_criteria:[string]     // Pass/fail conditions
    stop_conditions:    [string]     // When to stop and hand off
    dependencies:       [string]     // What must exist before you start
    handoff_context:    string       // Relevant HANDOFF.md excerpt
}
```

### Complete Example: Claude Code — Phase 1 Briefing Packet

```markdown
# BRIEFING: Claude Code — Phase 1, Sprint 1

## Your Role
Lead Developer. You write all production Swift code, manage the Xcode project,
and commit to the WarSignal repo.

## Current State
Phase 0 is complete. All canonical docs are approved. Phase 1 begins now.
No code exists yet. The repo contains only planning documents.

## Your Task (Sprint 1 of Phase 1)
Implement tasks P1-01 through P1-06 in sequence. ONE TASK AT A TIME.
Build and verify each task before starting the next.

### P1-01: Xcode Project Setup
- Create new Xcode project: WarSignal
- Target: iOS 26+, iPhone, landscape-only
- Frameworks: SceneKit, SwiftUI
- Bundle ID: com.warsignallabs.warsignal
- Acceptance: Blank SCNScene renders full-screen in landscape in Simulator

### P1-02: Folder Structure
- Match ARCHITECTURE.md folder layout exactly:
  [insert full folder tree from ARCHITECTURE.md here]
- Create placeholder .swift files in each folder
- Acceptance: All folders exist, project builds, structure matches ARCHITECTURE.md

### P1-03: GameState
- Create GameState.swift as @Observable class, @MainActor
- Properties: playerHealth (100), shieldHealth (0), currentWeapon (.vulcan),
  ammoCount (500), score (0), missionTimer (0.0), missionStatus (.notStarted),
  groundTeamHealth (200)
- Acceptance: SwiftUI Preview can read all properties

### P1-04: GameEngine
- Create GameEngine.swift implementing SCNSceneRendererDelegate
- renderer(_:updateAtTime:) calculates deltaTime, calls update loop
- Owns SCNScene instance
- Does NOT know about SwiftUI
- Acceptance: Game loop fires every frame, deltaTime logged to console

### P1-05: GameSceneView (UIViewRepresentable)
- Wraps SCNView in UIViewRepresentable
- Connects GameEngine as delegate
- Fills entire screen
- Acceptance: SCNView renders in SwiftUI, fills screen in landscape

### P1-06: Ground Plane
- 274×274 unit SCNPlane, horizontal (rotated -90° on X)
- Placeholder gray texture
- Acceptance: Visible from camera, fills viewport

## Constraints (DO NOT VIOLATE)
- SwiftUI NEVER touches SCNNodes directly
- Unidirectional data flow: SwiftUI reads GameState, sends commands →
  GameEngine writes GameState
- Projectile pooling is mandatory (not needed yet, but design with it in mind)
- 60fps target on all builds
- No debug prints in production paths
- Commit after each task with format: [P1] description

## Stop Conditions
- STOP after P1-06 is committed
- Do NOT start P1-07 (OrbitalCamera) — that's Sprint 2
- If any task fails to build, fix it before moving on
- If any task causes a regression, fix the regression first

## Dependencies
- ARCHITECTURE.md (folder structure, data flow) — excerpt included above
- GAME_DESIGN.md (ground plane size: 274×274) — excerpt included above
- No other agent outputs needed for Sprint 1

## HANDOFF Entry (append when complete)
[YYYY-MM-DD] Claude Code — P1 Sprint 1 Complete
- P1-01 through P1-06 implemented and committed
- Xcode project builds, scene renders, game loop running
- Ready for Sprint 2 (OrbitalCamera, Zoom, InputManager)
```

---

## 5. Review Methodology

### Universal Review Checklist (All Agents)

| # | Check | Question |
|---|---|---|
| 1 | **Canonical compliance** | Does this contradict ARCHITECTURE.md, GAME_DESIGN.md, or any locked spec? |
| 2 | **Scope discipline** | Did the agent stay in their lane? Any unauthorized proposals? |
| 3 | **Completeness** | Does the deliverable cover everything the briefing packet asked for? |
| 4 | **Specificity** | Are outputs concrete and implementable, or vague and aspirational? |
| 5 | **Integration readiness** | Can Claude Code take this and implement without ambiguity? |
| 6 | **Format compliance** | Is the deliverable in the requested format (JSON, markdown, Swift)? |
| 7 | **Regression risk** | Could this change break something that already works? |

### Agent-Specific Review Protocols

**GPT (Narrative) — Mission Briefing Review:**
- Character voice matches established personality (compare against character doc)
- No lore contradictions with existing canon
- Briefing references correct mission type from GAME_DESIGN.md
- Correct character assigned to correct level (per level table)
- Text length fits UI constraints (Grok's HUD spec defines max text area)
- No scope creep (e.g., proposing new characters, new mission types)
- Radio chatter uses correct placeholder format for dynamic content
- Emotional arc matches level position (early = lighter, late = heavier)

**Gemini (Economy) — Balance Numbers Review:**
- Total cost vs. total earnings sanity check (spreadsheet verification)
- No upgrade costs below 0 or above reasonable ceiling
- Credit curve allows meaningful upgrade every 2-3 levels (GAME_DESIGN.md spec)
- DPS calculations verified independently (base damage × fire rate = expected DPS)
- TTK (time to kill) for each enemy type vs. each weapon at base and max upgrade
- Difficulty curve doesn't create impossible spikes or trivial valleys
- JSON schema matches Codex's ConfigDocument protocol exactly
- All WeaponIDs and EnemyIDs present (no missing entries)

**Grok (Visual) — Identity Review:**
- Color palette tested for contrast on thermal grayscale base
- HUD layout doesn't overlap with touch zones from GAME_DESIGN.md controls spec
- Asset prompts specify correct dimensions, orientation, and thermal compatibility
- Typography choices render cleanly at iPhone screen sizes in landscape
- No iOS system font assumptions (verify custom font licensing if proposed)
- Liquid Glass usage validated against iOS 26 API availability

**Codex (Utility) — Swift Code Review:**
- Compiles without warnings (not just errors)
- Conforms to ARCHITECTURE.md data flow (no SwiftUI dependencies in engine code)
- Protocol definitions don't create circular dependencies
- ConfigDocument.fallback values are sane defaults, not zeros
- SaveManager handles corruption gracefully (no force-unwraps on decode)
- All public APIs have clear intent from naming alone
- No unnecessary generics or over-abstraction

**Gemini CLI (QA) — Test Checklist Review:**
- Every test case has: ID, description, steps, expected result, pass/fail criteria
- Tests cover both "function" (does it work?) and "feel" (does it feel right?)
- Performance benchmarks specify target device, target FPS, and measurement method
- Regression tests reference specific prior phase features
- Checklists are executable by Russ (the human playtester) without QA expertise

---

## 6. Sprint Plan: Phase 0 → Phase 1 Transition

### Sprint 0A — The Decision Session

**Owner:** Russ (with Opus-prepared decision packet)  
**Duration:** ~90 minutes  
**Dependencies:** All 5 agent plans received

| Step | Decision | Materials Russ Reviews | Output |
|---|---|---|---|
| 1 | Character roles | GPT_PLAN.md §2 (Malus, AXIOM, Tee, Rusty proposals) | Accepted/modified role assignments |
| 2 | Character images | Existing image gallery (uploaded to project) | Keep/regenerate list per character |
| 3 | Narrative arc | GPT_PLAN.md §3-4 (themes, 10-level arc) | Approved arc outline |
| 4 | Economy rebalance | GEMINI_PLAN.md §2-6 (deficit analysis, fix proposals) | Approved credit curve + cost adjustments |
| 5 | Visual identity | GROK_PLAN.md §2-4 (palette, HUD, typography) | Approved color system + HUD wireframe |
| 6 | Asset manifest | ASSET_MANIFEST.md (full list) | Approved with any additions/removals |

**My deliverable for this sprint:** A single "Decision Packet" document that presents all 6 decisions with clear options, my recommendation for each, and a "sign here" approval format. Russ reviews one document, not six.

### Sprint 0B — Agent Revisions

**Owner:** All agents (parallel, no Russ needed)  
**Duration:** 1-2 sessions per agent  
**Dependencies:** Sprint 0A decisions

| Agent | Task | Deliverable |
|---|---|---|
| GPT | Revise character docs + narrative arc per Russ feedback | CHARACTER_BIBLE.md, NARRATIVE_ARC.md |
| Grok | Finalize visual identity guide per Russ feedback | VISUAL_IDENTITY.md |
| Gemini | Finalize economy JSON configs per Russ feedback | economy.json, difficulty.json |
| Codex | Finalize protocol interfaces (no Russ dependency) | EntityProtocol.swift, ConfigLoader.swift (design only) |
| Gemini CLI | Produce Phase 1 playtest checklist | PLAYTEST_P1.md |

### Sprint 0C — Final Lock

**Owner:** Russ (with Opus review summary)  
**Duration:** ~30 minutes  
**Dependencies:** Sprint 0B deliverables, Opus reviews complete

| Step | Action |
|---|---|
| 1 | Opus presents review summary of all Sprint 0B deliverables |
| 2 | Russ confirms final approvals |
| 3 | All approved deliverables promoted to `/canonical/` |
| 4 | PROJECT_PLAN.md Phase 0 checklist marked complete |
| 5 | GO.md updated to Phase 1 |
| 6 | HANDOFF.md entry: "Phase 0 complete. Phase 1 begins." |

### Sprint 0D — Phase 1 Kickoff

**Owner:** Opus + Claude Code  
**Dependencies:** Sprint 0C complete

| Step | Agent | Action |
|---|---|---|
| 1 | Opus | Create Phase 1 briefing packets for Claude Code (Sprint 1: P1-01→P1-06) |
| 2 | Opus | Create Phase 1 briefing packets for Codex (Batch 1: ConfigLoader, SaveManager, Protocols) |
| 3 | Claude Code | Create Xcode project, implement P1-01→P1-06 |
| 4 | Codex | Deliver Batch 1 utility files (design-only, reviewed before integration) |
| 5 | Russ | PLAYTEST: "Does it feel like a gunship?" |
| 6 | Opus | Phase 1 Sprint 1 gate assessment |

---

## 7. Risk Register

| # | Risk | P | I | P×I | Mitigation | Owner |
|---|---|---|---|---|---|---|
| 1 | **Russ bottleneck** — decisions queue up, project stalls | High | Critical | 🔴 | Decision packets batch approvals. Sprint 0A designed as single session. Max 2 Russ sessions per phase. | Opus |
| 2 | **Economy breaks gameplay** — credit deficit makes L6-10 frustrating | High | High | 🔴 | Gemini's rebalance addresses deficit. Validate with spreadsheet simulation before Phase 5. Playtest gate at P5 specifically checks "progression feels rewarding." | Gemini + Opus |
| 3 | **Agent drift — scope creep** — agents propose features outside their lane | Medium | High | 🟠 | Hard lane constraints in every briefing. Review checklist #2 (scope discipline). Immediate rejection + re-brief on violations. | Opus |
| 4 | **SceneKit thermal shader performance** — SCNTechnique pipeline can't hit 60fps with full post-processing | Medium | Critical | 🟠 | Phase 6 is dedicated to visual polish. Prototype thermal shader in Phase 1 as a spike (optional, non-blocking). If SceneKit can't do it, Metal fallback exists per ARCHITECTURE.md. | Claude Code |
| 5 | **Context window amnesia** — agent forgets prior session decisions, contradicts them | High | Medium | 🟠 | HANDOFF.md as persistent state. Briefing packets include relevant prior decisions. Review catches contradictions. | Opus |
| 6 | **Integration mismatch** — Gemini JSON doesn't match Codex ConfigDocument schema | Medium | High | 🟠 | Define JSON schema contract in Phase 0. Codex and Gemini both receive identical schema spec. Gemini CLI validates roundtrip. | Opus + Gemini CLI |
| 7 | **Save data corruption** — Goliath's #1 complaint, would be fatal for us | Low | Critical | 🟠 | Codex's SaveManager design includes backup + migration + write-verification. Gemini CLI tests with corrupt data. This is a launch-blocking QA gate. | Codex + Gemini CLI |
| 8 | **Narrative tone inconsistency** — GPT produces varying voice across sessions | Medium | Medium | 🟡 | CHARACTER_BIBLE.md with explicit voice samples. Every GPT session briefing includes character reference. Review checks tone consistency. | Opus + GPT |
| 9 | **Asset generation inconsistency** — AI-generated images vary wildly in style | Medium | Medium | 🟡 | Grok's VISUAL_IDENTITY.md defines strict prompt templates. All assets reviewed against reference images before integration. Batch generation preferred over one-at-a-time. | Grok + Russ |
| 10 | **Playtest gate rubber-stamping** — pressure to move forward causes soft gate passes | Low | Critical | 🟡 | Gemini CLI provides objective checklist. Gate requires Russ to physically play. "Equal or better" rule is binary — no "good enough." I advocate for the gate, not against it. | Opus + Russ |

---

## 8. Decision Packaging Strategy

### The Problem

Russ is a solo founder. Every decision he makes costs context-switch time. The worst thing I can do is send him 15 one-at-a-time Slack messages asking "what do you think about X?"

### The Solution: Decision Packets

**Structure of a Decision Packet:**

```markdown
# DECISION PACKET — [Phase] [Topic]
Date: YYYY-MM-DD
Response needed by: [date]
Estimated review time: [minutes]

## Decisions Required (N total)

### Decision 1: [Title]
Context: [2-3 sentences of why this matters]
Options:
  A) [Option] — [tradeoff]
  B) [Option] — [tradeoff]
  C) [Option] — [tradeoff]
PM Recommendation: [A/B/C] because [reason]
Your call: [ ]

### Decision 2: [Title]
...

## Quick Approvals (rubber-stamp unless you disagree)
- [x] Asset manifest includes 75 images → Approve?
- [x] Commit format follows COMMIT.md → Approve?
```

### Batching Rules

| Decision Type | Batching Strategy | Frequency |
|---|---|---|
| **Creative** (characters, narrative, visual) | Batch all creative decisions for a phase into one packet | Once per phase |
| **Technical** (architecture, data format) | Package with PM recommendation; Russ approves or overrides | As needed, max 1/week |
| **Balance** (economy, difficulty) | Present as "here are the numbers, here's what they mean for gameplay" with simulation data | Once at Phase 0, once at Phase 5 |
| **Gate** (playtest pass/fail) | Present with checklist results + Russ's own playtest experience | End of each phase |
| **Emergency** (blocking bug, architectural concern) | Escalate immediately with single clear question | Rare |

### Target: ≤2 Russ decision sessions per phase

Each session: ≤1 hour. All materials pre-prepared. All options pre-analyzed. Russ decides; he doesn't research.

---

## 9. Velocity Tracking

### What I Measure

| Metric | How Measured | Healthy | Warning | Critical |
|---|---|---|---|---|
| **Tasks completed per phase** | Count from MILESTONES.md checkboxes | On target (±1 task) | 2+ tasks behind | 3+ tasks behind or no progress in 2 sessions |
| **Russ decision latency** | Days from packet sent → response received | <2 days | 3-5 days | >5 days (project stalling) |
| **Agent revision rate** | % of deliverables requiring revision | <30% | 30-50% | >50% (briefing quality problem) |
| **Playtest gate pass rate** | First-attempt pass at phase gate | Pass | Conditional pass (minor fixes) | Fail (regression detected) |
| **Integration defect rate** | Bugs found when Claude Code integrates agent output | <2 per phase | 3-5 per phase | >5 (contract/spec problem) |
| **HANDOFF.md freshness** | Days since last update | <1 day during active dev | 2-3 days | >3 days (state is stale) |
| **Scope creep incidents** | Count of agent proposals outside their lane | 0-1 per phase | 2-3 per phase | >3 (briefing discipline failure) |

### Phase Health Dashboard (Updated Per Sprint)

```
PHASE 1 — Foundation                          Status: [ON TRACK / AT RISK / BLOCKED]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tasks:    [████████░░░░] 8/12 complete
Gate:     [ ] Not yet assessed
Blockers: None
Risks:    Thermal shader spike TBD
Next:     Sprint 3 — Reticle + HUD shell
```

### Burndown Tracking

I won't use story points — they don't mean anything here. Instead, I track **tasks completed vs. tasks remaining per phase** and **sessions elapsed vs. sessions estimated**. A "session" is one Claude Code working session (typically 1-2 hours of Russ supervision).

Estimated sessions per phase:

| Phase | Est. Sessions | Tasks |
|---|---|---|
| 1 — Foundation | 3-4 | 12 |
| 2 — Weapons | 4-5 | 12 |
| 3 — Enemies | 5-6 | 16 |
| 4 — Missions | 6-7 | 17 |
| 5 — Progression | 3-4 | 10 |
| 6 — Visual Polish | 4-5 | 12 |
| 7 — Audio | 3-4 | 10 |
| 8 — Content & Ship | 4-5 | 10 |
| **Total** | **32-40** | **99** |

---

## 10. Escalation Protocol

### Decision Authority Matrix

| Situation | Who Decides | Rationale |
|---|---|---|
| Agent output contradicts ARCHITECTURE.md | **Opus rejects** — no escalation needed | Architecture is locked. Violations are automatic rejections. |
| Agent output contradicts GAME_DESIGN.md | **Opus rejects** — no escalation needed | Game design is locked (unless Russ opens it). |
| Agent proposes a good idea outside their lane | **Opus logs it**, packages for Russ in next decision packet | Good ideas still need authorization. |
| Two agents produce conflicting outputs | **Opus resolves** by reference to canonical docs. If docs don't cover it, escalate to Russ. | PM exists to resolve conflicts. |
| Economy numbers don't add up | **Opus sends back to Gemini** with specific math errors identified | Math is verifiable; no Russ needed. |
| Narrative tone feels off | **Opus sends back to GPT** with specific character reference + examples | Tone is subjective but bounded by character bible. |
| Playtest gate is ambiguous (some items pass, some fail) | **Escalate to Russ** — he is the final playtester | "Does it feel right?" is a human judgment call. |
| Technical risk discovered (e.g., SceneKit can't do X) | **Opus + Claude Code** assess alternatives. Present options to Russ only if it requires architectural change. | Technical solutions within existing architecture are PM+Dev scope. |
| Agent repeatedly fails to produce usable output | **Opus re-briefs with simpler task decomposition.** If 3 consecutive failures, escalate to Russ to discuss replacing agent or adjusting role. | Three strikes. |
| Schedule risk — phase taking 2x estimated sessions | **Opus escalates to Russ** with: what's behind, why, and options (cut scope / add sessions / accept delay) | Russ owns schedule tradeoffs. |

### Rejection Criteria (Automatic, No Escalation)

An agent's work is **immediately rejected** if it:
- Contradicts a canonical document
- Proposes changes to locked specifications
- Includes work outside the agent's assigned scope
- Fails to meet deliverable format requirements
- Contains obviously incorrect data (math errors, wrong character names, etc.)

### Escalation Criteria (Requires Russ)

A decision is **escalated to Russ** when:
- It involves a creative judgment call not covered by existing docs
- It requires changing a locked specification
- It involves spending money (asset generation, tools, licenses)
- It affects the release timeline
- Two canonical docs appear to conflict with each other
- A playtest gate result is ambiguous

---

## 11. Cross-Agent Dependency Map (Phases 0-3)

```
PHASE 0 — Pre-Code Planning
═══════════════════════════════════════════════════════════════

 Russ ──decisions──► Opus ──briefings──► All Agents

 GPT ──character proposals───────────────────────┐
 Grok ──visual identity──────────────────────────┤
 Gemini ──economy rebalance──────────────────────┤──► Opus reviews ──► Russ approves
 Codex ──protocol designs────────────────────────┤
 Gemini CLI ──QA strategy────────────────────────┘

 Critical handoff: Russ decisions unblock ALL Phase 1 work.
 Bottleneck: RUSS (Sprint 0A)

═══════════════════════════════════════════════════════════════
PHASE 1 — Foundation
═══════════════════════════════════════════════════════════════

                    Opus
                   (briefings)
                   ╱        ╲
            Claude Code    Codex
            (P1-01→P1-12)  (ConfigLoader,
                 │          SaveManager,
                 │          Protocols)
                 │              │
                 │     ┌────────┘
                 ▼     ▼
              INTEGRATION
            (Codex utilities
           merged into project)
                 │
                 ▼
            PLAYTEST GATE
              (Russ)

 Dependencies:
   Claude Code ← needs ARCHITECTURE.md (done)
   Claude Code ← needs Codex protocols before P1-03 (GameState)
   Codex ← needs GAME_DESIGN.md weapon/enemy specs for config schemas
   Gemini CLI ← needs Phase 1 build to write meaningful playtest checklist

 Parallel work:
   GPT can pre-write Level 1 briefing (for Phase 4, but early start reduces later pressure)
   Grok can begin Level 1 background asset generation

 Bottleneck: Claude Code (sequential task chain)

═══════════════════════════════════════════════════════════════
PHASE 2 — Weapons & Impact
═══════════════════════════════════════════════════════════════

                     Opus
                    (briefings)
               ╱     │      ╲
        Claude Code  Codex   Gemini
        (P2-01→P2-12)(pool   (weapon balance
              │       utils)  validation)
              │         │         │
              ▼         ▼         ▼
         WeaponSystem  ProjectilePool  weapons.json
              │              │              │
              └──────────────┴──────────────┘
                         │
                    INTEGRATION
                         │
                    PLAYTEST GATE

 Dependencies:
   Claude Code ← needs Codex ProjectilePool protocol
   Claude Code ← needs Gemini weapons.json (loaded via ConfigLoader)
   Gemini ← needs Codex ConfigDocument schema to produce compatible JSON
   Grok ← can provide weapon effect visual specs (particle textures)

 Critical handoff: Gemini JSON → Codex schema → Claude Code integration
 Bottleneck: The Gemini↔Codex schema contract must be defined in Phase 0

═══════════════════════════════════════════════════════════════
PHASE 3 — Enemies & Combat
═══════════════════════════════════════════════════════════════

                     Opus
                    (briefings)
          ╱     │      │       ╲
   Claude Code  Codex  Gemini   Grok
   (P3-01→P3-16)(enemy (enemies (enemy visual
        │        proto) .json)   silhouettes)
        │          │      │         │
        ▼          ▼      ▼         ▼
    EnemyManager  Entity  Config   Assets/
    EnemyAI       Proto   Data     Enemies/
        │           │       │         │
        └───────────┴───────┴─────────┘
                      │
                 INTEGRATION
                      │
                 PLAYTEST GATE

 Dependencies:
   Claude Code ← needs Codex EntityProtocol + EnemyConfig schema
   Claude Code ← needs Gemini enemies.json
   Claude Code ← needs Grok enemy silhouette assets
   Gemini ← needs Codex schema
   Grok ← needs GAME_DESIGN.md enemy list (done)

 This is the HIGHEST dependency phase.
 5 agents producing interdependent output.
 Briefing packets must include explicit cross-references.

 Bottleneck: Asset generation (Grok + Russ review) may lag code
 Mitigation: Use placeholder assets; swap in finals during Phase 6
```

### Dependency Summary Table

| Producer | Consumer | What's Exchanged | When Needed |
|---|---|---|---|
| Russ | Opus | Decisions on Phase 0 blockers | Sprint 0A |
| Codex | Claude Code | EntityProtocol.swift, ConfigLoader.swift | Phase 1 start |
| Codex | Gemini | ConfigDocument JSON schema spec | Phase 0 (define schema contract) |
| Gemini | Claude Code | weapons.json, enemies.json, economy.json | Phase 2, 3, 5 |
| GPT | Claude Code | Mission briefing text, radio chatter scripts | Phase 4 |
| Grok | Claude Code | Asset images, HUD layout spec | Phase 3 (enemies), Phase 6 (polish) |
| Grok | Russ | Asset prompt templates (for generation approval) | Phase 0B |
| Gemini CLI | Opus | Playtest checklists, perf benchmarks | End of each phase |
| Opus | All agents | Briefing packets, review feedback | Start of each sprint |
| All agents | Opus | Deliverables in /active/{agent}/ | End of each task |

---

## 12. Questions for Russ

These are the things I need from you to be effective as PM. Answering these in Sprint 0A would unblock almost everything.

### Blocking Questions (Need Before Phase 1)

| # | Question | Why It Matters |
|---|---|---|
| 1 | **Character roles for Malus, AXIOM, Tee, Rusty** — GPT has proposals. Accept, modify, or reject? | Blocks narrative arc, briefing scripts, character bible |
| 2 | **Existing character images** — Can I see them? Which do you want to keep vs. regenerate? | Blocks asset manifest finalization |
| 3 | **Economy rebalance** — Gemini found a 26K credit deficit. Accept their proposed fix (scaling rewards, first-clear bonus, cost reduction)? | Blocks economy JSON generation |
| 4 | **Narrative arc** — GPT proposed escalation from street thugs → PMCs → AI warfare. Approve the arc? | Blocks mission briefing writing |
| 5 | **Visual identity** — Grok proposed FLIR grayscale + cyan HUD + neon accents. Approve the palette? | Blocks asset generation prompts |
| 6 | **Asset manifest** — ~75 images. Approve the list? Any additions/removals? | Blocks priority batching for generation |

### Non-Blocking Questions (Can Answer Anytime)

| # | Question | Context |
|---|---|---|
| 7 | **Budget for asset generation tools?** | Determines whether we use FLUX, Midjourney, DALL-E, or a mix |
| 8 | **Target launch timeline?** | Helps me set sprint cadence and escalation urgency |
| 9 | **Playtesting hardware** — What iPhone model(s) will you test on? | Affects performance targets and Gemini CLI's benchmark specs |
| 10 | **Post-v1 plans** — Survival mode? New Game+? | Gemini flagged short playtime risk. Knowing post-launch plans helps me scope v1 appropriately |
| 11 | **CI/CD preference** — Xcode Cloud, manual builds, or GitHub Actions? | Affects how we integrate automated validation |
| 12 | **How many hours per week can you dedicate to this project?** | The single most important planning input. Every estimate depends on this. |

### Standing Request

I'd like a standing rule: **If I send you a Decision Packet, you have 48 hours to respond before I follow my own recommendation and proceed.** This prevents the project from stalling on approvals while respecting your time. You can always override later, but momentum > perfection.

---

## Summary

This project has every advantage v1 lacked: comprehensive planning docs, locked architecture, clear phase gates, and a team of specialized agents ready to execute. What it needs now is someone to orchestrate execution with discipline.

My job is to:
1. **Keep agents in their lanes** with scoped briefing packets
2. **Catch contradictions early** through systematic review
3. **Minimize your context-switching** through batched decision packets
4. **Defend the playtest gates** as sacred checkpoints
5. **Maintain HANDOFF.md** as the single source of cross-agent truth
6. **Track velocity** and escalate early when things slip

The critical path right now is Sprint 0A — your decision session. Everything else is ready. The agents have delivered their plans. The documentation suite is solid. The architecture is locked.

We need your decisions to start building.

---

*Submitted for review by Claude Opus 4.6*  
*Candidate: Project Manager — WarSignal AirAssault*