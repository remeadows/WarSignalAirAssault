# GO.md — WarSignal

## Read First: Project Context (Required)

Before writing or changing any code, review these files in this order:

1. **CLAUDE.md** — Claude Code operating rules (quick reference)
2. **CONTEXT.md** — vision + architecture + non-goals (source of truth)
3. **PROJECT_STATUS.md** — current milestone + risks + progress log
4. **ISSUES.md** — backlog, active bugs, acceptance criteria
5. **AGENTS.md** — agent roles, authority, workflow rules

**Rule**: If any of these files are missing or outdated, update them before implementing new features.

---

## Current Status

**Milestone 1: COMPLETE** ✅

All vertical slice foundation tasks finished. Ready for Milestone 2.

---

## Where We Left Off (2025-02-03)

### Session Summary:
- Fixed full-screen rendering issue (WS-017) — added `INFOPLIST_KEY_UILaunchScreen_Generation`
- Implemented autocannon weapon with projectile pooling (WS-005)
- Implemented enemy targets with health/damage system (WS-006)
- Implemented audio system with AVAudioEngine (WS-007)
- Fixed audio crash (format mismatch — mono vs stereo channels)
- All Milestone 1 tasks complete

### Last Working State:
- Build succeeds on iPhone 17 Pro Max Simulator
- Game launches full-screen in landscape
- Touch aiming with reticle works
- Fire button triggers autocannon
- Projectiles travel and hit enemies
- Enemies take damage, show hit pulse, explode on death
- Enemies respawn after delay
- Audio plays (weapon fire, impacts, explosions, ambient)
- Score increments on kills

---

## Immediate Next Actions (Milestone 2)

### When Starting Next Session:

1. **Build & Run** — Confirm everything still works
2. **Review PROJECT_STATUS.md** — Check milestone 2 scope
3. **Pick first M2 task** — Recommended: WS-008 (HUD Overlay polish)

### Milestone 2 Tasks (Combat Loop):

| ID | Task | Priority | Status |
|----|------|----------|--------|
| WS-008 | HUD Overlay polish | P2 | Not Started |
| WS-009 | Rocket Weapon | P2 | Not Started |
| WS-010 | Infantry Enemy | P2 | Not Started |
| WS-011 | Drone Enemy | P3 | Not Started |
| WS-012 | Ship Shield System | P2 | Not Started |

### Recommended Order:
1. WS-008 — HUD (health, ammo, heat display)
2. WS-012 — Ship Shield System (player can take damage)
3. WS-009 — Rocket Weapon (splash damage)
4. WS-010 — Infantry Enemy (moving targets)
5. WS-011 — Drone Enemy (aerial threat)

---

## Exit Criteria (Milestone 1) — ALL COMPLETE ✅

- [x] Builds and runs in iOS Simulator (landscape)
- [x] Aim reticle moves correctly on touch
- [x] Autocannon fires pooled projectiles
- [x] Hits apply damage to a target dummy
- [x] SFX plays reliably
- [x] Docs updated:
  - [x] PROJECT_STATUS.md updated with progress + decisions
  - [x] ISSUES.md updated with new tasks/bugs

---

## Operating Rules

- Small commits, always runnable
- No architecture drift (update CONTEXT.md if changes required)
- After each work session: update PROJECT_STATUS.md with what changed + what's next
- Landscape-only — no portrait support

---

## Key Files Created This Session

| File | Purpose |
|------|---------|
| `Game/CollisionGroups.swift` | Collision filtering for physics |
| `Game/ProjectilePool.swift` | Object pooling for projectiles |
| `Game/WeaponSystem.swift` | Weapon firing and effects |
| `Game/Components/HealthComponent.swift` | Health tracking |
| `Game/EnemySystem.swift` | Enemy spawning and damage |
| `Game/AudioSystem.swift` | AVAudioEngine audio playback |

---

## Commit Instructions

See **COMMIT.md** for full commit/push workflow.

**Quick summary:**
1. Stage all changes: `git add .`
2. Commit: `[M1] Complete Milestone 1 - Vertical Slice Foundation`
3. Push: `git push origin main`
4. Remote: https://github.com/remeadows/WarSignal
