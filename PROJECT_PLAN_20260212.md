# PROJECT_PLAN — WarSignal AirAssault v2
**Date:** 2026-02-12
**Author:** Claude Opus 4.6 (Project Manager — WarSignal)
**Status:** APPROVED — Decisions Locked

---

## Executive Summary

I have ingested and cross-referenced 14 documents: the 4 core project docs (CLAUDE.md, CONTEXT.md, AGENTS.md, CLAUDE_SKILL.md), 2 competitive intelligence reports (Gemini_research.md, Claude_Research.md), the current PROJECT_STATUS.md, and 6 agent interview plans (GPT, Codex, Gemini, Gemini CLI, Grok, Claude Opus).

**The headline:** WarSignal v1 has a working vertical slice (Milestones 0-2 complete, Milestone 3 in progress) built on RealityKit + SwiftUI. The six agent candidates have collectively produced a mature, interlocking plan for a v2 reboot under a structured multi-agent workflow. The plans are strong. The gap between "what exists" and "what's proposed" requires reconciliation.

This report covers: (1) state of play, (2) competitive intelligence summary, (3) agent-by-agent assessment, (4) cross-agent conflicts and gaps, (5) critical decisions needed, and (6) recommended path forward.

---

## 1. State of Play: What Exists Today

### Codebase (v1)

WarSignal v1 is a RealityKit + SwiftUI project targeting iOS 26 in landscape-only. Three milestones are complete or in progress:

| Milestone | Status | Key Deliverables |
|-----------|--------|-----------------|
| **M0 — Initialization** | COMPLETE | Docs, repo, architecture locked |
| **M1 — Vertical Slice** | COMPLETE | SwiftUI shell, RealityView, GameCoordinator, camera with 3 zoom levels, touch aiming + Goliath-style reticle, autocannon with projectile pooling, enemy targets with health/damage, AVAudioEngine audio system |
| **M2 — Combat Loop** | COMPLETE | HUD polish with liquid glass, ship shield system with regen, rocket weapon with splash, infantry enemy with movement AI, drone enemy with erratic flight |
| **M3 — Mission Structure** | IN PROGRESS | Goliath-style reticle implemented. Core issues identified from playtesting (no AC-130 drift, enemies instant-kill, placeholder graphics, no weapon switching, reticle visibility) |

**What works:** The project builds and runs on iPhone 17 Pro Max Simulator. Core combat loop exists — fire weapons, hit enemies, take damage, shields regenerate. Audio plays. HUD renders with liquid glass.

**What doesn't work (identified issues):**
1. No AC-130 orbital drift feel (camera is static)
2. Enemy spawn at bottom = instant death, no counterplay
3. Placeholder box/dot graphics
4. Can't switch weapons during gameplay
5. Reticle not always visible
6. RealityKit suitability questioned for thermal/FLIR rendering

### Documentation Suite

Solid foundation. CLAUDE.md, CONTEXT.md, AGENTS.md all consistent. The CLAUDE_SKILL.md is a "god-tier SwiftUI technical director" skill that enforces production-grade discipline — stability, predictability, performance, scalability. This is the quality bar.

### Critical Architecture Decision: RealityKit

The engine choice is **locked** per CLAUDE.md. RealityKit was chosen for modern Apple integration, physics, and ECS alignment. However, every agent candidate plan was written against **SceneKit** (Codex, Gemini CLI, Grok all reference SCNNode, SCNScene, SCNTechnique). This is the single largest alignment gap.

---

## 2. Competitive Intelligence: What We Learned About Goliath

Two exhaustive research reports were produced. Key takeaways for WarSignal:

### Developer Profile (SHD Games / Simon Hason)
- **Solo Canadian indie**, micro-studio (1-5 people), incorporated 2017
- Built on **Unity**, transitioned from Flash-era games
- 40M+ cumulative installs across portfolio
- Self-published, no-forced-ads philosophy, $9.99 Premium IAP
- "Hollywood model" — small core + contractor network

### Goliath Product Intelligence
- **4.7 stars / 30K+ iOS ratings** — market validates the niche
- Portrait orientation, tap-to-target, FLIR thermal camera view
- Core loop: orbit battlefield → drop ordnance → earn credits → upgrade weapons
- Deep progression: Prestige I-VIII+, Ultimate Weapons, Augments, Live Ops
- **Critical weakness: save-data corruption** — the #1 community complaint
- **Android significantly worse** than iOS (3.1 vs 4.7 rating)
- Monetization: fuel/energy system, optional ads, gem/credit dual currency
- No forced ads, praised community — but Red Diamonds scarcity frustrates F2P players

### Strategic Implications for WarSignal
1. **The niche is real and underserved** — 30K+ ratings at 4.7 stars with a solo dev proves demand
2. **Thermal/FLIR aesthetic is table stakes** — Goliath's visual identity is the genre standard
3. **Save integrity is existential** — Goliath's #1 pain point. We cannot repeat this.
4. **Premium positioning is viable** — Goliath's most-praised feature is "no forced ads." A premium $4.99-$9.99 game with no energy timers has clear market positioning.
5. **Narrative is the differentiator** — Goliath has zero story, zero characters, zero emotional stakes. This is WarSignal's unique edge.
6. **Portrait vs. Landscape** — Goliath is portrait (one-hand play). WarSignal is landscape (gunship immersion). This is a deliberate trade-off favoring immersion over convenience.

---

## 3. Agent-by-Agent Assessment

### GPT — Narrative Designer
**Role:** Mission briefings, radio chatter, character arcs, emotional stakes

**Strengths:**
- Correctly identifies that narrative is WarSignal's competitive advantage over Goliath
- "Gameplay amplifier, not a separate system" — exactly right
- Character proposals for Malus (internal antagonist), AXIOM (corporate AI), Tee (logistics/analyst), Rusty (field engineer) are thematically strong
- Radio chatter taxonomy (trigger-based, priority-based) shows understanding of real-time constraints
- 5-phase delivery mapped to development milestones
- Sample briefing and chatter demonstrate the right tone: terse, military, human

**Concerns:**
- References "WarSignal AirAssault" and "the Wraith" — names not established in current docs
- Proposes 10-level arc but current CONTEXT.md doesn't specify level count
- No mention of how narrative integrates with RealityKit's rendering pipeline
- Sample content quality is high but untested against HUD text box constraints

**Verdict:** Strong hire. Needs lane constraints and integration specs.

---

### Codex — Utility Infrastructure Engineer
**Role:** ConfigLoader, SaveManager, entity protocols, object pooling, debug utilities

**Strengths:**
- Defensive-first philosophy: strict decode + validation, safe fallbacks, versioned migrations
- SaveManager with backup-before-write, migration pipeline, corruption recovery — directly addresses Goliath's #1 weakness
- ConfigLoader with generic validation, typed fallbacks, structured logging
- Entity protocols (Updatable, Damageable, Poolable) with clean composition
- JSON config schemas for weapons and enemies are well-structured
- Clear error handling philosophy: never crash, always log, always fallback
- Delivery batched to project phases

**Concerns:**
- **All code references SceneKit** (SCNNode, SCNScene, SCNVector3) — project uses RealityKit
- Object pool design uses `SCNNode.isHidden`, `SCNNode.isPaused`, `SCNNode.physicsBody` — all SceneKit APIs
- `SaveDataV1` references `levelStars` with `[Int: Int]` which doesn't match current CONTEXT.md progression design
- Codex proposed `SceneNodePool` but project already has `ProjectilePool.swift` built for RealityKit entities

**Verdict:** Strongest infrastructure thinking of any candidate. Must be re-briefed for RealityKit API surface. The SaveManager and ConfigLoader designs are production-ready concepts that translate cleanly.

---

### Gemini — Economy & Analytics Designer
**Role:** Economy balance, progression math, difficulty curves, star ratings

**Strengths:**
- Immediately identifies the core problem: premium vs F2P economy design
- Quantitative analysis: calculated 39,800 total upgrade cost vs ~13,500 total campaign income = 26,300 credit deficit
- DPS/TTK matrix with concrete numbers (Vulcan 120 DPS, Havoc 33.3 DPS, Reaper 40 DPS)
- Identifies "The Reaper Breakpoint" — upgrading Reaper to 1-shot tanks is the key power fantasy moment
- Difficulty curve segmented by density/complexity, not HP scaling — correct approach
- Star-rating framework (Survivor/Operator/Ace) with reward multipliers
- Competitive positioning analysis is sharp: "WarSignal = premium tactical, Goliath = arcade grinder"
- Concrete fix proposals: triple base rewards, first-clear bonus, reduce utility costs

**Concerns:**
- References SceneKit ("Can SceneKit handle 60+ active entities with physics?")
- Weapon names (Vulcan, Havoc, Reaper) don't match current codebase (Autocannon, Rocket, Heavy Gun)
- Economy model assumes 10 levels — this count isn't locked in current docs
- No integration with Codex's ConfigLoader schema — these must align
- TTK matrix assumes specific base damage values that need PM approval

**Verdict:** Exceptional analytical work. The economy math is the most immediately actionable deliverable of any candidate. Weapon naming and level count need alignment with canonical docs.

---

### Grok — Art Director / Visual Identity
**Role:** Color palette, typography, HUD design, asset prompts, audio direction

**Strengths:**
- Deep understanding of the visual challenge: "authentic FLIR thermal + Sin City cyberpunk noir"
- 6-stop thermal ramp (not just black/white — intermediate grays for terrain, vehicles, structures)
- HUD accent colors with clear state mapping (cyan default, red hostile, yellow danger-close)
- Typography hierarchy is production-quality: OCR-A for data, DIN Condensed for labels, Rajdhani for headers, Courier New for briefings
- HUD design as "physical aircraft glass" not "mobile game overlay" — correct philosophy
- Asset prompt templates are precise and repeatable (dimensions, style tags, consistency tags)
- Audio direction with BPM ranges per game state — actionable for music production
- Weapon sound descriptions match the feel targets

**Concerns:**
- References `SCNTechnique` for thermal shader — project uses RealityKit
- Liquid Glass specs (`.glassEffect(thickness: 0.6, blur: 14)`) need validation against actual iOS 26 API
- Color palette assumes "enhanced view" mode with full neon — this view mode isn't in current CONTEXT.md
- 75-asset manifest is ambitious for AI generation without significant human review
- Font licensing: OCR-A requires bundling, DIN Condensed and Rajdhani need license verification

**Verdict:** The most complete visual identity proposal. Translates directly to implementation specs. SceneKit references need correction. Enhanced view mode needs PM decision.

---

### Gemini CLI — QA & Technical Analyst
**Role:** Test plans, performance benchmarks, architecture validation, integration testing

**Strengths:**
- Correctly identifies the core QA challenge: "integration, not implementation" in a multi-agent workflow
- Phase 1 playtest checklist is immediately executable (28 specific test cases with steps and expected results)
- Performance testing approach with baselines, stress scenarios, and regression thresholds
- Architecture violation detection table with concrete anti-patterns and corrections
- Edge case catalog (15 specific scenarios) covers real failure modes: pool exhaustion, simultaneous hits, save corruption, input conflicts
- Integration validation approach per agent is methodical
- "Trust, but Verify, with Data" — correct philosophy

**Concerns:**
- References SceneKit throughout (SCNScene, SCNView, SCNTechnique)
- Architecture violation examples show SwiftUI→SceneKit patterns, not SwiftUI→RealityKit
- Some test cases assume SceneKit debug options that don't exist in RealityKit
- Edge case #6 (saving mid-explosion) assumes in-mission save — current design only saves between missions
- No mention of RealityKit-specific testing challenges (Entity lifecycle, Component validation)

**Verdict:** Best QA methodology of any candidate. Test case format and integration approach are immediately adoptable. Needs complete RealityKit re-briefing.

---

### Claude Opus — Project Manager Candidate
**Role:** Orchestration, briefing packets, review methodology, velocity tracking, decision packaging

**Strengths:**
- **Identifies the real problem:** "distributed system of stateless agents coordinating through documents" — this is the most accurate framing of the project challenge
- Failure mode analysis (8 specific modes with evidence from v1) is incisive
- Hub-and-spoke communication architecture with explicit data flow
- Briefing packet methodology with minimum information set — directly addresses agent amnesia
- Review methodology with universal + agent-specific checklists
- Sprint plan (0A→0B→0C→0D) minimizes Russ's decision surface to 2 focused sessions
- Decision packaging strategy ("Russ decides; he doesn't research") respects the single-founder constraint
- Risk register with probability × impact scoring
- Velocity tracking with concrete metrics and health dashboard
- Escalation protocol with clear authority matrix
- Cross-agent dependency map for Phases 0-3 is the most useful coordination artifact

**Concerns:**
- References SceneKit throughout (SCNScene, Metal fallback, SCNTechnique)
- Assumes "v2 reboot" from scratch — but v1 already has 3 milestones of working RealityKit code
- Task count (99 tasks, 8 phases, 32-40 sessions) based on clean-room build, not incremental build on v1
- References documents that don't exist yet: GAME_DESIGN.md, ARCHITECTURE.md, MILESTONES.md, ASSET_MANIFEST.md, HANDOFF.md
- Proposes /active/{agent}/ and /canonical/ folder structure not in current repo
- Session estimates assume SceneKit, not RealityKit (RealityKit may be faster or slower depending on system)

**Verdict:** The most comprehensive and operationally mature plan. The orchestration methodology is exactly what this project needs. Requires reconciliation with the existing v1 codebase and RealityKit reality.

---

## 4. Cross-Agent Conflicts and Gaps

### CRITICAL: SceneKit vs. RealityKit Misalignment

**Every agent plan was written against SceneKit.** The existing codebase uses RealityKit. This is not a minor terminology issue — it affects:
- Object pooling patterns (SCNNode vs Entity)
- Physics APIs (SCNPhysicsBody vs PhysicsBodyComponent)
- Rendering pipeline (SCNTechnique for thermal shader vs RealityKit post-processing)
- Scene composition (SCNScene.rootNode vs RealityKit Entity hierarchy)
- Debug overlays (SCNView.showsStatistics vs custom RealityKit debug)

**Resolution:** All agent briefing packets must be re-issued with RealityKit API context. The existing v1 codebase has working patterns for all of these.

### Weapon Naming Inconsistency

| Current Codebase | Gemini Economy | Codex Config | Grok Visual |
|-----------------|---------------|-------------|-------------|
| Autocannon | Vulcan 20mm | Vulcan | "Vulcan" |
| Rocket | HAVOC Rockets | Havoc | "Havoc" |
| Heavy Gun | Reaper | — | "Reaper" |

**Resolution:** Lock weapon names in CONTEXT.md. Recommendation: adopt Gemini's names (Vulcan, Havoc, Reaper) — they're more evocative and match the cyberpunk tone.

### Level Count Not Locked

Gemini and GPT both assume 10 levels. Claude Opus builds a 10-level economy and narrative arc. Current CONTEXT.md does not specify level count.

**Resolution:** Russ must decide. 10 levels is reasonable for a premium mobile game at $4.99-$9.99.

### v1 vs. v2: Build On or Start Over?

Claude Opus's plan assumes a clean-room "v2" build. But v1 has 3 milestones of working RealityKit code including:
- GameCoordinator with @Observable state bridge
- RealityView with full-screen rendering
- Camera system with zoom
- Goliath-style reticle with L-brackets, compass markers
- Autocannon with projectile pooling (60 pool)
- Rocket weapon with splash damage
- 3 enemy types (basic target, infantry, drone)
- Shield system with regeneration
- HUD with liquid glass
- Audio system with AVAudioEngine

**Resolution:** This is the most important strategic decision. Options:
- **A) Evolve v1** — Refactor existing code to match the new team structure. Faster to first playtest, but carries v1 technical debt.
- **B) Clean-room v2** — Start fresh with full planning suite. Better architecture from day one, but discards 3 milestones of work and validated RealityKit patterns.
- **C) Hybrid** — Extract validated patterns and utilities from v1 (pooling, audio, camera) into the new project structure. Best of both worlds but requires careful extraction.

**Recommendation:** Option C (Hybrid). The v1 code has proven that RealityKit works for this game. The patterns (projectile pooling, camera control, entity management) are validated. The agent team's plans add structure, economy, narrative, and visual identity that v1 lacks. Extract the working systems, wrap them in the new architecture.

### Economy Model vs. F2P vs. Premium

Gemini's plan is built for premium ($4.99-$9.99, finite economy, no energy timers). Goliath's research shows F2P with fuel timers and multi-currency. Current CONTEXT.md says "No online services in v1" but doesn't specify monetization model.

**Resolution:** Russ must decide monetization strategy. Gemini's premium positioning analysis is compelling — it's the clearest market differentiation from Goliath.

### Thermal/FLIR Rendering on RealityKit

Grok's visual identity hinges on a thermal FLIR camera effect. Goliath's entire visual identity is this monochrome view. All agent plans reference SCNTechnique for this — which doesn't exist in RealityKit.

**Options:**
1. RealityKit custom materials with ShaderGraphMaterial (iOS 17+)
2. RealityKit post-processing via custom render passes (limited API)
3. Metal compute shader as overlay
4. SwiftUI-level color filter (simplest but least authentic)

**Resolution:** Needs a technical spike. This is the highest-risk visual feature.

---

## 5. Locked Decisions (Approved 2026-02-12)

All decisions approved by Russ Meadows. These are now canonical.

### Decision 1: Hybrid Build — LOCKED
**Choice:** C — Hybrid. Extract validated v1 RealityKit patterns (pooling, camera, audio, reticle, shields) into the new structured architecture. Do not discard working code. Do not start from scratch.

### Decision 2: Premium Monetization — LOCKED
**Choice:** A — Premium **$4.99 launch price**. No IAP, no ads, no energy timers, no dual currency. Single-currency finite economy. Strongest differentiation from Goliath's F2P model. "No BS" marketing. Tier to $6.99 post-1.0 if reviews hit 4.7+.

### Decision 3: 10 Levels — LOCKED
**Choice:** A — 10 levels. 2-4 hour campaign. Matches Gemini's economy math, GPT's narrative arc, and premium price justification.

### Decision 4: Weapon Names — LOCKED
**Choice:** B — Adopt Gemini names.
| Slot | Old Name | New Name | Identity |
|------|----------|----------|----------|
| Primary | Autocannon | **Vulcan** | 20mm rapid-fire gatling |
| Secondary | Rocket | **Havoc** | Guided rockets, splash damage |
| Heavy | Heavy Gun | **Reaper** | Heavy ordnance, max single-target |
| Unlock | EMP/Smart Bomb | **TBD** | Area-denial, endgame unlock |

### Decision 5: Character Roles — LOCKED
| Character | Role | Narrative Function |
|-----------|------|--------------------|
| **Malus** | Internal antagonist / fallen GridWatch | Mid-campaign reveal, explains enemy intelligence |
| **AXIOM** | Corporate command AI | Cold logical counterpoint, philosophical antagonist |
| **Tee** | Logistics / overwatch analyst | Non-combat voice, emotional decompression |
| **Rusty** | Field engineer | Gallows humor, grounded perspective |

### Decision 6: Visual Identity — ACCEPTED (conditional)
Grok's FLIR thermal grayscale + cyan HUD + neon accents approved. Thermal shader feasibility on RealityKit requires technical spike in Phase 1.

### Decision 8: Price Point — LOCKED (2026-02-12)
**Choice:** $4.99 launch price. Both Gemini and Grok economy analyses converge on this. Tier to $6.99 post-launch if reviews hit 4.7+ stars.

### Decision 9: Unlock Target — LOCKED (2026-02-12)
**Choice:** 90% tech tree on skilled first playthrough. Remaining 10% (elite upgrades) via NG+ star earnings. Generous but not exhaustive. Grok's recommendation adopted over Gemini's original 85%.

### Decision 10: No Respec in v1 — LOCKED (2026-02-12)
**Choice:** No respec mechanic. Economy is generous enough (90% unlock) that bad upgrade paths are uncomfortable but not fatal. Respec is a v1.1 candidate if playtest feedback demands it. Keeps save state simple for Codex's SaveManager.

### Decision 11: S-Curve Cost Model — LOCKED (2026-02-12)
**Choice:** S-curve upgrade costs adopted. Cheap early tiers (flow/accessibility), expensive late tiers (mastery/prestige choices). Applies to all 45+ upgrade paths. Example: Vulcan Damage — T1: 400, T2: 600, T3: 900, T4: 1,200, T5: 1,500.

### Decision 7: Full Agent Team — HIRED
| Agent | Role | Status |
|-------|------|--------|
| **Claude Opus** | Project Manager / Orchestrator | HIRED |
| **Claude Code** | Lead Developer (all production Swift) | HIRED (existing) |
| **GPT** | Narrative Designer | HIRED |
| **Codex** | Utility Infrastructure Engineer | HIRED — re-brief for RealityKit |
| **Gemini** | Economy & Balance Designer | HIRED |
| **Grok** | Art Director / Visual Identity | HIRED — re-brief for RealityKit |
| **Gemini CLI** | QA & Technical Analyst | HIRED — re-brief for RealityKit |

---

## 6. Phase/Sprint Workflow with Agent Roles

### Legend

| Symbol | Meaning |
|--------|---------|
| **LEAD** | Primary owner, produces the deliverable |
| **SUPPORT** | Provides input, reviews, or dependencies |
| **GATE** | Must sign off before phase advances |
| **IDLE** | No tasks this phase |

---

### Phase 0 — Alignment & Lock (CURRENT)

**Goal:** Lock all canonical docs, re-brief agents for RealityKit, extract v1 patterns.

| Sprint | Task | Owner | Support | Gate |
|--------|------|-------|---------|------|
| 0A | Decisions session (DONE) | Russ | Opus | Russ |
| 0B | RealityKit re-briefing packet | **Opus** | Claude Code (v1 patterns) | — |
| 0B | Update CONTEXT.md + create GAME_DESIGN.md | **Opus** | Gemini (economy data) | Russ |
| 0B | v1 code audit — tag what carries forward | **Claude Code** | Opus | — |
| 0B | Revised ConfigLoader/SaveManager design (RealityKit) | **Codex** | Claude Code (API surface) | Opus |
| 0B | Phase 1 playtest checklist (RealityKit) | **Gemini CLI** | Claude Code (test points) | Opus |
| 0C | Final doc review + Phase 0 sign-off | **Opus** | All agents | Russ |

```
PHASE 0 AGENT MAP
═══════════════════════════════
 Russ ──decisions──► Opus ──re-briefings──► All Agents
                       │
         ┌─────────────┼─────────────┐
         ▼             ▼             ▼
    Claude Code     Codex      Gemini CLI
    (v1 audit)    (infra       (QA plan
                  redesign)    update)
         │             │             │
         └─────────────┼─────────────┘
                       ▼
                   PHASE 0 GATE
                    (Russ + Opus)
```

---

### Phase 1 — Foundation (Hybrid Build)

**Goal:** Project structure, migrated v1 systems, core infrastructure, orbital camera.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 1.1 | Xcode project setup + folder structure | **Claude Code** | Opus (architecture spec) | Building project |
| 1.1 | Migrate v1 camera + zoom system | **Claude Code** | — | OrbitalCamera with AC-130 drift |
| 1.1 | Migrate v1 reticle system | **Claude Code** | Grok (visual spec) | Goliath-style reticle |
| 1.2 | ConfigLoader + GameConstants | **Codex** → **Claude Code** integrates | Opus (review) | Config pipeline |
| 1.2 | SaveManager with backup + migration | **Codex** → **Claude Code** integrates | Opus (review) | Save pipeline |
| 1.2 | Ground plane + basic scene | **Claude Code** | Grok (terrain spec) | Renderable scene |
| 1.3 | Thermal/FLIR shader spike | **Claude Code** | Grok (color ramp spec) | Feasibility report |
| 1.3 | HUD shell (SwiftUI + Liquid Glass) | **Claude Code** | Grok (HUD layout spec) | Functional HUD |
| 1.3 | Input system (touch aiming + gestures) | **Claude Code** | — | Responsive controls |
| GATE | Phase 1 playtest | **Gemini CLI** (checklist) | Russ (plays) | Go / No-Go |

```
PHASE 1 AGENT MAP
═══════════════════════════════
         Opus (briefings + review)
        ╱          │          ╲
  Claude Code    Codex        Grok
  (all code)   (ConfigLoader, (visual specs,
       │        SaveManager)   HUD layout)
       │            │              │
       ◄────────────┘              │
       ◄───────────────────────────┘
       │
  Gemini CLI (QA gate)
       │
   PLAYTEST GATE (Russ)

 GPT = IDLE (pre-writing Level 1 briefing for Phase 4)
 Gemini = IDLE (economy locked, available for balance queries)
```

---

### Phase 2 — Weapons & Impact

**Goal:** All 3 weapons functional, projectile pooling, weapon switching, hit feedback.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 2.1 | Weapon config JSON (Vulcan/Havoc/Reaper) | **Gemini** (numbers) → **Codex** (schema) | Opus (review) | weapons.json |
| 2.1 | Migrate v1 Vulcan + projectile pool | **Claude Code** | — | Vulcan fires |
| 2.2 | Havoc rockets with splash damage | **Claude Code** | Gemini (balance data) | Havoc fires |
| 2.2 | Reaper heavy ordnance | **Claude Code** | Gemini (balance data) | Reaper fires |
| 2.3 | Weapon switching UI (ALPHA/BRAVO/HEAVY) | **Claude Code** | Grok (selector spec) | 3-weapon HUD |
| 2.3 | Muzzle flash + tracers + impact FX | **Claude Code** | Grok (effect spec) | Visual feedback |
| 2.3 | Camera shake per weapon | **Claude Code** | — | Feel tuning |
| 2.3 | Weapon audio integration | **Claude Code** | Grok (audio direction) | Sound per weapon |
| GATE | Phase 2 playtest | **Gemini CLI** | Russ | Go / No-Go |

```
PHASE 2 AGENT MAP
═══════════════════════════════
       Opus (briefings + review)
      ╱     │       │       ╲
Claude    Codex   Gemini    Grok
Code     (schema) (balance) (FX specs,
  │         │        │      audio dir)
  ◄─────────┴────────┴────────┘
  │
  Gemini CLI (QA gate)
  │
  PLAYTEST GATE (Russ)

 GPT = SUPPORT (weapon flavor text, kill confirm chatter samples)
```

---

### Phase 3 — Enemies & Combat

**Goal:** All enemy types, AI behaviors, spawn system, damage model, combat loop complete.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 3.1 | Enemy config JSON (11 types + behaviors) | **Gemini** → **Codex** (schema) | Opus | enemies.json |
| 3.1 | Enemy silhouette assets (11) | **Grok** (prompts) → **Russ** (generation) | — | Asset files |
| 3.1 | Infantry AI (pathfinding, seek objective) | **Claude Code** | Gemini (HP/speed data) | Infantry works |
| 3.2 | Drone AI (erratic flight, player attack) | **Claude Code** | — | Drones work |
| 3.2 | Vehicle AI (armored, slow, high HP) | **Claude Code** | Gemini (armor values) | Vehicles work |
| 3.2 | Turret AI (stationary, player-targeting) | **Claude Code** | — | Turrets work |
| 3.3 | Wave spawner system | **Claude Code** | Gemini (wave composition) | Spawn system |
| 3.3 | Splash damage + AoE falloff | **Claude Code** | Gemini (radius data) | Damage model |
| 3.3 | Boss unit (scripted multi-phase) | **Claude Code** | GPT (boss identity) | Boss prototype |
| GATE | Phase 3 playtest | **Gemini CLI** | Russ | Go / No-Go |

```
PHASE 3 AGENT MAP — HIGHEST DEPENDENCY PHASE
═══════════════════════════════════════════════
            Opus (briefings + review)
       ╱      │        │       │       ╲
 Claude     Codex    Gemini   Grok     GPT
 Code      (entity  (enemy   (enemy  (boss
  │        schema)  balance) assets) identity)
  │           │        │       │       │
  ◄───────────┴────────┴───────┴───────┘
  │
  Gemini CLI (QA gate)
  │
  PLAYTEST GATE (Russ)
```

---

### Phase 4 — Missions & Narrative

**Goal:** 10 mission definitions, briefing system, radio chatter, objectives, mission flow.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 4.1 | 10 level definitions (objectives, waves) | **Gemini** (difficulty) + **GPT** (narrative) | Opus | Level configs |
| 4.1 | Mission briefing UI | **Claude Code** | Grok (briefing panel spec) | Briefing screen |
| 4.2 | Mission select screen | **Claude Code** | Grok (UI spec) | Selection flow |
| 4.2 | 10 mission briefings + radio chatter scripts | **GPT** | Opus (tone review) | Narrative text |
| 4.3 | Objective system (defend, destroy, survive, boss) | **Claude Code** | Gemini (objective params) | Objective HUD |
| 4.3 | Mission complete/fail flow | **Claude Code** | GPT (debrief text) | End screens |
| 4.3 | Wave spawner integration per level | **Claude Code** | Gemini (wave data) | 10 playable levels |
| 4.3 | Radio chatter trigger system | **Claude Code** | GPT (chatter scripts) | In-game dialogue |
| GATE | Phase 4 playtest (full campaign flow) | **Gemini CLI** | Russ | Go / No-Go |

```
PHASE 4 AGENT MAP — NARRATIVE-HEAVY
═══════════════════════════════════════
          Opus (briefings + review)
      ╱      │       │       ╲
Claude     GPT    Gemini    Grok
Code     (narrative)(levels)(UI specs)
  │         │        │        │
  ◄─────────┴────────┴────────┘
  │
  Gemini CLI (QA gate)
  │
  PLAYTEST GATE (Russ)

 Codex = SUPPORT (config schema validation)
```

---

### Phase 5 — Progression & Economy

**Goal:** Credits, upgrades, save/load, star ratings, hangar/upgrade screen.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 5.1 | Economy JSON (costs, rewards, curves) | **Gemini** | Codex (schema) | economy.json |
| 5.1 | Credit earn/spend system | **Claude Code** | Gemini (numbers) | Currency works |
| 5.2 | Weapon upgrade system (3 tiers per weapon) | **Claude Code** | Gemini (tier data) | Upgrades work |
| 5.2 | Ship defense upgrades (hull, flares, ECM) | **Claude Code** | Gemini (tier data) | Defense upgrades |
| 5.2 | Ground team upgrades | **Claude Code** | Gemini (tier data) | Squad upgrades |
| 5.3 | Star rating system (Survivor/Operator/Ace) | **Claude Code** | Gemini (criteria) | Post-mission stars |
| 5.3 | Hangar/upgrade screen UI | **Claude Code** | Grok (UI spec) | Upgrade flow |
| 5.3 | Save/Load integration | **Claude Code** | Codex (SaveManager) | Persistence works |
| 5.3 | First-clear bonus + reward feedback | **Claude Code** | Gemini (bonus values) | Reward feel |
| GATE | Phase 5 playtest ("progression feels rewarding") | **Gemini CLI** | Russ | Go / No-Go |

```
PHASE 5 AGENT MAP — ECONOMY-HEAVY
═══════════════════════════════════
          Opus (briefings + review)
      ╱      │        │       ╲
Claude    Codex    Gemini    Grok
Code    (Save     (all     (upgrade
  │      Manager)  numbers)  UI spec)
  ◄────────┴────────┴────────┘
  │
  Gemini CLI (QA gate — economy simulation)
  │
  PLAYTEST GATE (Russ)

 GPT = IDLE (available for flavor text on upgrades)
```

---

### Phase 6 — Visual Polish

**Goal:** Thermal shader, asset integration, particle effects, level backgrounds, character portraits.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 6.1 | Thermal/FLIR shader implementation | **Claude Code** | Grok (color ramp) | Thermal view |
| 6.1 | Level background assets (10) | **Grok** (prompts) → **Russ** (generation) | — | Level art |
| 6.2 | Enemy visual upgrades (silhouettes→models) | **Claude Code** | Grok (asset specs) | Better enemies |
| 6.2 | Character portraits (12) | **Grok** (prompts) → **Russ** (generation) | — | Portrait art |
| 6.3 | Explosion + tracer + muzzle FX polish | **Claude Code** | Grok (FX spec) | Polished effects |
| 6.3 | HUD visual polish pass | **Claude Code** | Grok (final HUD spec) | Polished HUD |
| GATE | Phase 6 playtest ("looks like the game we pitched") | **Gemini CLI** | Russ | Go / No-Go |

```
PHASE 6 AGENT MAP — ART-HEAVY
═══════════════════════════════
          Opus (briefings + review)
      ╱      │        ╲
Claude      Grok     Russ
Code      (all art   (asset
  │       direction)  generation
  ◄────────┘          + review)
  │
  Gemini CLI (QA gate)
  │
  PLAYTEST GATE (Russ)

 Gemini = SUPPORT (balance validation with new visuals)
 Codex = IDLE
 GPT = IDLE
```

---

### Phase 7 — Audio & Feel

**Goal:** Full audio implementation, music, SFX polish, camera feel, juice pass.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 7.1 | Weapon SFX (Vulcan/Havoc/Reaper distinct sounds) | **Claude Code** | Grok (audio direction) | Weapon audio |
| 7.1 | Explosion + impact SFX | **Claude Code** | Grok (audio direction) | Impact audio |
| 7.2 | Ambient loops per level | **Claude Code** | Grok (BPM/mood specs) | Level ambience |
| 7.2 | Music integration (menu, combat, victory, defeat) | **Claude Code** | Grok (music direction) | Full soundtrack |
| 7.3 | Audio ducking + mix rules | **Claude Code** | — | Clean audio mix |
| 7.3 | Camera juice pass (shake tuning, zoom feel) | **Claude Code** | — | Better feel |
| 7.3 | Hit feedback polish (screen flash, UI pulse) | **Claude Code** | Grok (feedback spec) | Satisfying hits |
| GATE | Phase 7 playtest ("feels and sounds like a gunship") | **Gemini CLI** | Russ | Go / No-Go |

```
PHASE 7 AGENT MAP
═══════════════════════════════
          Opus (review)
      ╱      │
Claude      Grok
Code      (audio +
  │       feel specs)
  ◄────────┘
  │
  Gemini CLI (QA gate)
  │
  PLAYTEST GATE (Russ)
```

---

### Phase 8 — Content, QA & Ship

**Goal:** All 10 levels populated, full QA pass, App Store submission prep, ship.

| Sprint | Task | Owner | Support | Deliverable |
|--------|------|-------|---------|-------------|
| 8.1 | All 10 levels content-complete | **Claude Code** | GPT, Gemini, Grok | Playable campaign |
| 8.1 | Full regression test suite | **Gemini CLI** | Claude Code | Test results |
| 8.2 | Save integrity stress test | **Gemini CLI** + **Codex** | Claude Code | Save verified |
| 8.2 | Performance profiling (all 10 levels) | **Gemini CLI** | Claude Code | Perf report |
| 8.3 | App Store metadata + screenshots | **Grok** | GPT (description text) | Store assets |
| 8.3 | Privacy policy + App Store compliance | **Opus** | Russ | Legal ready |
| 8.3 | Final build + TestFlight | **Claude Code** | Russ (device test) | Shippable build |
| GATE | **LAUNCH GATE** — full team review | **All agents** | Russ (final call) | SHIP / FIX |

```
PHASE 8 AGENT MAP — ALL HANDS
═══════════════════════════════
              Opus (coordination)
    ╱     │      │      │      │     ╲
Claude  Codex  Gemini  GPT   Grok  Gemini CLI
Code   (save  (final  (store (store (full
  │    test)  balance) text) assets) QA)
  │      │      │      │      │      │
  └──────┴──────┴──────┴──────┴──────┘
                   │
              LAUNCH GATE
               (Russ)
```

---

### Phase Summary: Agent Load Across Project

| Phase | Opus | Claude Code | Codex | Gemini | GPT | Grok | Gemini CLI | Russ |
|-------|------|-------------|-------|--------|-----|------|------------|------|
| **0 Align** | LEAD | SUPPORT | SUPPORT | IDLE | IDLE | IDLE | SUPPORT | GATE |
| **1 Foundation** | LEAD | LEAD | LEAD | IDLE | IDLE | SUPPORT | GATE | GATE |
| **2 Weapons** | LEAD | LEAD | SUPPORT | LEAD | SUPPORT | SUPPORT | GATE | GATE |
| **3 Enemies** | LEAD | LEAD | SUPPORT | LEAD | SUPPORT | LEAD | GATE | GATE |
| **4 Missions** | LEAD | LEAD | SUPPORT | SUPPORT | LEAD | SUPPORT | GATE | GATE |
| **5 Progression** | LEAD | LEAD | LEAD | LEAD | IDLE | SUPPORT | GATE | GATE |
| **6 Visual** | LEAD | LEAD | IDLE | SUPPORT | IDLE | LEAD | GATE | GATE |
| **7 Audio** | SUPPORT | LEAD | IDLE | IDLE | IDLE | LEAD | GATE | GATE |
| **8 Ship** | LEAD | LEAD | SUPPORT | SUPPORT | SUPPORT | LEAD | LEAD | GATE |

**Key insight:** Claude Code is LEAD in every phase. Opus is LEAD in 7/9. Gemini CLI gates every phase. Russ gates every phase. No agent is idle for more than 3 consecutive phases.

---

## 7. Risk Summary

| Risk | Severity | Owner |
|------|----------|-------|
| **SceneKit/RealityKit misalignment across all agents** | CRITICAL | Opus (re-briefing) |
| **Thermal/FLIR shader feasibility on RealityKit** | HIGH | Claude Code (technical spike) |
| **Russ bottleneck on decisions** | HIGH | Opus (decision packets) |
| **Save data corruption** (Goliath's lesson) | HIGH | Codex (SaveManager design) |
| **Economy balance untested** | MEDIUM | Gemini + playtesting |
| **AI asset generation consistency** | MEDIUM | Grok + Russ review |
| **Agent context amnesia between sessions** | MEDIUM | Opus (HANDOFF.md + briefings) |
| **v1 code quality debt carried into v2** | MEDIUM | Claude Code + Gemini CLI QA |

---

## 8. Economy Analysis: Grok Response Synthesis (2026-02-12)

### Source Cross-Reference

Two independent economy analyses were conducted:
- **Gemini** (GEMINI_PLAN.md): Original economy math, 85% unlock, ~35K income
- **Grok** (GROK_ECONOMY_RESPONSE.md): Follow-up analysis, 90% unlock, ~40K income

### Locked Economy Parameters

| Parameter | Value | Source |
|-----------|-------|--------|
| **Price** | $4.99 launch | Grok + Gemini converge |
| **Unlock target** | 90% first playthrough (skilled) | Grok (adopted over Gemini's 85%) |
| **Total upgrade cost** | ~39,800 Credits | Gemini (verified) |
| **Cost model** | S-curve (cheap early, expensive late) | Grok |
| **Respec** | No — v1.1 candidate | Russ decision |
| **NG+** | Keep upgrades, +20% rewards, +15% density | Grok |
| **Reaper Breakpoint** | Level 5 (~10K cumulative) | Both confirm |
| **Star multipliers** | 1.0x / 1.25x / 1.5x | Both confirm |

### Credit Reward Table (Calculated — Needs Gemini Validation)

Formula: Base = 800 + 250*(level-1), Secondaries = 3×250, First-Clear = 800, Star multipliers applied to (Base + Secondaries)

| Level | Base | Sec (3×250) | First-Clear | 1★ Total | 2★ Total | 3★ Total | Cumul (2★) |
|-------|------|-------------|-------------|----------|----------|----------|------------|
| 1 | 800 | 750 | 800 | 2,350 | 2,938 | 3,525 | 2,938 |
| 2 | 1,050 | 750 | 800 | 2,600 | 3,250 | 3,900 | 6,188 |
| 3 | 1,300 | 750 | 800 | 2,850 | 3,563 | 4,275 | 9,750 |
| 4 | 1,550 | 750 | 800 | 3,100 | 3,875 | 4,650 | 13,625 |
| 5 | 1,800 | 750 | 800 | 3,350 | 4,188 | 5,025 | 17,813 |
| 6 | 2,050 | 750 | 800 | 3,600 | 4,500 | 5,400 | 22,313 |
| 7 | 2,300 | 750 | 800 | 3,850 | 4,813 | 5,775 | 27,125 |
| 8 | 2,550 | 750 | 800 | 4,100 | 5,125 | 6,150 | 32,250 |
| 9 | 2,800 | 750 | 800 | 4,350 | 5,438 | 6,525 | 37,688 |
| 10 | 3,050 | 750 | 800 | 4,600 | 5,750 | 6,900 | 43,438 |

### Income vs. Cost Analysis

| Scenario | Total Income | % of 39,800 | Assessment |
|----------|-------------|-------------|------------|
| 1★ average (casual) | 34,800 | 87% | Healthy — unlocks core tree |
| 2★ average (competent) | 43,438 | 109% | **OVERSHOOT** — unlocks everything + surplus |
| 3★ average (mastery) | 52,125 | 131% | Way over — no NG+ incentive |

### ⚠️ PROBLEM: Grok's Formula Overshoots the 90% Target

At 2-star average, a player earns 109% of total costs — unlocking the **entire** tree with 3,600 credits to spare. This defeats the 90% design intent and removes the NG+ economy hook.

**Required Fix (for Gemini to execute in Phase 2.1):**
- Reduce base rewards by ~10-15% OR increase total upgrade costs by ~10%
- Target: 2★ average = 35,800 credits (90% of 39,800)
- 1★ average = ~30,000 (75% — core tree, meaningful gaps)
- 3★ average = ~44,000 (110% — full tree + small surplus as reward)

### Difficulty Arc (Two-Source Confirmed)

| Phase | Levels | Earnings % | Key Unlock | Player Feel |
|-------|--------|-----------|------------|-------------|
| Popcorn | 1-3 | 20% tree | Vulcan ammo | God mode, learn controls |
| The Crunch | 4-6 | 50% tree | Reaper ammo (breakpoint) | Pressure → relief |
| Endurance | 7-9 | 80-90% tree | ECM, Repair | Mastery, weapon juggling |
| Climax | 10 | 90% tree | — | Boss spectacle |

### New Game+ Framework (Grok — Adopted)

- Player keeps ALL upgrades from first run
- Enemies: +15% HP, increased density, new spawn patterns
- Rewards: +20-25% credits (funds remaining 10% elite upgrades)
- New secondary objectives per level
- **No HP sponge mode** — scale density and variety, not raw HP
- Target: 10+ additional hours of meaningful play

### Action Items

1. **Gemini** must produce final economy.json with adjusted rewards (~10% lower base) hitting 90% at 2★
2. **Gemini** must apply S-curve cost model to all 45+ upgrade paths
3. **Codex** must ensure SaveManager schema supports NG+ flag + persistent upgrades
4. **Claude Code** implements in Phase 5 (Sprint 5.1-5.3)
5. **Gemini CLI** validates via economy simulation (optimal/average/trap paths)

---

## 9. Final Assessment

**Decisions are locked. The team is hired. Execution begins.**

- **Build approach:** Hybrid — v1 patterns carry forward into new structure
- **Monetization:** Premium ($4.99-$9.99), no IAP, no ads, no energy timers
- **Scope:** 10 levels, 3 weapons (Vulcan/Havoc/Reaper), 11 enemy types, full narrative
- **Team:** 7 agents + 1 human founder, hub-and-spoke coordination via Opus
- **Quality bar:** CLAUDE_SKILL.md production discipline, Gemini CLI gates every phase

**Next action:** Phase 0B — Opus creates RealityKit re-briefing packets, Claude Code audits v1 for extraction, Codex redesigns infrastructure for RealityKit.

> **If it isn't playable, it isn't real.**

---

*Prepared by Claude Opus 4.6*
*Project Manager — WarSignal*
*2026-02-12 — Decisions Locked*
