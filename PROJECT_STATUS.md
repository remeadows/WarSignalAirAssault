# PROJECT_STATUS.md — WarSignal

## Status

**Active Development**

---

## Current Milestone

**Milestone 3 — Mission Structure & Polish**

**Status**: IN PROGRESS

### Reference Analysis Complete
Goliath game screenshots analyzed. Key features identified for implementation:
- Thermal/infrared visual mode
- Goliath-style reticle (corner brackets, compass rose) ✅ IMPLEMENTED
- Dual trigger system (ALPHA/BRAVO)
- Support unit deployment
- Multi-tier mission objectives
- Persistent camera movement (AC-130 drift)

---

## Previous Milestone

**Milestone 2 — Combat Loop**

**Status**: ✅ COMPLETE

### Planned Scope
- SwiftUI shell with landscape-only orientation
- RealityKit RealityView embedded
- Camera + reticle
- Autocannon weapon with projectile pooling
- Basic enemy target with health/damage
- Audio playback (gunshot SFX, ambient loop)

### Risks
| Risk | Severity | Mitigation |
|------|----------|------------|
| RealityKit + SwiftUI RealityView lifecycle quirks | Medium | Test early, document patterns |
| Touch-to-world raycast precision in RealityKit | Medium | Prototype in step 5 before weapons |
| Projectile pooling with RealityKit entities | Medium | Design pool system early |
| iOS 26 Simulator availability/stability | Low | Test on device if needed |

### Progress
- [x] Documentation framework established
- [x] Engine decision locked (RealityKit)
- [x] SpriteKit template replaced with SwiftUI + RealityKit (WS-001)
- [x] GameCoordinator implemented (basic version)
- [x] Basic scene rendering (floor + test target)
- [x] Camera system with zoom levels (WS-003)
- [x] Touch aiming + reticle (WS-004)
- [x] Full-screen rendering fix (WS-017)
- [x] Fire button in HUD
- [x] Collision groups (WS-013)
- [x] Autocannon weapon with projectile pooling (WS-005)
- [x] Target dummy with health (WS-006)
- [x] Audio baseline (WS-007)

---

## Completed Milestones

### Milestone 0 — Project Initialization

**Status**: COMPLETE

**Completed**:
- CONTEXT.md authored and standardized
- AGENTS.md created and cleaned
- CLAUDE.md created (comprehensive operating rules)
- GO.md updated with RealityKit references
- ISSUES.md created with initial backlog
- Skills.md replaced with project-specific version
- GitHub repo initialized

---

## Upcoming Milestones

### Milestone 2 — Combat Loop

**Status**: IN PROGRESS

**Scope**:
- Multiple weapons (rockets, heavy gun)
- Enemy archetypes (infantry, drone, turret)
- Ship takes damage (shield system)
- HUD polish (health, ammo, weapon select)
- Objectives system

**Progress**:
- [x] WS-008: HUD Overlay polish with liquid glass aesthetic
- [x] WS-012: Ship Shield System with enemy attacks
- [x] WS-009: Rocket Weapon with splash damage
- [x] WS-010: Infantry Enemy with movement AI
- [x] WS-011: Drone Enemy with erratic flight

### Milestone 3 — Mission Structure

**Status**: NOT STARTED

**Scope**:
- Mission select screen
- Multiple mission types
- Wave spawning system
- Mission completion/failure
- Progression (currency, unlocks)

---

## Decision Log

### 2025-02-03: Engine Selection
- **Decision**: RealityKit over SceneKit/SpriteKit
- **Rationale**: Modern API, better SwiftUI integration via RealityView, entity-component architecture aligns with ECS patterns, active Apple development
- **Trade-offs**: Less community resources, more AR-oriented documentation
- **Documented in**: CONTEXT.md

### 2025-02-03: Orientation Lock
- **Decision**: Landscape-only
- **Rationale**: Gunship gameplay feels better horizontal, matches genre conventions (Zombie Gunship, Goliath)
- **Trade-offs**: No portrait support
- **Documented in**: CONTEXT.md, CLAUDE.md

### 2025-02-03: Documentation Standardization
- **Decision**: Create CLAUDE.md as comprehensive quick-reference
- **Rationale**: New context windows need single-page bootstrap, reduces doc review time
- **Action**: All docs updated for consistency

### 2025-02-03: Full-Screen Rendering Fix
- **Decision**: Added `INFOPLIST_KEY_UILaunchScreen_Generation = YES` to project.pbxproj
- **Rationale**: Without this, iOS runs app in compatibility/letterbox mode (x2 scaling)
- **Trade-offs**: None — this is required for modern iOS apps
- **Documented in**: CLAUDE.md (Orientation & Display section)

---

## Known Issues

See **ISSUES.md** for full backlog.

---

## Session Log

### 2025-02-03
- Created CLAUDE.md (comprehensive operating rules)
- Updated CONTEXT.md (RealityKit, landscape, ship defense)
- Updated AGENTS.md (removed contradictions, fixed naming)
- Updated GO.md (clean structure, RealityKit refs)
- Updated PROJECT_STATUS.md (decision log, risks)
- Created ISSUES.md (initial backlog)
- Replaced Skills.md (project-specific patterns)
- **Completed WS-001**: Replaced SpriteKit template with SwiftUI + RealityKit
  - Removed all SpriteKit/UIKit files
  - Created WarSignalApp.swift (@main entry point)
  - Created ContentView.swift (navigation)
  - Created MainMenuView.swift (cyberpunk styled menu)
  - Created GameCoordinator.swift (@Observable state bridge)
  - Created GameView.swift (RealityView with floor + test target)
  - Configured landscape-only orientation
  - Build succeeds on iPhone 17 Pro Simulator
- **Completed WS-014**: Fixed MainMenuView title cutoff
  - Changed to HStack layout (title left, buttons right)
  - GeometryReader for adaptive sizing
- **Completed WS-002**: GameCoordinator fully implemented
  - GamePhase state machine
  - WeaponType with all properties
  - Per-frame update() loop
  - Heat/overheat system
  - Mission timer, scoring, ammo tracking
  - Environment injection support
- **Completed WS-015**: Fixed MainMenuView vertical text display
  - Added `.fixedSize(horizontal: true, vertical: false)` to prevent text wrapping
- **Completed WS-016**: Fixed GameView close button overlapping health bar
  - Moved to top-right corner (`.topTrailing` alignment)
- **Completed WS-003**: Camera System
  - Created CameraController.swift with PerspectiveCameraComponent
  - 3 zoom levels (Close/Medium/Far) with different heights and angles
  - Smooth position interpolation
  - Camera shake system with weapon presets
  - Zoom button in HUD
- **Completed WS-004**: Touch Aiming + Reticle
  - Created ReticleController.swift with 3D targeting reticle
  - Outer ring, inner ring (pulsing), center dot, crosshairs
  - Cyan normal / red target color states
  - Screen-to-world conversion with zoom-level adjustment
  - Shows on touch, hides on release
- **Fixed WS-017**: Full-Screen Rendering Issue
  - Symptom: App ran in compatibility mode with black bars (x2 button visible)
  - Root cause: Missing `INFOPLIST_KEY_UILaunchScreen_Generation = YES` in project.pbxproj
  - Fix: Added launch screen generation to both Debug and Release build configurations
  - Also refactored GameSceneView to use UIViewControllerRepresentable for proper ARView hosting
- **Added**: Fire button to HUD with hold-to-fire gesture
- **Added**: HUD reorganization (Score, Zoom, Close buttons in top-right)
- **Completed WS-013**: Collision Groups
  - Created CollisionGroups.swift with all required groups
  - Groups: default, player, playerProjectile, enemy, enemyProjectile, terrain, pickup, explosionArea
  - Collision masks and filter presets
- **Completed WS-005**: Autocannon Weapon
  - Created WeaponSystem.swift for weapon firing logic
  - Created ProjectilePool.swift with object pooling (60 autocannon, 15 rockets, 30 heavy)
  - Cylinder mesh for tracer visual (RealityKit lacks capsule mesh)
  - Emissive UnlitMaterial for glowing tracer effect
  - Muzzle flash and impact spark effects
  - Fire rate control (autocannon: 12 rounds/sec)
  - Continuous fire on hold via isFiring state
  - Camera shake on fire
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Completed WS-006**: Basic Enemy Target
  - Created HealthComponent.swift for reusable health tracking
  - Created EnemySystem.swift for enemy management
  - Team-based damage filtering (player/enemy/neutral)
  - EnemyConfig for type definitions (basicTarget: 30HP, armoredTarget: 80HP)
  - In-flight projectile hit detection
  - Destruction effect (expanding orange sphere)
  - Respawn queue with delay
  - Hit pulse animation on non-fatal damage
  - 6 test enemies spawned at start
  - Score awarded on kills
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Completed WS-007**: Audio System Foundation
  - Created AudioSystem.swift using AVAudioEngine
  - SFX player pool (16 concurrent sounds)
  - Dedicated ambient player with looping
  - Synthesized placeholder sounds (weapons, impacts, UI, ambient)
  - Volume control with presets
  - Integrated with WeaponSystem for fire/impact/explosion sounds
  - Ambient starts/stops with mission
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Fixed**: Audio crash on mission start
  - Issue: `required condition is false: _outputFormat.channelCount`
  - Cause: Generated mono buffers but output expected stereo
  - Fix: Generate audio buffers using output node's actual format (sample rate + channels)
- **Milestone 1 COMPLETE** — All tasks finished
- **Created**: COMMIT.md with commit/push instructions
- **Updated**: GO.md with session summary and next steps

### 2026-02-03 (Milestone 2 Start)
- **Started Milestone 2**: Combat Loop
- **Completed WS-008**: HUD Overlay Polish
  - Added iOS 26 liquid glass effect (`.glassEffect()`) to all HUD panels
  - Cyberpunk gradient borders on HUD elements
  - Enhanced HUDBar with segment markers and glow effects
  - Low-health/shield warning indicators with pulsing glow
  - Heat gauge with gradient fill and threshold marker
  - Weapon-specific color coding throughout HUD
  - Fire button updates to match selected weapon color
  - Weapon selector with selection animation and glow
  - Score display with gold gradient
  - Timer turns red with glow under 30 seconds
  - Unlimited ammo shown as ∞ for autocannon
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Completed WS-012**: Ship Shield System
  - Shield regeneration (10 HP/sec after 3 sec delay)
  - Damage cooldown tracking for regen delay
  - Visual damage flash overlay (red radial gradient)
  - Low health pulsing vignette effect
  - Camera shake on player damage
  - Sound effects for shield vs hull damage
  - Turret enemy type that attacks the player
  - Enemy attack system with configurable damage/interval
  - Muzzle flash effect pool for enemy attacks
  - Attack timers preserved on enemy respawn
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Completed WS-009**: Rocket Weapon
  - Explosion effect pool (8 effects) with expanding animation
  - Splash damage using existing radius system
  - Distinct visual feedback for rocket impacts
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Completed WS-010**: Infantry Enemy
  - MovementConfig struct for mobile enemy configuration
  - Infantry: 15 HP, seeks objective position
  - EnemyMovementData with AI state tracking
  - Seeking behavior toward objective
  - Deals damage when reaching objective
  - Taller/thinner visual shape
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Completed WS-011**: Drone Enemy
  - Drone config: 10 HP, 75 score, fast & fragile
  - Erratic flight via noise factor (0.7)
  - Flying movement with height maintenance
  - Wandering AI with random target points
  - Disc/saucer mesh shape
  - Can attack player (8 damage, 3 sec interval)
  - Build succeeds on iPhone 17 Pro Max Simulator
- **Milestone 2 Core Combat Loop COMPLETE** — All planned tasks finished

### 2026-02-03 (Milestone 3 Start)
- **Analyzed Goliath Reference**: Screenshots captured from iPhone Mirroring
  - Mission objectives screen with multi-tier progress tracking
  - Settings menu with HUD toggles
  - Gameplay view with thermal vision and tactical reticle
  - Support units selection grid (13 deployables)
  - Mission summary with kill counts
- **Implemented Goliath-Style Reticle**:
  - 4 L-shaped corner brackets
  - Center crosshair lines with gap
  - Pulsing center dot
  - Diamond compass markers (N/E/S/W)
  - Cyan normal / red target colors
- **Identified Core Issues** (from playtesting):
  1. No AC-130 movement feel (camera static)
  2. Enemies at bottom = instant death (no counterplay)
  3. Shooting boxes/dots (placeholder graphics)
  4. Can't change weapons during gameplay
  5. Reticle not always visible
  6. RealityKit suitability question
