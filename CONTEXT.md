# CONTEXT.md — WarSignal

## Project Overview

WarSignal is an iOS top-down 3D gunship/overwatch action game inspired by Zombie Gunship, Goliath, and War Drone.

The player operates an airborne overwatch platform delivering precision fire from above in a cyberpunk "Sin City" megasprawl—neon deserts, corrupted casinos, slums, megacorp infrastructure, and militarized zones.

The game prioritizes:
- Tight, satisfying weapon feel
- Readable battlefield chaos
- Strong audio feedback
- Ship defense mechanics
- Fast iteration and vertical slices

---

## Reference Game: Goliath

WarSignal is directly inspired by **Goliath** (iOS AC-130 gunship game). Key features to emulate:

### Visual Style
- **Grayscale thermal/infrared view** — monochrome battlefield with high contrast
- **Military HUD aesthetic** — tactical crosshair, minimal chrome
- **Enemy markers** — red diamonds on hostiles, white on friendlies/neutrals

### Reticle Design
- **Corner L-brackets** — 4 corners framing the target area
- **Compass rose** — N/E/S/W cardinal markers
- **Center crosshair** — thin lines with gap, pulsing dot
- **Magnification indicator** — "MAGNIFICATION 10X" style zoom display

### Weapons (Goliath Reference)
- **ALPHA trigger** — Primary weapon (TALON, HELLFIRE, D.BREATH, FIREBIRD)
- **BRAVO trigger** — Secondary/support weapon
- **Weapon bar** — Horizontal selection at bottom of screen
- **Cooldown/reload indicators** — Per-weapon status

### Support Units (Goliath Reference)
- **UAV** — Reconnaissance
- **Sentry Gun** — Automated defense
- **Contractor** — Ground troops
- **Mortars** — Artillery support
- **Humvee/Bradley/Abrams** — Ground vehicles
- **Blackhawk/Littlebird/Apache** — Air support
- **F15/Warthog** — Air strikes
- Levels system (Lv.1 - Lv.8) for upgrades

### Mission Structure (Goliath Reference)
- **Multi-tier objectives** — Primary + bonus challenges
- **Progress tracking** — "10/25 WARPIGS DESTROYED" style
- **Time challenges** — "Complete in 05:00"
- **Weapon-specific challenges** — "Kill X with tactical bombs"
- **Mission summary** — Kill counts by enemy type + rewards

### Settings (Goliath Reference)
- Graphics quality, framerate, vibration
- HUD toggles: healthbars, hitmarkers, combat log, kill cam, floating damage
- Fire button layout options (ALPHA | BRAVO)

---

## Core Design Pillars

1. **Top-Down 3D Combat**
   - Angled overhead camera (45-60 degrees)
   - Zoom levels for tactical clarity (with MAGNIFICATION display)
   - Clear silhouettes and contrast
   - No first-person or cockpit view
   - **Slow camera drift/orbit** — AC-130 circling feel

2. **Weapon Feel Over Visual Fidelity**
   - Hit feedback, sound, recoil, camera shake
   - Projectile readability
   - Consistent damage rules

3. **Ship Defense**
   - Player ship can take damage
   - Shield system with recharge
   - Critical systems can be damaged
   - Repair/upgrade between missions

4. **Lean, Shippable Architecture**
   - SwiftUI shell
   - Embedded 3D scene via RealityView
   - Small, testable systems
   - Minimal magic

5. **Playable First**
   - Vertical slices over feature bloat
   - Placeholder assets acceptable
   - Performance > polish in early phases

---

## Platform & Technology

### Target Platform
- iOS 26.x (iPhone first, iPad later)
- Xcode 16+
- iOS Simulator as baseline

### Orientation
- **Landscape-only** (horizontal phone position)
- Locked via Info.plist supported orientations
- Optimized for gunship gameplay feel

### UI Layer
- SwiftUI
- Handles: Menus, HUD overlays, Navigation, Game state presentation
- Liquid Glass effects for cyberpunk aesthetic (iOS 26+)

### 3D Engine
- **RealityKit** (default choice)

### Rationale
- Modern Apple framework with active development
- Strong physics and collision support
- Native SwiftUI integration via RealityView
- Entity-component architecture aligns with ECS patterns
- Better suited for non-AR 3D games than commonly assumed

### Integration
- Use SwiftUI `RealityView` as the primary 3D host
- Simulation update loop uses RealityKit systems/components
- Per-frame updates via RealityKit's update closure

Metal may be revisited only if performance demands it.

---

## Architecture Overview

### GameCoordinator

**Responsibilities**:
- Bridge UI ↔ Game World
- Expose read-only game state to SwiftUI
- Dispatch player input (aim, fire, weapon select)
- Manage game lifecycle (start, pause, end)

**Implementation**:
- `@Observable` class
- `@MainActor` isolated
- Does NOT run physics directly
- Does NOT update enemies directly
- Does NOT own Entity references (RealityKit manages these)

### ECS-Inspired Organization (Lightweight)

**Components**:
- Health
- Team
- Weapon
- Movement
- Targetable
- AIState
- Shield (for ship defense)

**Systems**:
- WeaponSystem
- ProjectileSystem
- CollisionSystem
- AISystem
- AudioSystem
- DamageSystem
- ShieldSystem

This is not a full ECS framework—just disciplined separation.

---

## Camera & Controls

### Camera
- Fixed overhead / angled-down view (45-60 degrees)
- Smooth follow and pan
- Mild camera shake on heavy weapons
- Zoom levels for tactical clarity

### Controls
- Touch-based reticle aiming (drag gesture)
- Tap / hold to fire
- Weapon selection UI
- Optional aim assist (future)

---

## Weapons

### Cyberpunk Weapon Classes (WarSignal — Names LOCKED)
- **Vulcan** (rapid fire, 20mm gatling, 120 DPS) — TALON equivalent
- **Havoc** (guided rockets, splash damage, 33.3 DPS) — HELLFIRE equivalent
- **Reaper** (heavy ordnance, max single-target, 40 DPS) — D.BREATH equivalent
- **TBD** (unlock, area-denial EMP/smart bomb) — FIREBIRD equivalent

### Dual Trigger System (Goliath-Style)
- **ALPHA** — Primary weapon, main damage dealer
- **BRAVO** — Secondary weapon, support/utility

Weapon traits:
- Damage
- Fire rate
- Splash radius
- Ammo / cooldown
- Audio + visual identity

**Projectile pooling is mandatory.**

---

## Enemies

Enemy archetypes:
- **Infantry** (low HP, swarm behavior)
- **Drones** (fast, fragile)
- **Armored vehicles** (slow, tanky)
- **Turrets** (stationary threats, can damage player ship)
- **Boss units** (scripted behavior, multi-phase)

Enemies are:
- Spawned via systems
- Driven by simple state machines
- Tuned for readability, not realism

---

## Physics & Collisions

- RealityKit physics engine (PhysicsBodyComponent, CollisionComponent)
- Collision categories defined centrally (CollisionGroup)
- Raycasts used for:
  - Aiming (screen-to-world)
  - Targeting
  - Ground intersection

Explosions apply:
- Radius-based damage
- Optional impulse force

---

## Audio Design

### Engine
- AVAudioEngine

### Audio Rules
- Pooled one-shot SFX (guns, impacts, explosions)
- Looping ambience (city hum, engines, wind)
- Music ducking during combat spikes
- Category-based volume controls (SFX, Music, Ambient)

Audio is a first-class system, not an afterthought.

---

## World & Setting

### Tone
- Cyberpunk
- Militarized surveillance
- Neon + dust + decay
- Corporate corruption

### Locations
- Neon casino districts
- Slum outskirts
- Industrial megastructures
- Desert highways
- Data centers / power grids

### Lore Usage
- Characters from GridWatchZero universe exist as:
  - Mission briefings
  - Voice lines
  - Intel overlays
- Gameplay remains vehicle-centric

---

## Monetization & Economy (LOCKED 2026-02-12)

### Monetization Model
- **Premium: $4.99 launch price** — No IAP, no ads, no energy timers, no dual currency
- Single currency: **Credits**
- Positioning: "Pay once, play forever. No BS."
- Tier to $6.99 post-launch if reviews hit 4.7+ stars

### Campaign Structure
- **10 levels**, 2-4 hours core campaign
- Star ratings: Survivor (1★), Operator (2★), Ace (3★)
- Star reward multipliers: 1.0x / 1.25x / 1.5x
- **New Game+**: Keep upgrades, +15% enemy density, +20% rewards

### Economy Targets
- Total upgrade cost: ~39,800 Credits
- Target unlock: **90% tech tree on skilled first playthrough** (2★ average)
- Remaining 10% via NG+ earnings
- **S-curve cost model**: Cheap early tiers (flow), expensive late tiers (mastery)
- **No respec mechanic in v1** — economy generous enough that bad paths are recoverable

### Key Economy Moment
- **"The Reaper Breakpoint"**: Reaper upgrade to 1-shot tanks affordable at Level 5 (~10K cumulative credits)
- This is the primary power fantasy payoff — engineered into the economy curve

### Weapons (Canonical Names — LOCKED 2026-02-12)

| Slot | Name | Identity | Base DPS |
|------|------|----------|----------|
| Primary (ALPHA) | **Vulcan** | 20mm rapid-fire gatling | 120 DPS |
| Secondary (BRAVO) | **Havoc** | Guided rockets, splash damage | 33.3 DPS |
| Heavy | **Reaper** | Heavy ordnance, max single-target | 40 DPS |
| Unlock (endgame) | **TBD** | Area-denial EMP/smart bomb | TBD |

---

## Progression

Early progression:
- Mission completion
- Credit rewards (base + secondaries + first-clear + star multiplier)
- Weapon upgrades (3 categories × 4-5 tiers per weapon)
- Ship defense upgrades (Hull, Flares, ECM, Repair)
- Ground team upgrades (Armor, Weapons, Medic, Recon, APC)

Persistence:
- File-based save with versioned envelope, backup, and migration (Codex SaveManager)
- NG+ flag + persistent upgrade state

No online services in v1.

---

## Performance Philosophy

- Pool everything that fires or explodes
- Limit active particles
- Track:
  - Entity counts
  - Active projectiles
  - FPS (debug overlay)
- Prefer fewer, clearer effects over many noisy ones
- Profile with Instruments regularly

---

## Non-Goals (Explicit)

- Multiplayer
- PvP
- AR
- Open world
- Cinematic cutscenes
- Realistic flight simulation
- Online services in v1

---

## Authority & Decision Rules

- Claude Code owns final decisions
- Deviations from this document must be documented here
- This file is the **single source of truth** for vision + architecture

---

## Guiding Principle

> **If it isn't playable, it isn't real.**

Build the fun first. Everything else is negotiable.
