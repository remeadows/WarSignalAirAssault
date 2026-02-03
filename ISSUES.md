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

## Active Sprint (Milestone 1)

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

## Backlog (Future Milestones)

### WS-008: HUD Overlay

**Priority**: P2 — Medium
**Milestone**: M1/M2

- Health display
- Ammo/heat display
- Weapon selector
- Mission timer
- Pause button

---

### WS-009: Rocket Weapon

**Priority**: P2 — Medium
**Milestone**: M2

- Slower projectile travel
- Splash damage radius
- Explosion effect
- Distinct audio from autocannon

---

### WS-010: Infantry Enemy

**Priority**: P2 — Medium
**Milestone**: M2

- Wander behavior (simple state machine)
- Seek objective movement
- Low HP (~1-2 autocannon hits)
- Death animation (ragdoll or fade)

---

### WS-011: Drone Enemy

**Priority**: P3 — Low
**Milestone**: M2

- Fast movement
- Fragile (1 hit)
- Erratic flight pattern
- Can damage player ship

---

### WS-012: Ship Shield System

**Priority**: P2 — Medium
**Milestone**: M2

- Shield HP separate from hull HP
- Shield recharges over time
- Visual shield effect
- Shield break feedback

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
