# ISSUES.md — WarSignal Backlog

## Archive Policy

When this file exceeds **200 lines**, move completed items to `ISSUES_ARCHIVE.md` with completion date.

## Priority Definitions

| Priority | Meaning |
|----------|---------|
| **P0** | Blocker — must complete before other work |
| **P1** | High — required for current milestone |
| **P2** | Medium — enhances current milestone |
| **P3** | Low — future milestone or nice-to-have |

---

## Active Sprint (Milestone 3)

### WS-023: Always-On Reticle

**Priority**: P0 — Blocker
**Status**: 🔴 NOT STARTED
**Type**: UX Fix
**Milestone**: M3

**Description**: Reticle currently only shows when touching screen. For Simulator/desktop testing and better gameplay, reticle should always be visible. Color/state changes indicate target lock.

**Acceptance Criteria**:
- [ ] Reticle visible at all times during gameplay
- [ ] Follows touch/mouse position
- [ ] Color changes: cyan (normal) → red (valid target)
- [ ] Works in iOS Simulator with mouse

---

### WS-024: AC-130 Camera Drift

**Priority**: P1 — High
**Status**: 🔴 NOT STARTED
**Type**: Feature
**Milestone**: M3

**Description**: Camera should slowly drift/orbit to simulate AC-130 gunship circling the target area. This is core to the Goliath/Zombie Gunship feel.

**Acceptance Criteria**:
- [ ] Camera slowly orbits around battlefield center
- [ ] Orbit speed configurable (default: ~30 sec full rotation)
- [ ] Player can still aim anywhere on visible area
- [ ] Ground scrolls beneath camera

---

### WS-025: Weapon Switching During Gameplay

**Priority**: P1 — High
**Status**: 🔴 NOT STARTED
**Type**: Bug/Feature
**Milestone**: M3

**Description**: Weapon buttons in HUD exist but may not be functional. Need to verify and fix weapon switching.

**Acceptance Criteria**:
- [ ] Tapping weapon button changes active weapon
- [ ] Visual feedback on selected weapon
- [ ] Different weapons have distinct projectiles
- [ ] Ammo/cooldown updates per weapon

---

### WS-026: Thermal/Infrared Visual Mode

**Priority**: P2 — Medium
**Status**: 🔴 NOT STARTED
**Type**: Feature (Goliath-inspired)
**Milestone**: M3

**Description**: Implement grayscale thermal vision mode like Goliath. Enemies should be bright (hot), terrain dark, with high contrast.

**Acceptance Criteria**:
- [ ] Full-screen grayscale/sepia post-process effect
- [ ] Enemies glow bright (white/yellow)
- [ ] Terrain is dark gray
- [ ] Player can toggle thermal on/off
- [ ] "MAGNIFICATION" indicator in HUD

---

### WS-027: Dual Trigger System (ALPHA/BRAVO)

**Priority**: P2 — Medium
**Status**: 🔴 NOT STARTED
**Type**: Feature (Goliath-inspired)
**Milestone**: M3

**Description**: Replace single fire button with ALPHA (left) and BRAVO (right) triggers like Goliath.

**Acceptance Criteria**:
- [ ] Two fire buttons at bottom of screen
- [ ] ALPHA fires primary weapon
- [ ] BRAVO fires secondary weapon
- [ ] Each trigger has independent cooldown

---

### WS-028: Support Unit System

**Priority**: P3 — Low
**Status**: 🔴 NOT STARTED
**Type**: Feature (Goliath-inspired)
**Milestone**: M3+

**Description**: Deployable support units (UAV, Sentry Gun, Mortars, etc.) that assist the player.

**Acceptance Criteria**:
- [ ] Support selection UI (grid like Goliath)
- [ ] At least 3 support types implemented
- [ ] Cooldown between deployments
- [ ] Support units have levels/upgrades

---

### WS-029: Enemy Visual Upgrade

**Priority**: P2 — Medium
**Status**: 🔴 NOT STARTED
**Type**: Polish
**Milestone**: M3

**Description**: Replace colored boxes with recognizable enemy silhouettes. Doesn't need to be detailed models—clear shapes are fine.

**Acceptance Criteria**:
- [ ] Infantry: humanoid shape
- [ ] Drone: disc/quad shape
- [ ] Vehicle: rectangular with treads
- [ ] Turret: base + barrel
- [ ] Enemy healthbars (optional toggle)

---

### WS-030: Ship Defense Clarity

**Priority**: P1 — High
**Status**: 🔴 NOT STARTED
**Type**: UX Fix
**Milestone**: M3

**Description**: When enemies reach the bottom of screen, player dies with no feedback. Need clear "ship area" visualization and warning system.

**Acceptance Criteria**:
- [ ] Visual indicator of ship/objective area
- [ ] Warning when enemies approach objective
- [ ] Clear feedback when objective takes damage
- [ ] Not instant death—damage over time or per enemy

---

## Archived (Milestone 1-2)

### WS-014: Fix MainMenuView Title Cutoff in Landscape

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-001
**Type**: Bug

**Description**: "WAR" title text is cut off at the top of the screen in landscape orientation on iPhone 17 Pro Max. The VStack layout doesn't account for safe area properly.

**Fix**: Changed to horizontal HStack layout with "WAR SIGNAL" side by side. Added GeometryReader for adaptive sizing. Title on left, menu buttons on right - better landscape utilization.

**Acceptance Criteria**:
- [x] Full "WAR SIGNAL" title visible in landscape
- [x] Proper safe area handling
- [x] Works on all iPhone sizes (adaptive with isCompact check)

---

### WS-015: Fix MainMenuView Vertical Text Display

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-014
**Type**: Bug

**Description**: After WS-014 fix, title text was rendering vertically (letters stacked) instead of horizontally side-by-side in landscape.

**Fix**: Added `.fixedSize(horizontal: true, vertical: false)` to HStack containing title text to prevent SwiftUI from wrapping individual characters.

**Acceptance Criteria**:
- [x] "WAR SIGNAL" displays horizontally (side by side)
- [x] Text doesn't wrap vertically
- [x] Works in landscape orientation

---

### WS-016: Fix GameView Close Button Overlapping Health Bar

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-002
**Type**: Bug

**Description**: Close button (X) in GameView was positioned in top-left corner, overlapping the health bar HUD element.

**Fix**: Moved close button to top-right corner (`.topTrailing` alignment) with adjusted padding to avoid score display overlap.

**Acceptance Criteria**:
- [x] Close button doesn't overlap health bar
- [x] Close button doesn't overlap score display
- [x] Button still accessible for testing

---

### WS-001: Replace SpriteKit Template with SwiftUI + RealityKit

**Priority**: P0 — Blocker
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: None

**Acceptance Criteria**:
- [x] Remove SpriteKit files: `GameScene.swift`, `GameScene.sks`, `Actions.sks`
- [x] Remove UIKit files: `GameViewController.swift`, `AppDelegate.swift`
- [x] Remove storyboards: `Main.storyboard`, `LaunchScreen.storyboard`
- [x] Create `App/WarSignalApp.swift` with `@main` SwiftUI entry point
- [x] Create `UI/ContentView.swift` with navigation structure
- [x] Create `Game/GameView.swift` with `RealityView`
- [x] Configure Info.plist for landscape-only orientation
- [x] Builds and runs empty scene in Simulator

---

### WS-002: Implement GameCoordinator

**Priority**: P0 — Blocker
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-001

**Acceptance Criteria**:
- [x] `GameCoordinator` is `@Observable` class
- [x] `GameCoordinator` is `@MainActor` isolated
- [x] Exposes game state properties for HUD binding
- [x] Handles input dispatch (aim position, fire commands)
- [x] Manages game lifecycle (start, pause, end)
- [x] Injected into SwiftUI environment (EnvironmentKey added)

**Additional Features**:
- GamePhase enum for state machine
- Per-frame update() with delta time
- WeaponType with all properties (damage, fireRate, splash, heat, speed)
- Ammo tracking per weapon
- Mission timer countdown
- Heat/overheat system
- Scoring and kill tracking

---

### WS-003: Camera System

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-001

**Implementation**:
- Created `CameraController.swift` with PerspectiveCameraComponent
- 3 zoom levels: Close (15m, 55°), Medium (25m, 50°), Far (40m, 45°)
- Smooth position interpolation with configurable smoothing factor
- Camera shake system with weapon-specific presets
- Added zoom button to HUD (cycles through levels)
- Added multiple test targets at different positions

**Acceptance Criteria**:
- [x] Overhead angled camera (45-60 degrees)
- [x] Smooth follow/pan behavior
- [x] At least 2 zoom levels (3 implemented)
- [x] Camera shake on heavy weapon fire (stub ok)
- [x] Stable framerate in Simulator

---

### WS-004: Touch Aiming + Reticle

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-001, WS-003

**Implementation**:
- Created `ReticleController.swift` with 3D reticle entity
- Reticle has outer ring, inner ring (pulsing), center dot, and crosshairs
- Cyan color for normal, red for valid target
- Pulse and rotation animations
- Screen-to-world conversion with zoom-level adjustment
- Reticle shows on touch, hides on release
- Uses UnlitMaterial for consistent visibility

**Acceptance Criteria**:
- [x] Touch input converts to world position (simplified projection, zoom-aware)
- [x] Reticle entity follows intersection point on ground
- [x] Visual feedback on valid target area (color change support)
- [x] Debug visualization toggle available (via showDebugOverlay)
- [x] Works correctly in landscape orientation

---

### WS-017: Full-Screen Rendering Issue

**Priority**: P0 — Blocker
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-001
**Type**: Bug

**Description**: App was running in iOS compatibility/letterbox mode with black bars on sides. The x2 button appeared in Simulator toolbar, indicating scaled rendering mode.

**Root Cause**: Missing `INFOPLIST_KEY_UILaunchScreen_Generation = YES` in project.pbxproj build settings. Without this, iOS assumes the app doesn't support modern screen sizes.

**Fix Applied**:
1. Added `INFOPLIST_KEY_UILaunchScreen_Generation = YES` to both Debug and Release configurations
2. Refactored GameSceneView to use UIViewControllerRepresentable for proper ARView lifecycle
3. Added proper status bar and home indicator hiding

**Acceptance Criteria**:
- [x] No x2 button in Simulator
- [x] No black bars on screen edges
- [x] ARView fills entire screen
- [x] Works in landscape orientation
- [x] Status bar hidden during gameplay

---

### WS-005: Autocannon Weapon

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-004, WS-017

**Implementation**:
- Created `WeaponSystem.swift` for weapon firing logic
- Created `ProjectilePool.swift` with object pooling (60 autocannon, 15 rockets, 30 heavy)
- Cylinder mesh for tracer visual (RealityKit lacks capsule mesh)
- Emissive UnlitMaterial for glowing tracer effect
- Muzzle flash effect on fire
- Impact spark pool for hit effects
- Fire rate controlled per weapon type (autocannon: 12 rounds/sec)
- Continuous fire on hold via `isFiring` state
- Camera shake triggered on fire

**Acceptance Criteria**:
- [x] Tap/hold to fire behavior
- [x] Projectile pooling implemented (mandatory)
- [x] Tracer visual effect (cylinder mesh with emissive material)
- [x] Hit spark on impact
- [x] Audio: gunshot SFX plays on fire (via WS-007)
- [x] Reasonable fire rate (~10-15 rounds/sec)

---

### WS-006: Basic Enemy Target

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-005

**Implementation**:
- Created `Components/HealthComponent.swift` — reusable health tracking component
- Created `EnemySystem.swift` — manages enemy spawning, damage, and destruction
- `Team` enum for damage filtering (player/enemy/neutral)
- `EnemyConfig` struct for enemy type definitions (basicTarget, armoredTarget)
- In-flight projectile hit detection via position checks
- Destruction effect: orange sphere that expands and fades
- Respawn queue with configurable delay per enemy type
- Hit pulse effect (scale animation) on non-fatal damage
- 6 test enemies spawned at various positions
- Score awarded on kill (100 basic, 250 armored)

**Acceptance Criteria**:
- [x] Spawn static target entity (placeholder geometry ok)
- [x] HealthComponent attached
- [x] Takes damage from projectile hits
- [x] Destruction effect (simple scale/fade)
- [x] Respawns after delay for testing

---

### WS-007: Audio System Foundation

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-001

**Implementation**:
- Created `AudioSystem.swift` using AVAudioEngine
- SFX player pool (16 concurrent sounds)
- Dedicated ambient player with looping support
- Synthesized placeholder sounds for all effects:
  - Weapon sounds: autocannon, rocket, heavy gun, EMP
  - Impact sounds: small, large, explosion
  - UI sounds: click, confirm
  - Ambient: city, engine
- Volume control: master, SFX, ambient
- Volume presets: full, reduced, sfxOnly, muted
- Integrated with WeaponSystem (fire sounds, impact, explosion)
- Ambient starts on mission start, stops on mission end

**Acceptance Criteria**:
- [x] AVAudioEngine initialized at launch
- [x] One-shot SFX playback working (gunshot)
- [x] Ambient loop support (engine hum)
- [x] Volume categories defined (SFX, Ambient)
- [x] No audio glitches or pops

---

## Economy & Progression Tasks (Phase 2-5)

### WS-031: Final Economy JSON — Gemini Deliverable

**Priority**: P1 — High
**Status**: 🔴 NOT STARTED
**Type**: Design (Gemini → Codex schema → Claude Code implements)
**Milestone**: Phase 2.1 / Phase 5.1
**Depends On**: Economy decisions locked (DONE)

**Description**: Gemini must produce the final economy.json with:
- Adjusted credit rewards (~10% lower than Grok's formula) to hit 90% unlock at 2★ average
- S-curve cost tiers for all 45+ upgrade paths
- Full 10-row level reward table (base, secondaries, first-clear, star totals, cumulative)
- NG+ reward modifiers

**Acceptance Criteria**:
- [ ] 2★ average total income = ~35,800 Credits (90% of 39,800)
- [ ] 1★ average = ~30,000 (75% — core tree)
- [ ] 3★ average = ~44,000 (110% — full tree + surplus)
- [ ] S-curve costs applied to all upgrade trees
- [ ] Reaper max-damage affordable at Level 5 cumulative (~10K)
- [ ] JSON schema validated by Codex ConfigLoader

---

### WS-032: Economy Simulation Validation — Gemini CLI

**Priority**: P2 — Medium
**Status**: 🔴 NOT STARTED
**Type**: QA (Gemini CLI)
**Milestone**: Phase 5 Gate
**Depends On**: WS-031

**Description**: Gemini CLI runs economy simulations through 3 player paths:
1. **Optimal path**: Reaper > Ground > Vulcan sustain (smart player)
2. **Average path**: Balanced spending, some waste
3. **Trap path**: Over-invest defenses early, ignore Reaper

All paths must be completable without grinding. Trap path should be uncomfortable but not a hard wall.

**Acceptance Criteria**:
- [ ] Optimal path: 95%+ tree, Reaper breakpoint by Level 5
- [ ] Average path: 85-90% tree, campaign completable
- [ ] Trap path: 70-80% tree, campaign still completable (harder)
- [ ] No level requires grinding previous levels to proceed
- [ ] NG+ economy funds remaining 10% within 3-5 replayed levels

---

### WS-033: NG+ System Design

**Priority**: P3 — Low
**Status**: 🔴 NOT STARTED
**Type**: Design + Implementation
**Milestone**: Phase 5.3
**Depends On**: WS-031

**Description**: New Game+ implementation per locked design:
- Keep all upgrades and credits from first run
- Enemies: +15% HP, increased density, new spawn patterns
- Rewards: +20% credit multiplier
- New secondary objectives per level
- No HP sponge mode — scale density and variety

**Acceptance Criteria**:
- [ ] NG+ flag in save data
- [ ] All upgrades persist across NG+ transition
- [ ] Enemy density/HP modifiers applied
- [ ] Reward multiplier active
- [ ] At least 1 new secondary objective per level in NG+

---

## Backlog (Future Milestones)

### WS-008: HUD Overlay Polish

**Priority**: P2 — Medium
**Status**: ✅ COMPLETE
**Completed**: 2026-02-03
**Milestone**: M2

**Implementation**:
- iOS 26 liquid glass effect (`.glassEffect()`) on all HUD panels
- Cyberpunk gradient borders (cyan/purple, orange/yellow)
- Enhanced HUDBar with segment markers and glow effects
- Low-health/shield warning indicators with pulsing glow
- Heat gauge with gradient fill and threshold marker at 70%
- Weapon-specific color coding (hudColor property on WeaponType)
- Fire button dynamically updates to match selected weapon
- Weapon selector with selection animation and glow
- Score display with gold gradient text
- Timer warning state (red + glow under 30 seconds)
- Unlimited ammo displayed as ∞ for autocannon

**Acceptance Criteria**:
- [x] Health display with low-health warning
- [x] Shield display with depleted warning
- [x] Ammo/heat display with gradient fills
- [x] Weapon selector with visual feedback
- [x] Mission timer with warning state
- [x] Cyberpunk/liquid glass aesthetic

---

### WS-009: Rocket Weapon

**Priority**: P2 — Medium
**Status**: ✅ COMPLETE
**Completed**: 2026-02-03
**Milestone**: M2

**Implementation**:
- Rocket projectile pool (15 capacity, larger/slower than autocannon)
- Splash damage radius (3.0 units) configured in WeaponType
- Explosion effect pool (8 effects) with expanding animation
- Distinct orange rocket visual with higher emissive intensity
- Rocket fire sound via AudioSystem
- Explosion sound on impact
- Splash damage hits multiple enemies in radius

**Acceptance Criteria**:
- [x] Slower projectile travel (20 vs 50 speed)
- [x] Splash damage radius (3.0 units)
- [x] Explosion effect (expanding orange sphere)
- [x] Distinct audio from autocannon

---

### WS-010: Infantry Enemy

**Priority**: P2 — Medium
**Status**: ✅ COMPLETE
**Completed**: 2026-02-03
**Milestone**: M2

**Implementation**:
- MovementConfig struct for mobile enemy settings
- Infantry enemy config (15 HP, 50 score, fast respawn)
- EnemyMovementData tracking per enemy (state, target, timer)
- AIState enum (wandering, seeking)
- Seeking behavior toward objective position
- Deals damage to player when reaching objective
- Movement speed: 2.0 (wander) / 3.0 (seek)
- Taller/thinner visual shape for infantry
- 5 infantry spawned initially
- Movement data preserved through respawn

**Acceptance Criteria**:
- [x] Wander/seek behavior (AI state machine)
- [x] Seek objective movement
- [x] Low HP (15 - ~2 autocannon hits)
- [x] Damage player on reaching objective

---

### WS-011: Drone Enemy

**Priority**: P3 — Low
**Status**: ✅ COMPLETE
**Completed**: 2026-02-03
**Milestone**: M2

**Implementation**:
- Drone config: 10 HP (1-hit from most weapons), 75 score
- Flying movement with height maintenance
- Erratic flight pattern via noise factor (0.7)
- Fast speed (6.0 wander, 4.0 seek)
- Wandering AI state with random target points
- Cylinder/disc mesh for saucer shape
- Attacks player (8 damage, 3 sec interval)
- 3 drones spawned initially at varying heights
- Respawns with flying movement preserved

**Acceptance Criteria**:
- [x] Fast movement (6.0 speed)
- [x] Fragile (10 HP - 1 autocannon hit)
- [x] Erratic flight pattern (noise-based wandering)
- [x] Can damage player ship (8 damage)

---

### WS-012: Ship Shield System

**Priority**: P2 — Medium
**Status**: ✅ COMPLETE
**Completed**: 2026-02-03
**Milestone**: M2

**Implementation**:
- Shield regeneration system (10 HP/sec after 3 sec delay)
- Damage cooldown tracking (`timeSinceLastDamage`)
- Visual damage flash overlay (red radial gradient)
- Low health vignette with pulsing effect
- Camera shake on damage
- Sound effects for shield/hull damage
- Turret enemy type that attacks player
- Enemy attack system with muzzle flash effects
- Attack timers per enemy
- Respawn preserves enemy attack capability

**Acceptance Criteria**:
- [x] Shield HP separate from hull HP
- [x] Shield recharges over time (after 3 sec delay)
- [x] Visual damage feedback (flash + vignette)
- [x] Camera shake on damage
- [x] Enemies can attack player

---

### WS-013: Collision Groups Definition

**Priority**: P1 — High
**Status**: ✅ COMPLETE
**Completed**: 2025-02-03
**Depends On**: WS-001

**Implementation**:
- Created `CollisionGroups.swift` with all required groups
- Groups: default, player, playerProjectile, enemy, enemyProjectile, terrain, pickup, explosionArea
- Collision masks for proper filtering (playerProjectile hits enemy/terrain, etc.)
- Filter presets for easy component setup

**Acceptance Criteria**:
- [x] `CollisionGroups.swift` created
- [x] Groups defined: player, enemy, projectile, terrain, pickup
- [x] Collision masks configured correctly
- [x] Documented in code comments

---

## Completed

_None yet — project starting._

---

## Notes

- All P0 items block milestone completion
- Update this file when discovering new tasks during implementation
- Move to archive when exceeding 200 lines
