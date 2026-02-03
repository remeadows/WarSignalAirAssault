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

## Core Design Pillars

1. **Top-Down 3D Combat**
   - Angled overhead camera (45-60 degrees)
   - Zoom levels for tactical clarity
   - Clear silhouettes and contrast
   - No first-person or cockpit view

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

Baseline weapon classes:
- **Autocannon** (rapid fire, low damage per hit)
- **Rockets** (slow, splash damage)
- **Heavy gun** (high damage, slow ROF)
- **EMP / Smart Bomb** (unlock, area effect)

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

## Progression

Early progression:
- Mission completion
- Currency rewards
- Weapon upgrades
- Ship repairs/upgrades

Persistence:
- UserDefaults (initial)
- Migrate to file-based save later if needed

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
