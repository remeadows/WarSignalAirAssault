# COMMIT.md — WarSignal Commit Instructions

## Purpose

This file provides instructions for committing and pushing changes to the WarSignal repository at the end of a development session.

---

## Pre-Commit Checklist

Before committing, ensure:

1. **Build Succeeds**: Run `xcodebuild` or build in Xcode
2. **PROJECT_STATUS.md Updated**: Current milestone progress documented
3. **ISSUES.md Updated**: Task statuses reflect completed work
4. **GO.md Updated**: Next actions clearly defined for next session
5. **No Sensitive Data**: No API keys, credentials, or personal info

---

## Commit Process

### 1. Update Project Documentation

Before committing, update these files:

| File | Update With |
|------|-------------|
| `PROJECT_STATUS.md` | Session log entry, milestone progress |
| `ISSUES.md` | Task status changes (Not Started → Complete) |
| `GO.md` | Next immediate actions for following session |

### 2. Stage Files

Using **GitHub Desktop** or command line:

```bash
cd /Users/russmeadows/Dev/Games/WarSignal
git add .
```

Or selectively add:
```bash
git add WarSignal/
git add *.md
```

### 3. Commit with Descriptive Message

Format: `[Milestone] Brief description`

Examples:
- `[M1] Complete audio system and milestone 1`
- `[M1] Add enemy system with damage detection`
- `[Fix] Resolve full-screen rendering issue`

### 4. Push to Main

```bash
git push origin main
```

Or use **GitHub Desktop** → Push origin

---

## Repository

**Remote**: https://github.com/remeadows/WarSignal
**Branch**: main

---

## Session Summary Template

When updating PROJECT_STATUS.md, use this format:

```markdown
### YYYY-MM-DD
- **Completed [ISSUE-ID]**: Brief description
  - Key implementation detail 1
  - Key implementation detail 2
- **Fixed [ISSUE-ID]**: Bug description and fix
- **Next**: What to work on next session
```

---

## Current Session (2025-02-03) — Ready to Commit

### Files Changed This Session:

**New Files Created:**
- `WarSignal/Game/CollisionGroups.swift` — Collision group definitions
- `WarSignal/Game/ProjectilePool.swift` — Projectile object pooling
- `WarSignal/Game/WeaponSystem.swift` — Weapon firing logic
- `WarSignal/Game/Components/HealthComponent.swift` — Health tracking component
- `WarSignal/Game/EnemySystem.swift` — Enemy management
- `WarSignal/Game/AudioSystem.swift` — Audio engine and SFX

**Modified Files:**
- `WarSignal/Game/GameCoordinator.swift` — Added weapon, enemy, audio systems
- `WarSignal/Game/GameSceneView.swift` — Integrated new systems, removed old test targets
- `CLAUDE.md` — Added full-screen rendering instructions
- `PROJECT_STATUS.md` — Updated milestone progress
- `ISSUES.md` — Updated task statuses
- `GO.md` — Updated next actions

### Suggested Commit Message:

```
[M1] Complete Milestone 1 - Vertical Slice Foundation

- WS-005: Autocannon weapon with projectile pooling
- WS-006: Enemy targets with health/damage system
- WS-007: Audio system with AVAudioEngine
- WS-013: Collision groups for physics filtering
- WS-017: Fixed full-screen rendering issue

Milestone 1 complete. Ready for Milestone 2 (Combat Loop).
```
