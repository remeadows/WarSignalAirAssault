# WarSignal

**iOS Cyberpunk Gunship Action Game**

A top-down shooter inspired by Zombie Gunship and Goliath, set in a "Sin City Cyberpunk" megasprawl. Operate an airborne overwatch platform delivering precision fire from above.

---

## Screenshots

*Coming soon*

---

## Features

### Implemented (Milestone 2 Complete)
- Top-down 3D combat with RealityKit
- Goliath-style tactical reticle (corner brackets, compass rose)
- 4 weapon types (Autocannon, Rockets, Heavy Gun, EMP)
- 5 enemy types (Basic, Armored, Turret, Infantry, Drone)
- Ship defense with shield regeneration
- Cyberpunk HUD with iOS 26 Liquid Glass effects
- Projectile pooling for performance
- Camera zoom levels with shake effects
- Synthesized audio system

### In Development (Milestone 3)
- AC-130 camera drift effect
- Thermal/infrared vision mode
- ALPHA/BRAVO dual trigger system
- Support unit deployment
- Multi-tier mission objectives
- Enemy visual upgrades

---

## Requirements

- **iOS 26.0+**
- **Xcode 16+**
- iPhone (landscape orientation only)

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| UI | SwiftUI |
| 3D Engine | RealityKit |
| Integration | RealityView |
| Audio | AVAudioEngine |
| Architecture | ECS-inspired (lightweight) |

---

## Project Structure

```
WarSignal/
├── App/
│   └── WarSignalApp.swift      # @main entry point
├── UI/
│   ├── ContentView.swift       # Navigation
│   └── MainMenuView.swift      # Main menu
├── Game/
│   ├── GameView.swift          # RealityView + HUD
│   ├── GameCoordinator.swift   # State bridge (@Observable)
│   ├── CameraController.swift  # Camera system
│   ├── ReticleController.swift # Targeting reticle
│   ├── WeaponSystem.swift      # Weapons + projectiles
│   ├── EnemySystem.swift       # Enemy management
│   ├── AudioSystem.swift       # Sound effects
│   └── ProjectilePool.swift    # Object pooling
├── Components/
│   ├── HealthComponent.swift   # Health tracking
│   └── CollisionGroups.swift   # Collision categories
└── Docs/
    ├── CLAUDE.md               # AI operating rules
    ├── CONTEXT.md              # Vision & architecture
    ├── PROJECT_STATUS.md       # Progress tracking
    ├── ISSUES.md               # Backlog
    └── GO.md                   # Quick start
```

---

## Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/remeadows/WarSignal.git
   ```

2. Open in Xcode
   ```bash
   cd WarSignal
   open WarSignal.xcodeproj
   ```

3. Select iPhone 17 Pro Max Simulator

4. Build and Run (Cmd+R)

---

## Documentation

| Document | Purpose |
|----------|---------|
| [CLAUDE.md](CLAUDE.md) | AI assistant operating rules |
| [CONTEXT.md](CONTEXT.md) | Vision, architecture, constraints |
| [PROJECT_STATUS.md](PROJECT_STATUS.md) | Milestone progress |
| [ISSUES.md](ISSUES.md) | Task backlog |
| [GO.md](GO.md) | Quick start for new sessions |

---

## Inspiration

- **Goliath** — AC-130 gunship tactical shooter
- **Zombie Gunship** — Classic iOS aerial shooter
- **War Drone** — Modern overwatch gameplay

---

## Setting

**Sin City Cyberpunk** — A neon-soaked desert megasprawl featuring:
- Corrupted casinos
- Slum outskirts
- Megacorp infrastructure
- Militarized zones
- Data centers and power grids

---

## Roadmap

### Milestone 1 ✅ Complete
- Project setup, SwiftUI + RealityKit integration

### Milestone 2 ✅ Complete
- Combat loop: weapons, enemies, HUD, audio

### Milestone 3 🔄 In Progress
- Goliath-inspired polish
- Thermal vision
- AC-130 camera drift
- Mission objectives

### Milestone 4 📋 Planned
- Mission select
- Progression system
- Currency and unlocks

---

## License

*TBD*

---

## Author

Russ Meadows

---

> **"If it isn't playable, it isn't real."**
