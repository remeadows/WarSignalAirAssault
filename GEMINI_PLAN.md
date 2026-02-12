Here is the response file as requested.

---

# GEMINI_PLAN.md

**To:** Claude Opus (Project Manager), WarSignalLabs

**From:** Gemini (Economy & Analytics Designer Candidate)

**Date:** October 26, 2025

**Subject:** Economy Balance & Progression Strategy for *WarSignal AirAssault*

## 1. The Economy Challenge: Premium vs. F2P

Designing a single-currency premium economy is fundamentally different from the F2P model used by competitors like *Goliath*.

* **Finite vs. Infinite:** F2P economies are designed to never end; they require exponential cost scaling to force monetization or ads. *WarSignal* is finite (10 levels). The economy must be tuned to provide a satisfying "Power Fantasy" arc that concludes at Level 10.
* **Pacing vs. Friction:** In F2P, friction (grinding) is a feature. In Premium, friction is a bug. If a player has to replay Level 3 five times just to afford a hull upgrade for Level 4, we have failed the "Premium" promise.
* **The "Golden Path":** We need to ensure that a player with average skill can afford 1-2 meaningful upgrades after *every* mission without grinding, reaching ~70-80% of the tech tree by the final boss. Currently, the numbers suggest they will hit a hard poverty wall.

---

## 2. Initial Economy Analysis

### The Cost vs. Earnings Gap

Based on the `GAME_DESIGN.md` values provided, here is the mathematical reality of the current draft.

#### **Total Upgrade Costs (The Sink)**

I have calculated the summation of all tiers for all categories:

| Category | Item | Calculation (Tiers) | Total Cost |
| --- | --- | --- | --- |
| **Weapons** | Vulcan | Ammo(1900) + Dmg(2400) + Overheat(1500) | 5,800 |
|  | Havoc | Ammo(2400) + Splash(1500) + Reload(1200) | 5,100 |
|  | Reaper | Ammo(3800) + Dmg(2300) + Tracking(2000) | 8,100 |
| **Defense** | Hull/Systems | HP(2400) + Flares(1500) + Rchrg(1800) + ECM(2300) + Repair(2000) | 10,000 |
| **Ground** | Squad | Armor(2400) + Rifle(1900) + Medic(3000) + Drone(1500) + Transport(2000) | 10,800 |
| **TOTAL** |  | **All Upgrades** | **39,800 Credits** |

#### **Total Earnings Potential (The Source)**

Assuming a linear progression where rewards increase slightly per level (estimating +10% base reward per level), and assuming the player completes 100% of secondary objectives (Perfect Play):

* **Level 1:** 500 Base + 600 (3x200 Secondaries) = 1,100
* **Level 10 (Est):** 1,000 Base + 600 Secondaries = 1,600
* **Average per Level:** ~1,350
* **Total Campaign Income:** **~13,500 Credits**

### **The Problem**

**Deficit:** 26,300 Credits.
**Unlock Rate:** ~34%.

A player completing the game with perfect scores will only be able to afford **one-third** of the available upgrades. They will likely feel underpowered by Level 6.

---

## 3. DPS & Time-To-Kill (TTK) Analysis

Since `GAME_DESIGN.md` provided qualitative damage values ("Low", "Medium"), I have assigned **Proposed Base Values** derived from Enemy HP to make this analysis quantifiable.

**Assumptions:**

* **Vulcan Base Dmg:** 10 (Kills Militia in 1 hit, Soldier in 3)
* **Havoc Base Dmg:** 50 (Near-kill Heavy, 2-shot APCs)
* **Reaper Base Dmg:** 160 (High enough to threaten Tanks)

### **Base Stats DPS**

| Weapon | Fire Rate / Reload | Base Dmg | DPS Calculation | **DPS** |
| --- | --- | --- | --- | --- |
| **Vulcan** | 12 rps | 10 |  | **120** |
| **Havoc** | 1.5s delay | 50 |  | **33.3** |
| **Reaper** | 4.0s delay | 160 |  | **40** |
| *Note: Havoc and Reaper DPS is misleading; they are burst/AoE weapons. Their value is Alpha Strike, not sustained fire.* |  |  |  |  |

### **Time-To-Kill (TTK) Matrix**

*How many seconds to kill an enemy?*

**At Base Level:**
| Enemy | HP | Vulcan (Base) | Havoc (Base) | Reaper (Base) |
| :--- | :--- | :--- | :--- | :--- |
| **Militia** | 10 | **Instant** (0.08s) | Instant (Overkill) | Instant (Waste) |
| **Soldier** | 25 | **0.25s** (3 shots) | Instant (1 shot) | Instant (Waste) |
| **Heavy** | 50 | **0.42s** (5 shots) | Instant (1 shot) | Instant (Waste) |
| **Technical**| 60 | 0.50s | 3.0s (2 shots) | Instant (1 shot) |
| **APC** | 120 | 1.0s | 4.5s (3 shots) | Instant (1 shot) |
| **Tank** | 200 | 1.6s (High Exposure) | 6.0s (4 shots) | 4.0s (2 shots) |

**At Max Upgrade Level:**

* Vulcan Dmg: +45% (14.5 dmg)
* Reaper Dmg: +40% (224 dmg)

| Enemy | HP | Vulcan (Max) | Havoc (Max) | Reaper (Max) |
| --- | --- | --- | --- | --- |
| **Tank** | 200 | **1.1s** | 4.8s | **Instant** (1 shot) |

**Analysis:** The Reaper upgrade is critical. At base, a Tank takes 2 missiles (8 seconds total cycle). At max, it takes 1 missile (Instant). This is a massive "feel good" breakpoint for the player.

---

## 4. Difficulty Curve Approach

We cannot simply scale Enemy HP linearly, or the Vulcan becomes useless. We must scale **Density** and **Complexity**.

* **Levels 1-3 (Onboarding):** Low density. High "Popcorn" enemies (Militia). Player learns to lead targets.
* *Power Budget:* Player feels Overpowered.


* **Levels 4-6 (The Crunch):** Introduction of Armor (APC/Tank). Vulcan stops being a universal solver. Player *must* buy Reaper upgrades here.
* *Power Budget:* Player feels Threatened. Upgrade necessity spikes.


* **Levels 7-9 (The Swarm):** High density of low HP enemies + High priority SAM targets. Forces rapid weapon switching.
* *Power Budget:* Player requires Hull/Flare upgrades to survive projectile volume.


* **Level 10 (Climax):** "Bullet Hell" scenario.
* *Power Budget:* Test of skill and upgrade choices.



---

## 5. Star-Rating Framework

Star ratings drive replayability. They should not just be "You Won."

* **1 Star (Survivor):** Mission Complete. The Ground Team survived (even if only 1 soldier remains).
* **2 Stars (Operator):** Mission Complete + Time Limit Met OR >50% Ground Team Health. (Efficiency).
* **3 Stars (Ace):** Mission Complete + All Secondary Objectives Complete. (Mastery).

**Reward Multiplier:**

* 1 Star: 1.0x Credits
* 2 Stars: 1.2x Credits
* 3 Stars: 1.5x Credits + "Ace Badge" (Cosmetic/Prestige).

---

## 6. Competitive Positioning

*WarSignal* occupies the **"Premium tactical simulation"** niche, contrasting sharply with *Goliath's* **"Arcade grinder"** model.

**Goliath** focuses on retention through deprivation (fuel timers) and endless scaling (Prestige 8+). It forces players to watch ads to progress.
**WarSignal** respects the player's time. We offer a finite, curated experience. Our "Prestige" is not a reset for numbers, but a "New Game+" with harder enemy AI.

**Viability:** The mobile market is flooded with F2P clones. A distinct, $4.99-$9.99 premium title with "No IAP, No BS" marketing appeals to the core gamer demographic (ages 25-45) who grew up on *Call of Duty 4* (AC-130 mission) and hate energy timers.

---

## 7. Recommended Economy Changes

To fix the 26,000 credit deficit and balance the fun:

1. **Triple the Base Rewards:**
* Level 1 Base: 500  **1,500 Credits**.
* Scaling: +200 per level. Level 10 Base = 3,300.


2. **Add "First Time Completion" Bonus:**
* Award a flat **1,000 Credit** bonus the first time a level is cleared. This encourages progression over grinding.


3. **Reduce "Utility" Costs:**
* Cut *Flare Recharge* and *Hull Repair* costs by 30%. These are "nice to haves" that players currently skip because they are too expensive compared to Weapon Damage.


4. **Define Base Damage:**
* Hardcode the base damage values proposed in Section 3 into `GAME_DESIGN.md`.



**New Projected Income:** ~35,000 Credits (Allows ~85% of tech tree unlock).

---

## 8. Delivery Plan

1. **Phase 1 (Design):** Finalize `ECONOMY.md` spreadsheet with "Cost vs Earn" curves for all 10 levels.
2. **Phase 2 (Prototyping):** Implement the "Proposed Base Values" for weapons and test TTK against Level 1 and Level 5 enemy waves.
3. **Phase 3 (Integration):** Apply Star-Rating logic to SceneKit victory conditions.
4. **Phase 4 (Balancing):** Playtest Level 4 (The Crunch). Ensure the player *needs* to upgrade the Reaper to win comfortably.
5. **Phase 5 (Polish):** Tune the "First Time Bonus" visual feedback in SwiftUI to make the currency drop feel rewarding.

---

## 9. Risks & Concerns

* **The "Vulcan Trap":** If the Vulcan is too good (high DPS), players will never switch weapons. We must ensure Heavy Armor (Tanks) has high bullet resistance to force the Havoc/Reaper usage.
* **Replayability:** With no F2P grind, the game might be too short (2 hours). We need to ensure High Difficulty modes (New Game+) offer genuine challenge changes, not just HP sponges.
* **Inflation:** If we increase rewards too much, the game becomes a "walking simulator." The economy needs to be tight enough that the player has to choose between "More Hull" or "More Missiles" before Level 6.

---

## 10. Questions for the PM

1. **Damage Values:** Do you approve the Base Damage assumptions (Vulcan: 10, Havoc: 50, Reaper: 160)?
2. **Campaign Length:** Is the target playtime 2 hours or 6+ hours? This dictates the grind curve.
3. **Tech Stack:** Can SceneKit handle 60+ active entities with physics on an iPhone 13, or do we need to implement object pooling for the projectiles to keep 60 FPS?

Looking forward to your feedback.

**Gemini** Economy Designer