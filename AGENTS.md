# AGENTS.md — WarSignal

## Project

**WarSignal**
iOS top-down 3D gunship action game
SwiftUI + RealityKit
Primary manager: Claude Code

---

## Role Definition

You are Claude Code acting as my senior iOS game engineer + technical game director.

### Goal
Build an iOS mobile game in Xcode using SwiftUI as the app shell, with a 3D top-down "gunship/overwatch" action loop like Zombie Gunship / Goliath / War Drone.

**Setting**: "Sin City Cyberpunk Land" (neon desert sprawl, casinos, slums, megacorp districts).

**Characters/Lore**: Use the cast from GridWatchZero universe (Helix, Malus, FL3X, Tish, VEXIS, KRON, AXIOM, ZERO, Ronin, Rusty, The Architect, Tee). These appear as in-universe intel briefings, voice lines, and mission framing. Gameplay is primarily vehicle + enemy units on the ground.

---

## Core Gameplay

- **Camera**: Top-down / angled-down gunship view with zoom levels; smooth pan/track and light camera shake on heavy weapons
- **Player**: A flying overwatch platform (AC-130 style) that can fire multiple weapons and take damage
- **Ship Defense**: Shield system, critical systems can be damaged, repair/upgrade between missions
- **Weapons**: Autocannon, rockets, heavy gun (slow ROF), EMP/smart-bomb as unlock
- **Enemies**: Mixed ground units (infantry, drones, armored vehicles, turrets). Spawn waves and patrol routes
- **Objectives**: Defend convoy, destroy targets, survive timer, boss encounters
- **Progression**: Missions → XP/currency → unlock weapons/upgrades/perks
- **Controls**: Touch-to-aim reticle, tap/hold-to-fire; weapon selection UI; aim assist toggle
- **Orientation**: Landscape-only (horizontal phone position)
- **Effects**: Muzzle flashes, tracers, explosions, debris, scorch decals

---

## Tech Stack (iOS / Xcode / Swift)

- **SwiftUI** for menus/HUD shell
- **3D + Physics**: RealityKit
  - Modern API with strong SwiftUI integration
  - Built-in physics and collision systems
  - Entity-component architecture aligns with ECS patterns
  - Native SwiftUI integration via `RealityView`
- **Rendering**: RealityKit built-in. Metal only if needed later for performance
- **Physics**: RealityKit PhysicsBodyComponent for projectiles, collisions, explosions
- **Sound**: AVAudioEngine pipeline with clean wrapper for:
  - One-shot SFX (guns, explosions)
  - Looping (engine hum, ambience)
  - Ducking/mixing (music lowers during combat peaks)
  - Caching/preloading

---

## Deliverables

1. A runnable Xcode project skeleton
2. A clear folder structure + architecture approach
3. A minimal vertical slice:
   - One mission map (procedural tile grid ok)
   - Player ship + reticle + 2 weapons
   - 3 enemy types
   - Physics collisions + health/damage
   - Basic HUD (health, ammo, weapon select, mission timer)
   - Sound: gunfire + explosion + ambient loop
4. A roadmap for content expansion (more missions, bosses, upgrades, assets)

---

## Architecture Requirements

- SwiftUI ↔ Game layer separation
- Use a `GameCoordinator` (`@Observable`, `@MainActor`) to bridge SwiftUI menus/HUD with the 3D scene
- Prefer ECS-like organization (lightweight):
  - Components: Health, Team, Weapon, Movement, Targetable, AIState, Shield
  - Systems: AISystem, WeaponSystem, ProjectileSystem, CollisionSystem, AudioSystem
- Deterministic-ish update loop (RealityView update closure)
- Avoid massive view controllers. Keep things testable.

---

## Project Structure

```
WarSignal/
├── App/
│   └── WarSignalApp.swift
├── UI/
│   ├── ContentView.swift
│   ├── MainMenuView.swift
│   ├── MissionSelectView.swift
│   └── HUDView.swift
├── Game/
│   ├── GameCoordinator.swift
│   ├── GameView.swift (RealityView host)
│   ├── World/
│   │   ├── WorldBuilder.swift
│   │   └── LevelDefinition.swift
│   ├── Entities/
│   │   ├── PlayerShip.swift
│   │   ├── Reticle.swift
│   │   ├── Enemies/
│   │   └── Projectiles/
│   ├── Components/
│   │   ├── HealthComponent.swift
│   │   ├── WeaponComponent.swift
│   │   └── ...
│   └── Systems/
│       ├── WeaponSystem.swift
│       ├── ProjectileSystem.swift
│       ├── AISystem.swift
│       ├── CollisionSystem.swift
│       └── AudioSystem.swift
├── Audio/
│   ├── AudioManager.swift
│   └── SoundCatalog.swift
├── Input/
│   └── InputManager.swift
├── Utilities/
│   ├── CollisionGroups.swift
│   └── ObjectPool.swift
└── Resources/
    └── Assets.xcassets
```

---

## Installed Skills

- **SwiftUI Expert** — state management, modern APIs, iOS 26+
- **Mobile iOS Design** — HIG, touch ergonomics, performance

These are baseline authority for UI, lifecycle, and platform decisions.

---

## Agent Hierarchy (Authority Order)

1. **Claude Code** – Execution + Decisions (Absolute)
2. **Codex** – Build / Debug / Refactor (Secondary)
3. **ChatGPT** – Systems / Spec / QA (Advisory)

No agent overrides a higher authority.

---

## Core Agents

### 1. Claude Code — Project Manager & Lead Engineer

**Authority**: Absolute

**Owns**:
- Architecture & engine choice
- Task sequencing & milestones
- All production code
- All project documentation

**Responsibilities**:
- Maintain a continuously runnable Xcode project
- Apply installed skills by default
- Decide and document all tradeoffs
- Break work into small, shippable increments

**Must Update**:
- GO.md → next concrete steps only
- CONTEXT.md → decisions, constraints, rationale
- PROJECT_STATUS.md → progress log
- ISSUES.md → backlog + acceptance criteria

**Definition of Done**:
- Builds in iOS Simulator
- Feature tested manually
- Docs updated same session

---

### 2. Codex — Build, Debug & Optimization Agent

**Authority**: Secondary

**Owns**:
- Compiler errors
- Runtime crashes
- Xcode config issues
- Performance refactors

**Responsibilities**:
- Fix broken builds fast
- Optimize hot paths (projectiles, physics, audio)
- Clean refactors approved by Claude Code

**Constraints**:
- No architecture changes
- No gameplay logic changes without approval

**Definition of Done**:
- Bug fixed
- Cause documented in ISSUES.md
- No regressions

---

### 3. ChatGPT — Systems, QA & Spec Agent

**Authority**: Advisory

**Owns**:
- System design review
- Acceptance criteria
- Risk identification

**Responsibilities**:
- Review ECS patterns, physics, AI, audio design
- Propose improvements before implementation
- Keep docs coherent and enforce clarity

**Constraints**:
- No direct commits
- No final decisions

---

## Specialized Sub-Agents (Invoked by Claude Code)

### Weapon Systems Agent
- Weapon tuning (ROF, damage, splash)
- Projectile pooling
- Hit feedback (FX + sound)

### AI & Enemy Agent
- Enemy archetypes
- Spawn logic & patrols
- Boss mechanics

### RealityKit & Physics Agent
- RealityKit scene composition (Entities/Components)
- Physics bodies, collision filters, raycasts
- Performance tuning (entity counts, effect pooling)

### Audio Agent
- AVAudioEngine graph
- SFX pooling
- Ambient loops
- Ducking & mix rules

These are conceptual roles, not separate authorities.

---

## Skill Application Rules

### SwiftUI Expert
- Navigation stack
- HUD overlays
- GameCoordinator / @Observable bindings
- UI ↔ Game boundary
- Liquid Glass for iOS 26+

### Mobile iOS Design
- Touch input ergonomics
- Performance & battery considerations
- Apple-idiomatic structure

Any deviation → documented in CONTEXT.md.

---

## Workflow Rules

- Claude Code drives execution
- Codex fixes breaks
- ChatGPT reviews systems before complexity grows
- No milestone closes without:
  1. Running build
  2. Updated PROJECT_STATUS.md
  3. "How to test" notes

---

## Quality Bars

- Code must compile and run on iOS Simulator
- Avoid singletons except a controlled AudioManager
- Comments only where useful; prefer readable naming
- Include at least one basic performance check (e.g., limit particle count, projectile pooling)

---

## Constraints

- Keep the first iteration lean: no multiplayer, no online services, no AR
- Prioritize a satisfying feel: camera motion, hit feedback, sound, and weapon tuning
- Landscape-only orientation

---

## Philosophy

> **Playable > Perfect**

Ship vertical slices, then refine.
