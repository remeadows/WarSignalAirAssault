# CLAUDE.md — WarSignal Operating Rules

## Quick Context (30-Second Read)

**Project**: WarSignal — iOS cyberpunk gunship/overwatch action game
**Genre**: Top-down shooter (Zombie Gunship / Goliath style) with ship defense
**Setting**: "Sin City Cyberpunk" — neon desert, casinos, slums, megacorp zones
**Engine**: RealityKit with SwiftUI RealityView
**Target**: iOS 26.x, iPhone-first, **landscape-only**
**Architecture**: SwiftUI shell + GameCoordinator (@Observable) + ECS-inspired systems

---

## Mandatory Document Review Order

Before writing or changing any code, review these files:

1. **CLAUDE.md** (this file) — Operating rules, quick reference
2. **CONTEXT.md** — Vision, architecture, constraints (source of truth)
3. **PROJECT_STATUS.md** — Current milestone, progress, risks
4. **ISSUES.md** — Backlog with acceptance criteria
5. **AGENTS.md** — Agent roles and authority hierarchy
6. **GO.md** — Immediate next actions

**Rule**: If any doc is missing or conflicts with another, resolve in CONTEXT.md first.

---

## Engine Decision (LOCKED)

| Choice | Value |
|--------|-------|
| 3D Engine | **RealityKit** |
| Integration | SwiftUI `RealityView` |
| Physics | RealityKit PhysicsBodyComponent + CollisionComponent |
| Raycasting | RealityKit scene raycasts |

**NOT**: SceneKit, SpriteKit, Metal (unless perf demands later)

**Rationale**: Modern API, strong SwiftUI integration, entity-component architecture, active Apple development.

---

## Architecture Rules

1. **SwiftUI** owns all UI (menus, HUD, navigation)
2. **RealityView** hosts the 3D game scene
3. **GameCoordinator** bridges UI ↔ Game (`@Observable`, `@MainActor`)
4. **ECS-inspired** organization:
   - Components: Health, Team, Weapon, Movement, Targetable, AIState
   - Systems: WeaponSystem, ProjectileSystem, CollisionSystem, AISystem, AudioSystem
5. **No massive view controllers** — keep views small and testable
6. **Projectile pooling is MANDATORY**

---

## Orientation & Display

- **Landscape-only** (horizontal phone position)
- Lock in Info.plist:
  ```
  UISupportedInterfaceOrientations = [UIInterfaceOrientationLandscapeLeft, UIInterfaceOrientationLandscapeRight]
  ```
- No portrait support
- Status bar hidden during gameplay

### Full-Screen Rendering (CRITICAL)

To avoid iOS compatibility/letterbox mode (indicated by x2 button in Simulator), the project MUST have:

```
// In project.pbxproj Build Settings (both Debug and Release):
INFOPLIST_KEY_UILaunchScreen_Generation = YES;
```

**Why**: Without this, iOS assumes the app doesn't support modern screen sizes and runs it in scaled compatibility mode with black bars.

**Symptoms of missing setting**:
- x2 button appears in Simulator toolbar
- Black bars on sides of screen
- `ignoresSafeArea()` has no effect
- ARView/RealityView doesn't fill screen

---

## Code Standards

### SwiftUI (iOS 26+)
- Use `@Observable` over `ObservableObject`
- Mark `@Observable` classes with `@MainActor`
- Use `@State` with `@Observable` (not `@StateObject`)
- Modern APIs required:
  - `foregroundStyle()` not `foregroundColor()`
  - `clipShape(.rect(cornerRadius:))` not `cornerRadius()`
  - `NavigationStack` not `NavigationView`
  - `Button` not `onTapGesture()` for tappable elements

### Liquid Glass (iOS 26+)
- Use `.glassEffect()` for cyberpunk UI aesthetic
- Always provide fallback: `.background(.ultraThinMaterial)`
- Apply after layout/appearance modifiers

### General
- Small, runnable commits
- Update docs in same session as code changes
- Comments only where useful; prefer readable naming

---

## Definition of Done

- [ ] Builds in iOS Simulator
- [ ] Feature tested manually
- [ ] PROJECT_STATUS.md updated with progress
- [ ] ISSUES.md updated if new tasks/bugs discovered

---

## Non-Goals (Do Not Implement)

- Multiplayer / PvP
- AR features
- Open world
- Cinematic cutscenes
- Realistic flight simulation
- Online services in v1

---

## Document Update Protocol

When making architecture decisions:
1. Update **CONTEXT.md** with decision + rationale
2. Record in **PROJECT_STATUS.md** progress/decision log
3. Add any new tasks to **ISSUES.md**

When closing a milestone:
1. Update **PROJECT_STATUS.md** status
2. Move completed issues to archive if ISSUES.md > 200 lines
3. Update **GO.md** with next milestone actions

---

## Characters (Mission Briefings / Intel)

| Character | Asset |
|-----------|-------|
| Helix | Helix_The_Light.png, Helixv2.png |
| Malus | Malus.png |
| FL3X | FL3X_v1.png |
| Tish | Tish3.jpg |
| VEXIS | VEXIS.png, VEXIS.jpg |
| KRON | KRON.jpg |
| AXIOM | AXIOM.jpg |
| ZERO | ZERO.jpg |
| Ronin | Ronin.jpg |
| Rusty | Rusty.jpg |
| The Architect | The Architect.png |
| Tee | Tee_v1.png |

Assets in: `/AppPhoto/`

---

## Guiding Principle

> **If it isn't playable, it isn't real.**

Build the fun first. Ship vertical slices. Everything else is negotiable.
