# GROK ECONOMY INQUIRY PROMPT
**Purpose:** Feed this prompt to Grok (xAI) to get a deep economy and monetization analysis for WarSignal.
**When:** Phase 0B, before economy JSON is finalized.

---

## THE PROMPT (copy everything below the line)

---

You are an economy designer and monetization strategist for mobile games. I need a comprehensive analysis and recommendation for the economy of **WarSignal**, a premium iOS gunship game.

### Game Context

**WarSignal** is a top-down AC-130 gunship combat game for iOS (landscape, iPhone-first). The player orbits a cyberpunk megacity battlefield from above, delivering precision ordnance to protect ground forces. Think "Call of Duty 4 Death From Above" meets "Sin City cyberpunk noir."

**Engine:** RealityKit + SwiftUI (iOS 26+)
**Monetization:** Premium — $4.99 to $9.99 upfront. **No IAP. No ads. No energy timers. No dual currency.** Single-currency finite economy. This is our core differentiation from the competition.

**Campaign:** 10 levels, estimated 2-4 hours total playtime, with replay value via star ratings and New Game+.

### Weapons (3 + 1 unlock)

| Weapon | Slot | Identity | Proposed Base DPS | Fire Rate |
|--------|------|----------|-------------------|-----------|
| **Vulcan** | Primary (ALPHA) | 20mm rapid-fire gatling | 120 DPS (10 dmg × 12 rps) | 12 rounds/sec |
| **Havoc** | Secondary (BRAVO) | Guided rockets, splash damage | 33.3 DPS (50 dmg / 1.5s cycle) | 1 per 1.5s |
| **Reaper** | Heavy | Heavy ordnance, max single-target | 40 DPS (160 dmg / 4.0s cycle) | 1 per 4.0s |
| **TBD** | Unlock (endgame) | Area-denial EMP/smart bomb | TBD | TBD |

Each weapon has 3 upgrade categories with 4-5 tiers each. Upgrade examples:
- Vulcan: Ammo Capacity, Damage, Overheat Tolerance
- Havoc: Ammo Capacity, Splash Radius, Reload Speed
- Reaper: Ammo Capacity, Damage, Tracking (unlock)

### Ship Defense Upgrades

| System | Tiers | Function |
|--------|-------|----------|
| Hull HP | 5 | Raw survivability |
| Flares | 4 | Missile countermeasure charges |
| Flare Recharge | 4 | Faster flare regen |
| ECM | 4 | Passive damage reduction |
| Hull Repair | 1 (unlock) | Slow in-mission HP regen |

### Ground Team Upgrades

| System | Tiers | Function |
|--------|-------|----------|
| Armor | 5 | Ground team survivability |
| Weapons | 4 | Ground team damage output |
| Medic | 5 | Ground team self-heal |
| Recon Drone | 1 (unlock) | Enemy spotting radius |
| APC | 1 (unlock) | Ground team transport/armor |

### Enemy Types (11 planned)

| Type | Class | Estimated HP | Behavior |
|------|-------|-------------|----------|
| Militia | Infantry | 10 | Swarm, rush objective |
| Soldier | Infantry | 25 | Organized, takes cover |
| Heavy Trooper | Infantry | 50 | Slow, high damage |
| Technical | Light Vehicle | 60 | Fast, mounted gun |
| APC | Armored Vehicle | 120 | Troop carrier, tough |
| Tank | Heavy Armor | 200 | Slow, devastating, bullet-resistant |
| AA Turret | Stationary | 150 | Attacks player ship |
| SAM Site | Stationary | 180 | Missile lock on player |
| Drone Swarm | Air | 15 each | Fast, fragile, overwhelming |
| RPG Trooper | Infantry | 35 | Anti-air, targets player |
| Boss Unit | Special | 500+ | Multi-phase, scripted |

### The Economy Problem (from our initial analysis)

An earlier analysis calculated:
- **Total upgrade cost across all systems:** ~39,800 Credits
- **Total campaign income (10 levels, perfect play):** ~13,500 Credits
- **Deficit:** ~26,300 Credits (player can only unlock ~34% of the tech tree)

Proposed fixes from that analysis:
1. Triple base rewards (Level 1 base: 500 → 1,500)
2. Add +200 per level scaling (Level 10 base: 3,300)
3. First-time completion bonus: 1,000 Credits per level
4. Reduce utility upgrade costs by 30%
5. **Projected fixed income:** ~35,000 Credits (allows ~85% tech tree unlock)

### The Star Rating System

| Rating | Name | Criteria | Reward Multiplier |
|--------|------|----------|-------------------|
| 1 Star | Survivor | Mission complete | 1.0x |
| 2 Stars | Operator | Complete + time limit OR >50% ground team health | 1.2x |
| 3 Stars | Ace | Complete + all secondary objectives | 1.5x |

### Competitive Context

Our direct competitor is **Goliath** (SHD Games, Unity, iOS+Android):
- Free-to-play with fuel/energy timer (~11 plays per cycle)
- Triple currency (Credits, Gems, Red Diamonds)
- Prestige system (8+ resets)
- $9.99 Premium IAP removes fuel cap
- 4.7 stars iOS, 30K+ ratings
- Save-data corruption is their #1 community complaint
- Deep progression keeps players for 100+ hours
- **No narrative, no characters, no emotional stakes** — pure arcade grinder

WarSignal's positioning: **"Premium tactical. Pay once, play forever. No BS."**

### What I Need From You

Analyze the following and provide concrete, numbered recommendations:

1. **Price Point Analysis:** Is $4.99 or $9.99 the right price for 10 levels / 2-4 hours of premium content with replay value? What does the iOS premium action game market support? Consider comparable premium mobile games (Dead Cells, Hades, Oddmar, Alto's Odyssey, etc).

2. **Economy Curve Validation:** Given the proposed fix (35K income vs 39.8K cost = 85% unlock), is 85% the right target? Should a premium player be able to unlock everything in one playthrough? Or should the remaining 15% drive New Game+ replay?

3. **Difficulty-Economy Coupling:** The earlier analysis proposed this difficulty arc:
   - Levels 1-3: Player feels overpowered (low enemy density, high "popcorn" kills)
   - Levels 4-6: "The Crunch" — armor introduced, Vulcan stops being universal solver, player MUST upgrade Reaper
   - Levels 7-9: High density + SAM priority targets, forces weapon switching
   - Level 10: Boss + bullet hell climax

   Does this feel right for a premium game? Where should the player feel the most upgrade pressure? Where should they feel the most power fantasy payoff?

4. **Upgrade Priority Path:** Given the numbers above, what's the optimal upgrade path a smart player follows? What's the "trap" path where a player over-invests in the wrong system and hits a wall? Design the economy so the trap path is recoverable without grinding.

5. **New Game+ Economy:** If a player finishes with ~85% upgrades and replays on NG+, what changes? Do enemies scale? Does the player keep all upgrades? Do they earn more credits? How do you make NG+ feel fresh without just being "HP sponge mode"?

6. **The "Reaper Breakpoint":** The earlier analysis identified that upgrading the Reaper from 2-shot tanks (base: 160 dmg, 8 second cycle) to 1-shot tanks (max: 224 dmg, single shot) is the key power fantasy moment. When in the campaign should this happen? How do we engineer the economy so this upgrade is affordable at exactly the right moment (Level 5-6)?

7. **Credit Reward Pacing — Level by Level:** Give me a proposed credit reward table for all 10 levels:
   - Base reward
   - Secondary objective bonus (3 per level)
   - First-clear bonus
   - 1-star / 2-star / 3-star total
   - Cumulative total after each level (assuming 2-star average)

8. **Upgrade Cost Curve:** Should upgrade costs be linear, exponential, or S-curve? What's the feel difference? Propose a specific cost curve for the Vulcan's 5 damage upgrade tiers as an example.

9. **Premium Game "Generosity Budget":** Premium games need to feel generous — the player already paid. Where should we be deliberately generous (more credits than needed, free unlocks, bonus rewards) and where should we create meaningful scarcity (tough choices between upgrades)?

10. **Risk Analysis:** What are the top 3 economy risks for a premium gunship game with finite content? How do we mitigate each?

### Format Requirements

- Use tables where possible
- Show your math
- Reference specific level numbers and enemy types
- If you disagree with the earlier analysis, say so directly and explain why
- Provide a single "Recommended Economy Sheet" summary table at the end

---

*End of prompt.*
