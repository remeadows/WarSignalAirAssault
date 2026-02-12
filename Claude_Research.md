# GOLIATH: The AC-130 Gunship That Conquered Mobile

**GOLIATH is a free-to-play AC-130 Spectre Gunship simulator by solo Canadian indie developer SHD Games Inc. that puts players behind the thermal camera of the "Angel of Death," dropping ordnance to protect friendly ground forces against escalating waves of enemies.** The game stands out in a niche sub-genre pioneered by Zombie Gunship (2011) and inspired by Call of Duty 4's iconic "Death From Above" mission, combining authentic FLIR thermal camera aesthetics with deep progression systems including Prestige tiers, Ultimate Weapons, augmentations, and live competitive events. Released in early access on January 5, 2024, it has amassed **30,457+ iOS ratings at 4.7 stars** and **2M+ Android downloads**, though a persistent save-data corruption bug remains the community's dominant pain point. This report is an exhaustive, source-backed breakdown covering every aspect of the game's identity, developer, systems, economy, community, and engineering.

---

## 1) Identity verification confirms the target listing

### Core metadata

| Field | Detail | Source |
|---|---|---|
| **Exact Title** | GOLIATH (Subtitle: "AC130 Gunship") | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Developer** | SHD Games Inc. (Apple Developer ID: 606137519) | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **App Store ID** | id6468119530 | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Bundle ID** | com.shdgames.goliath.ac130.gunship.war (iOS) | [iOSGods](https://iosgods.com/topic/195488-goliath-all-versions-10-cheat-admin-commands/) |
| **Category** | Simulation / Action | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Age Rating** | 17+ (US/NZ) / 18+ (some regions) | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Content Advisory** | Frequent/Intense Realistic Violence; Frequent/Intense Cartoon Violence; Infrequent/Mild Profanity | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Price** | Free (with IAPs and optional ads) | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **File Size** | 1.3 GB (iOS) / ~213 MB (Android) | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530), [Google Play](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship) |
| **Current Version (iOS)** | 1.1.202 | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Last Updated (iOS)** | September 29, 2025 | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Release Date** | December 17, 2023 (v0.6.102 beta); January 5, 2024 (Early Access v0.7.215) | [Game Solver](https://game-solver.com/goliath/), [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Rating** | **4.7/5** (~31K ratings, iOS US); **3.1â€“3.4/5** (~6.7K ratings, Android) | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530), [Google Play](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship) |
| **Languages** | English only | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Game Center** | Supported | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Accessibility** | Developer has not indicated any | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Copyright** | Â© 2024 SHD Games Inc. | [Google Play](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship) |

### Supported devices and requirements

| Platform | Requirement |
|---|---|
| iPhone | iOS 14.0+ |
| iPad | iPadOS 14.0+ |
| Mac | macOS 14.0+, Apple M1 chip or later |
| Apple Vision Pro | visionOS 1.0+ |
| Android | 5.1+ (8.1+ for some features) |

### Official links from the listing

| Link | URL |
|---|---|
| Developer Website | [shdgames.com](http://www.shdgames.com) |
| Privacy Policy | [Google Sites](https://sites.google.com/view/goliathprivacypolicy/home) |
| Instagram | [@SHDgames](https://www.instagram.com/shdgames/) |
| Twitter/X | [@SHD_games](https://x.com/SHD_games) |
| Google Play | [GOLIATH - AC130 Gunship](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship) |
| Developer (App Store) | [SHD Games Inc.](https://apps.apple.com/us/developer/shd-games-inc/id606137519) |

### Why this listing is the target

Multiple apps named "Goliath" exist on the App Storeâ€”including David vs Goliath (a Bible story game, id763218550), Goliath Remote (audio hardware remote, id1145851625), and titles from Goliath BV and Goliath Tech. **This report targets exclusively the AC-130 gunship game at id6468119530 by SHD Games Inc.**, confirmed by the exact URL provided. No other App Store listing shares this ID.

### Complete version history

| Version | Date | Key Changes |
|---|---|---|
| 0.6.102 | Dec 17, 2023 | Initial release (beta) |
| 0.7.215 | Jan 6, 2024 | Early Access launch; new mission "DARK MIRAGE"; beta bug fixes |
| 0.8.407 | Feb 22, 2024 | "Scorpion Bridge" mission; Spec Ops missions; **Augments** system; daily reward exploit fixed |
| 0.9.330 | Apr 16, 2024 | **Prestige mode**; "Heavy Cargo" mission; **Ultimate Weapons**; Prestige-exclusive missions |
| 0.9.331 | Apr 17, 2024 | Hotfix |
| 0.9.340 | Apr 20, 2024 | Hotfix |
| 0.9.342 | Apr 25, 2024 | Prestige 4 "Iron Horse" fixed; broken Trials fixed |
| 0.9.445 | ~May 2024 | Enemies getting stuck fixed; major crash fix |
| 0.9.711 | Jul 11, 2024 | Survival Leaderboard Reset; Prestige 4 mission "Liquid Patriot"; **Prestige VIII+**; Ultimate Weapon upgrades fixed; Trials spawning fixed |
| 1.0.150 | Oct 18, 2024 | **Live Operations** â€” "NEON TEMPER" competitive event |
| 1.0.193 | Feb 20, 2025 | Neon Temper event reward fix; data-driven optimizations |
| 1.0.305 | Jun 25, 2025 | Major performance optimizations; more Fuel; tablet device fixes |
| 1.1.202 | Sep 29, 2025 | **Cloud Saving** (multi-device progress); quality bug fixes |

Sources: [App Store US](https://apps.apple.com/us/app/goliath/id6468119530), [App Store CA](https://apps.apple.com/ca/app/goliath/id6468119530), [Soft112 Changelog](https://goliath-ac130-gunship.soft112.com/), [Apps112 Changelog](https://goliath-ac130-gunship.apps112.com/)

### Monetization model

**Free-to-play with optional ads and IAPs.** The game prominently advertises **"No forced ads!"** â€” all advertisements are opt-in for reward doubling. A **fuel/energy system** limits free play to approximately **10â€“11 sessions** per recharge cycle. The **GOLIATH Premium** one-time purchase ($9.99 USD) removes the fuel cap entirely, provides 1.5Ã— rewards, and eliminates the ad-watch prompts.

| IAP | Price (USD) | Description |
|---|---|---|
| GOLIATH Premium | $9.99 | Removes fuel limits, 1.5Ã— rewards, bonus perks |
| 50 Gems | $0.99 | Small gem pack |
| 275 Gems | $4.99 | Medium gem pack |
| 575 Gems | $9.99 | Large gem pack |
| 1,200 Gems | $19.99 | XL gem pack |
| 1,000 Credits | $0.99 | Small credit pack |
| 15,000 Credits | $9.99 | Medium credit pack |
| 50,000 Credits | $24.99 | Large credit pack |
| Ground Team Evolution 1 | $1.99 | Ground team upgrade |
| Ground Team Evolution 3 | $1.99 | Ground team upgrade |
| Live Op Booster | $4.99 | Live operation event booster |

Source: [App Store US](https://apps.apple.com/us/app/goliath/id6468119530), [App Store CA](https://apps.apple.com/ca/app/goliath/id6468119530), [App Store JO](https://apps.apple.com/jo/app/goliath/id6468119530)

### Privacy and data practices

The app collects **Identifiers** used to track across apps. Data not linked to identity includes Device ID, Advertising Data, Usage Data, Crash Data, and Performance Data, used for third-party advertising, analytics, developer marketing, and app functionality. Apple notes this information has not been verified. Source: [App Store US](https://apps.apple.com/us/app/goliath/id6468119530)

---

## 2) Developer intelligence reveals a prolific solo Canadian indie

### 2.1 Developer identity

**SHD Games Inc.** stands for **Simon Hason Design**. The company is a privately held Canadian indie studio founded by **Simon Hason**, who operates as the sole primary developer. Hason is based in **Chestermere, Alberta, Canada** (near Calgary), having previously worked from the **Okanagan region of British Columbia** where he was part of the Accelerate Okanagan tech community.

The studio was formally incorporated around **2017**, though Hason has been developing games under the SHD Games / Simon Hason Design name since approximately **2009** (his Twitter account dates to October 2009, and his Flash-era games on Armor Games and Newgrounds predate 2013). The company is backed by **Google for Startups** and **Accelerate Okanagan** as accelerator/incubator participants.

Sources: [PitchBook](https://pitchbook.com/profiles/company/510610-69), [LinkedIn](https://ca.linkedin.com/in/simonhasondesign), [Okanagan Edge Interview](https://okanaganedge.net/2019/12/11/faces-of-okgntech-59/), [Accelerate Okanagan Interview](https://www.accelerateokanagan.com/community/blog/blog/we-are-okgntech-meet-simon)

An early co-developer named **Chris** is mentioned on [IndieDB](https://www.indiedb.com/company/shd-games) ("Simon and Chris are the Lead Programmers of SHD Games"), but all available evidence indicates a **primarily solo operation**. As the TouchArcade review of LONEWOLF states: "It was developed primarily by one man, though he had help with the music and cut-scenes and testing."

### Other games by SHD Games Inc.

| Title | Genre | Platforms | Downloads | Notes |
|---|---|---|---|---|
| **LONEWOLF** | Neo-noir sniper story | iOS, Android | **10M+** (Play) | Published by FDG Entertainment (2016); 4.7â˜… |
| **SIERRA 7** | Tactical on-rails FPS | iOS, Android | **10M+** (Play) | 3.5 years to develop; stylish Flash aesthetic |
| **GUNSIM** | 3D gun simulator | iOS, Android | 3.3M+ (Play) | First 3D Unity title |
| **Tactical Assassin** | Flash sniper series | iOS, Web (Flash) | â€” | Originated on Armor Games/Newgrounds |
| **Chopper 3D** (Zombie Chopper) | Zombie helicopter combat | iOS, Android | â€” | 3D Unity game |
| **Legendary Larry** | Third-person zombie shooter | iOS, Android | â€” | 25 levels, 18 weapon types |
| **Ducky Duck** | 2D hunting game | iOS, Android | â€” | Sports/casual |
| **Weapon** | First-person defense | Web (Flash) | â€” | [Armor Games](https://armorgames.com/play/5031/weapon) |

Sources: [Apple Developer Page](https://apps.apple.com/us/developer/shd-games-inc/id606137519), [Google Play Developer](https://play.google.com/store/apps/developer?id=SHD+Games), [MobyGames](https://www.mobygames.com/company/12004/simon-hason-games/games/)

### 2.2 Studio track record and patterns

**Genre focus is exclusively military/firearms.** Every SHD Games title revolves around guns, sniping, tactical shooting, or military combat. Hason has stated openly: "I enjoy shooting guns in real life, so I apply that passion in my game design." This single-minded genre dedication creates deep domain expertise visible in GOLIATH's authentic AC-130 FLIR aesthetics.

**Monetization patterns** across the portfolio reveal a consistent philosophy: free-to-play with **non-aggressive optional ads** and tiered IAPs. LONEWOLF offered premium weapons via IAP. SIERRA 7 uses an energy/lives mechanic similar to GOLIATH's fuel system. GUNSIM has multi-currency economies (gold/gems). GOLIATH extends all these patterns while introducing its most sophisticated economy (three currencies, augments, prestige, live operations).

**Engine transition is clearly documented.** Early titles (Tactical Assassin, LONEWOLF, SIERRA 7) were built in **Adobe Flash/Adobe AIR**, evidenced by "air.com" package names on Android and the distinctive minimalist Flash art style. The [SHD Games Wiki](https://shdgameswiki.miraheze.org/wiki/Main_Page) explicitly confirms the transition: "They have also been trying their hands on creating 3D games in Unity. So far, two 3D games have been developed: GUNSIM, and their latest release, GOLIATH." LONEWOLF notably reused levels from Tactical Assassin ("Hospital," "Suicide," "Park" missions are copies), per TV Tropes.

### 2.3 Tech and hiring signals

**Engine: Unity (confirmed).** The SHD Games Wiki directly states GOLIATH is built in Unity. Additionally, the shift from "air.com" package prefixes to "com.shdgames" package structure on Android, combined with the 3D graphics capability, supports Unity as the engine. The game supports Apple Silicon natively (macOS 14.0+) and visionOS, consistent with Unity's export pipeline.

**Team size: 1â€“2 people (High Confidence).** No job postings exist on LinkedIn, Indeed, or Glassdoor. No company LinkedIn page existsâ€”only Simon Hason's personal profile with 95 connections. Multiple interviews confirm solo operation. No other employees are discoverable online.

**No GitHub, no GDC talks, no public technical artifacts** were found. The developer's LinkedIn specialties list "Adobe Flash, Adobe Photoshop, Adobe" â€” reflecting legacy skills. No Unity-specific credentials are publicly visible.

**Online presence**: Instagram is the primary channel at **241K followers** â€” an impressive following for a solo indie dev. Twitter/X (@SHD_games, 1,119 followers) appears dormant since ~2019. A fan-built [SHD Games Wiki](https://shdgameswiki.miraheze.org/wiki/Main_Page) exists on Miraheze but remains under construction.

**Confidence Rating: High** â€” engine confirmed via community wiki; team size confirmed via interviews and absence of hiring signals.

---

## 3) Exhaustive game systems report

### 3.1 Executive summary

GOLIATH's core loop places the player in an **AC-130 gunship orbiting above a battlefield**, viewing the ground through a **white-hot thermal infrared camera**. Players tap to aim and drop ordnance on waves of enemy forces (infantry, vehicles, structures) threatening friendly ground troops below, then spend earned credits on weapon upgrades, unlocking increasingly devastating ordnance, augments, and support units. What makes it compelling is the **authentic "Death From Above" fantasy** â€” the FLIR camera view, military radio chatter, ragdoll physics, and thunderous explosions create genuine immersion â€” paired with a **surprisingly deep progression system** (Prestige I through VIII+, multiple weapon tiers, augments, Ultimate Weapons, live operations). The biggest pain points are a **critical save-data corruption bug** that has wiped prestige progress and currencies for many players, the **fuel/energy system** that limits free play to ~11 sessions per cycle, and **slow early-game progression** that makes the first few hours feel underpowered and grindy before the power fantasy kicks in.

### 3.2 Genre and game pillars

**Genre classification: Military simulation / wave-defense shooter with incremental-progression elements.** The game defies single-genre classification. It is simultaneously a wave-defense game (protect the ground team), a military simulation (AC-130 FLIR camera, authentic ordnance), and an incremental-progression game (currency farming, prestige resets, power scaling). The App Store categorizes it as "Simulation" with an "Action" secondary tag.

**Game pillars (inferred from store text, reviews, and gameplay evidence):**

1. **Authentic AC-130 fantasy** â€” The white-hot thermal camera, bird's-eye perspective, military radio comms ("GOLIATH Actual, be advised..."), and ragdoll death physics authentically recreate the experience of real AC-130 gunship footage. Multiple reviewers explicitly compare it to Call of Duty's AC-130 missions.
2. **Progressive power escalation** â€” Starting weak and ascending through increasingly devastating weapons creates a satisfying power curve. "You can't start out in a game at the top tier, you've gotta work to upgrade your weapons."
3. **Tactical precision under pressure** â€” Ordnance has travel time to ground; players must lead moving targets and prioritize threats. "The levels are designed close to the required gear levels so you actually need to be somewhat tactful."
4. **Session-based accessibility** â€” Portrait orientation, offline play, no forced ads, and short mission loops make it ideal for mobile bursts. "Fast enough such that you play enough for the day."
5. **Long-term retention depth** â€” Prestige system, survival leaderboards, live operations, and Ultimate Weapons provide hundreds of hours of progression content.

**Art style** replicates AC-130 FLIR thermal imaging â€” monochromatic white-hot view with heat signatures, targeting reticles, and military HUD overlays. **Camera perspective** is top-down/bird's-eye, as if looking through the gunship's belly camera. **UI conventions** follow a military aesthetic with abbreviated weapon categories (Alpha, Bravo, LTM, Tacs) and radio-style mission briefings.

Sources: [App Store US](https://apps.apple.com/us/app/goliath/id6468119530), [App Store Review by "Garrettttttttttttttt"](https://apps.apple.com/us/app/goliath/id6468119530), [APKMODY](https://apkmody.com/games/goliath-ac130-gunship)

### 3.3 Controls, movement, and combat feel

**Control scheme: Tap-to-target bombardment.** The player taps on enemy positions to aim the crosshair and drop ordnance. The game plays exclusively in **portrait orientation** (a reviewer requested landscape; the developer said they'd consider it). The LDPlayer emulator listing describes "no more endlessly tapping on your phone screen" â€” confirming rapid tapping as the primary interaction mode. Controls are described as "simple and intuitive."

**Movement constraints** are inherent to the AC-130 concept: the gunship orbits in a fixed circular pattern above the battlefield, and the player's agency is limited to **aiming and weapon selection** rather than direct vehicle movement. The ground forces move autonomously. There is no stamina or movement cooldown â€” the constraint is ordnance reload time, weapon cooldowns, and fuel (session energy).

**Hit model: Projectile-based with travel time and splash damage.** Ordnance drops from altitude and has visible travel time to the ground â€” players must **lead moving targets** to achieve direct hits. Direct hits deal significantly more damage than splash/AoE near-misses. Ragdoll physics provide dramatic visual feedback on successful kills. Explosions produce area-of-effect damage that can hit multiple clustered enemies simultaneously.

**Combat readability** is high. Thermal camera makes enemy heat signatures pop against cooler backgrounds. Explosion effects, hit indicators, and the satisfying ragdoll deaths provide clear feedback. One reviewer noted even small insurgents become "huge threats if overlooked and allowed to bunch up," suggesting enemy clustering creates visible tactical urgency. A **UAV spotting system** highlights enemies on the map, though one reviewer noted the UAV sometimes spots already-dead enemies.

Sources: [App Store Review](https://apps.apple.com/us/app/goliath/id6468119530), [BlueStacks](https://www.bluestacks.com/apps/action/goliath-ac130-gunship-on-pc.html), [LDPlayer](https://www.ldplayer.net/games/goliath-ac130-gunship-on-pc.html), [APKMODY](https://apkmody.com/games/goliath-ac130-gunship)

### 3.4 Gameplay loop and systems map

```
MISSION SELECT â†’ DEPLOY GOLIATH (AC-130) â†’ ENGAGE ENEMY WAVES
       â†‘                                              â†“
       |                                   [Tap to aim/drop ordnance]
       |                                   [Switch weapons: Alpha/Bravo/LTM]
       |                                   [Deploy support units]
       |                                   [Use Tacticals]
       |                                              â†“
       |                                   MISSION COMPLETE / FAIL
       |                                              â†“
       |                                   EARN REWARDS
       |                                   â€¢ Credits (primary currency)
       |                                   â€¢ Gems (premium currency)  
       |                                   â€¢ Red Diamonds (ultra-premium)
       |                                   â€¢ [Optional: Watch ad to 2Ã— rewards]
       |                                              â†“
       |                                   UPGRADE LOOP
       |                                   â€¢ Weapon upgrades (Credits)
       |                                   â€¢ Augment attachments
       |                                   â€¢ Crate rolls (Gems â†’ random rewards)
       |                                   â€¢ Support unit unlocks
       |                                   â€¢ Ground Team Evolution (IAP)
       |                                   â€¢ Ultimate Weapons (Red Diamonds)
       |                                              â†“
       |                                   PROGRESSION GATE CHECK
       |                                   â€¢ Gear level meets next mission requirement?
       |                                   â€¢ Fuel remaining? (10-11 per cycle, or âˆž w/ Premium)
       |                                              â†“
       â†---------- YES: Next mission / Harder content / Prestige reset
                   NO: Wait for fuel OR replay for credits OR IAP
```

**Resource flow:**

| Resource | Earned From | Spent On |
|---|---|---|
| **Credits** | Mission completion, ad-doubling, replaying missions | Weapon upgrades, equipment |
| **Gems** | Timed challenges, IAP, occasional drops | Crate openings (25/crate, 250/10-pack) |
| **Red Diamonds** | Events (Neon Temper), rare drops, IAP | Ultimate Weapons |
| **Fuel** | Time-based regeneration (~10 units/cycle) | 1 per mission attempt; removed by Premium |
| **Bolts/Screws** (green resource) | Uncertain â€” possibly mission drops | Uncertain â€” likely tied to support units |

Source: [App Store Reviews](https://apps.apple.com/us/app/goliath/id6468119530), [Google Play Reviews](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship), [HappyMod](https://happymod.com/shd-games-mod/com.shdgames.goliath.ac130.gunship/)

### 3.5 Progression and difficulty curve

**Early game (Missions 1â€“5, Pre-Prestige):** The opening hours feel intentionally slow. Damage output is low, weapons are basic, and the power fantasy hasn't kicked in yet. Players must learn to lead targets and manage limited ordnance. One player described it: "It starts kinda slow, and you do much less damage than you'd expect, but you can't start out at the top tier." The fuel system limits sessions to ~11 plays, creating natural pacing. Progression blockers are minimal â€” missions are completable with basic upgrades. Strategy: focus on upgrading primary (Alpha) weapons and learning target-leading mechanics.

**Mid game (Missions 6â€“10, Prestige Iâ€“III):** The power fantasy emerges. Upgraded weapons deliver satisfying destruction, and players unlock **Bravo weapons, support units, and augments**. Mission difficulty escalates with more diverse and durable enemy types. A reviewer noted approximately **10 base missions** exist before Prestige becomes the primary progression vehicle. Progression blockers appear: "Once you go to Prestige 2, you have to drag each mission out to get all the credits." This is the phase where the credit grind intensifies and the Premium pass becomes most tempting. Community-reported strategy: replay earlier missions to farm credits efficiently before attempting harder content.

**Late game (Prestige IVâ€“VIII+):** Prestige resets certain progress (Bravo weapons, LTMs, upgrades, shop access) while preserving others (boosts, tacticals, Alpha weapons, supports, money). Each Prestige tier unlocks exclusive missions (Iron Horse, Liquid Patriot at P4) and increased difficulty. **Ultimate Weapons** (requiring Red Diamonds) become the primary power progression. The Survival mode leaderboard and Live Operations (Neon Temper) provide competitive endgame content. Progression blocker: Red Diamonds are extremely scarce for free players. A New Zealand reviewer stated: "I feel there needs to be another way to slowly accrue blood diamonds."

Sources: [App Store Review by "Garrettttttttttttttt"](https://apps.apple.com/us/app/goliath/id6468119530), [App Store Review by "Needs11111111"](https://apps.apple.com/us/app/goliath/id6468119530), [App Store NZ Reviews](https://apps.apple.com/nz/app/goliath/id6468119530), [Google Play Reviews](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship)

### 3.6 Content inventory

#### Missions (confirmed)

| Mission Name | Unlock Condition | Version Added | Type |
|---|---|---|---|
| DARK MIRAGE | Early Access (base) | v0.7.215 | Campaign |
| Scorpion Bridge | Base progression | v0.8.407 | Campaign |
| Heavy Cargo | Prestige unlock | v0.9.330 | Prestige-exclusive |
| Iron Horse | Prestige 4 | v0.9.330 | Prestige-exclusive |
| Liquid Patriot | Prestige 4 | v0.9.711 | Prestige-exclusive |
| NEON TEMPER | Live Operation (timed) | v1.0.150 | Competitive event |
| *~4-5 additional unnamed base missions* | Progressive unlock | v0.6â€“v0.7 | Campaign |

Note: A reviewer referenced "10 current levels" as of mid-2024, with additional Prestige-exclusive and Spec Ops missions expanding the total. Exact names of all base missions are not documented in any public source.

#### Mission types

| Type | Description | Source |
|---|---|---|
| Campaign | Linear story-driven with escalating objectives | [APKMODY](https://apkmody.com/games/goliath-ac130-gunship) |
| Spec Ops | Unique special-objective missions | v0.8.407 patch notes |
| Prestige Missions | Exclusive post-prestige content | v0.9.330 patch notes |
| Trials | Challenge mode (details sparse; had enemy-spawning bug) | v0.9.711 patch notes |
| Survival | Endless wave mode with leaderboard | [App Store](https://apps.apple.com/us/app/goliath/id6468119530) |
| Live Operations | Timed competitive events (Neon Temper) | v1.0.150 patch notes |

#### Weapon categories (community-reported labels)

| Category | Description | Persistence on Prestige |
|---|---|---|
| **Alpha** | Primary weapon system (always available) | Preserved |
| **Bravo** | Secondary weapon system (unlockable, upgradable to 38+) | Reset |
| **LTM** | Limited-Time Munitions (unlockable, upgradable to 6+) | Reset |
| **Tacticals (Tacs)** | Tactical abilities/deployments | Preserved |
| **Ultimate Weapons** | Extreme-damage weapons requiring Red Diamonds | Preserved (uncertain) |
| **Augments** | Weapon modifiers (e.g., "Dead Eye" â€” 10% extra damage) | Uncertain |
| **Support Units** | Deployable aircraft/vehicles (e.g., MQ-9 Reaper) | Preserved |

Sources: [App Store Reviews](https://apps.apple.com/us/app/goliath/id6468119530), [TikTok](https://www.tiktok.com/discover/goliath-ac130-game), [Google Play Reviews](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship)

#### Enemy types (limited documentation)

Specific enemy rosters are not publicly documented in any wiki, guide, or official source. From reviews and gameplay descriptions, confirmed enemy categories include **insurgents** (infantry/foot soldiers â€” "even the smallest insurgents become huge threats if overlooked"), **military vehicles** of "varying damage, health and range," and enemies that attack from multiple directions. Missions involve "destroying enemy troops, attacking bases, and destroying important targets or structures." Boss-type enemies are not explicitly confirmed but "powerful enemy forces" at higher levels suggests some form of elite/heavy units.

#### Upgrade systems

| System | Currency | Description |
|---|---|---|
| Weapon leveling | Credits | Increased cannon power, blast radius, reload speed |
| Armor upgrades | Credits | Boost durability/damage resistance |
| Agility upgrades | Credits | Dodge shots and improve response |
| Passive boosts | Credits | Permanent stat bonuses preserved through Prestige |
| Augments | Crate drops | Weapon modifiers slotted to ordnance types |
| Ultimate Weapons | Red Diamonds | Top-tier damage weapons |
| Support unit unlocks | Progression/IAP | Deployable allied units (MQ-9 Reaper confirmed) |
| Ground Team Evolution | IAP ($1.99) | Upgraded ground forces |
| Crates | Gems (25/crate) | Random rewards including augments and upgrades |

### 3.7 Meta systems and retention

**Daily/weekly loops:** A daily reward system exists (a "Daily Reward exploit" was patched in v0.8.407, confirming its presence). Timed challenges provide gems as rewards. The fuel system creates **natural daily session caps** of approximately 11 missions for free players.

**Events:** The **Neon Temper Live Operation** (introduced October 2024) is the only confirmed event. It operates as a competitive mission where players compete on damage dealt, earning Red Diamonds as rewards. The event has been plagued by bugs â€” reward collection screens freeze, requiring force-close.

**Social systems:** The game features a **Survival mode leaderboard** (was reset in July 2024) providing competitive ranking. No clans, co-op, PvP, or social features beyond leaderboards are documented.

**Progress persistence:** The Prestige system functions as a **New Game+ reset**: Bravo weapons, LTMs, upgrades, and shop access reset, while boosts, tacticals, Alpha weapons, support units, and currency carry over. **Cloud Saving** was added in v1.1.202 (September 2025) for multi-device progress. The game is playable **offline** â€” internet is required only for leaderboards and live operations. No idle/offline progression mechanics exist.

### 3.8 Economy and monetization analysis

**Ads: Entirely optional and widely praised.** "No forced ads!" is a listed feature. Ads are offered as opt-in reward doublers after mission completion (2Ã— credits, 2Ã— upgrades). Player sentiment is overwhelmingly positive: "I love how they have the option to watch ads at the point of expansion versus every time you finish a mission... I delete 100% of games that shove it down your throat."

**IAPs: Tiered currency packs and a premium pass.** The **GOLIATH Premium** ($9.99) is the most impactful purchase â€” removing fuel limits and providing 1.5Ã— rewards. Gem packs range from $0.99 (50 gems) to $19.99 (1,200 gems). Credit packs from $0.99 (1,000 credits) to $24.99 (50,000 credits). Ground Team Evolution upgrades are $1.99 each. A Live Op Booster is $4.99.

**Subscriptions: None.** Despite some reviewers using the word "subscription," the Premium pass is a **one-time purchase**. No recurring billing exists. A reviewer explicitly praised: "There is no season pass which is amazing."

**Pay-to-win perception: Mild consensus.** Community sentiment is that the game is **completable without spending** but the fuel system and credit grind strongly incentivize Premium purchase. Representative quotes:
- *Positive:* "The monetisation scheme is really good, not predatory in any way but speeds up progress."
- *Mixed:* "Good game, great game when you spend the money."
- *Critical:* "If you don't spend the $10 for the premium pass, you only get 11 plays before you have to quit and wait."
- *Red Diamonds concern:* "I feel there needs to be another way to slowly accrue blood diamonds" â€” suggesting Ultimate Weapons progression is heavily gated for F2P players.

**Potential dark-pattern flags:**
- **Fuel/energy timer**: Classic session-gating mechanic that creates "wait or pay" friction. Recharge timer creates return compulsion. Mitigated somewhat by generous per-cycle allocation (~11 sessions).
- **Crate gacha system**: Random rewards from gem-purchased crates (25 gems/crate). A reviewer reported a legendary augment yielded only "10% extra damage," suggesting possible diluted reward pools.
- **Interrupted crate loss**: Multiple reports of gems consumed but rewards lost when interrupted during crate opening (phone call, crash). This creates real-money loss risk.
- **FOMO on Live Operations**: Neon Temper is time-limited, creating urgency to participate and spend for boosters ($4.99).
- **No popups/aggressive upselling reported**: Unlike many F2P competitors, no reviews mention aggressive purchase prompts or fullscreen offers.

Sources: [App Store Reviews](https://apps.apple.com/us/app/goliath/id6468119530), [App Store NZ](https://apps.apple.com/nz/app/goliath/id6468119530), [Google Play Reviews](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship)

### 3.9 UX/UI and quality signals

**Onboarding:** The game provides tips after each level for completing the next, serving as progressive tutorials. The early levels are deliberately simple, teaching target-leading mechanics before escalating. No separate tutorial mode is documented. The "simple and intuitive controls" minimize onboarding friction.

**Menu complexity:** The UI uses military-themed categories (Alpha, Bravo, LTM, Tacs) that may initially confuse players unfamiliar with military nomenclature. A **critical recurring bug** causes the upgrade menu and store to become **greyed out and inaccessible**, forcing players to complete or prestige a mission to restore access. This is the single most-reported UX issue.

**Accessibility/comfort:** Portrait-only orientation requires single-hand play. Rapid tapping on targets may cause **hand fatigue** over extended sessions (BlueStacks markets emulator play as relief from "endlessly tapping"). At **60fps with max graphics**, the game causes significant **battery drain** â€” one reviewer described it as "drains my battery like absolute crazy." No accessibility features are formally indicated by the developer. The thermal camera view is inherently monochromatic, which may benefit colorblind players but limits visual variety.

**Stability/performance:** Performance is **generally praised** on iOS ("plays very smoothly," "even better than most games on console/PC"). However, **Android stability is significantly worse** â€” the Google Play rating of 3.1 versus iOS's 4.7 reflects widespread Android issues:
- **Startup freeze**: Multiple Android users report the game freezing at the loading screen indefinitely
- **Samsung Z Fold issues**: Specific foldable device complaints after updates
- **Tablet issues**: Documented in v1.0.305 patch notes as a known and fixed problem
- **Major crash issue**: Addressed in v0.9.445 hotfix

### 3.10 Technical and development notes

**Engine: Unity (confirmed via [SHD Games Wiki](https://shdgameswiki.miraheze.org/wiki/Main_Page)).** The fan wiki explicitly states GOLIATH is built in Unity. This is consistent with the "com.shdgames" package naming (vs. legacy "air.com" for Flash/AIR games), native Apple Silicon support, and visionOS compatibility â€” all supported by Unity's export pipeline.

**Update cadence:** The game has received **12 documented updates** over approximately 21 months (Dec 2023 â€“ Sep 2025), averaging roughly **one update every 6â€“7 weeks**. Updates cluster in patterns: a major feature update followed by 1â€“3 rapid hotfixes. The longest gap was ~4 months between v1.0.193 (Feb 2025) and v1.0.305 (Jun 2025). The cadence is impressive for a solo developer.

**Online requirements:** The game is playable **offline** for core missions and survival mode. Internet is required for Live Operations (Neon Temper), leaderboard sync, and Cloud Saving (introduced Sep 2025).

**Known bugs (by frequency of reports):**
1. **Save data / prestige reset** (CRITICAL, most-reported): Progress wiped after updates or app restarts. "We recently hit Prestige III... when we open it back up, it takes away our Bravo and LTMs, removes the Upgrades and Shop"
2. **Store/upgrades greyed out**: UI elements become inaccessible, requiring mission completion or prestige to fix
3. **Currency loss**: Credits and gems disappear without explanation after updates ("loss of 1k+ gems and 40-60k credits")
4. **Neon Temper reward freeze**: Event reward screen freezes, requiring force-close
5. **Crate interruption loss**: Gems consumed but no rewards received if interrupted mid-opening
6. **Android startup freeze**: Game hangs at loading screen ("in loving memory of Zorro & Luey" screen)
7. **Survival mode scoring bug**: Score anomalies (health increasing instead of decreasing, score loss on abort)
8. **Augment selection bug**: "Cannot select augmentation for any weapon, only Dead Eye shows in every slot"

Cloud Saving (v1.1.202) was specifically introduced to address save-loss concerns, though reports suggest it may have introduced new issues.

### 3.11 Community knowledge base

**Best creators/guides:** The game's community is **primarily on TikTok and Instagram**, not traditional gaming platforms. No dedicated YouTube walkthroughs, Reddit communities, or Discord servers were discoverable. The game's generic name ("GOLIATH") makes it extremely difficult to find through search, competing with biblical references, other games, and unrelated content.

- **TikTok**: The most active community. Content tags include #goliath, #ac130, #shdgames, #gunshipbattle. Creators post gameplay clips, weapon showcases, MQ-9 Reaper demonstrations, Spec Ops mission footage, and Neon Temper event content. Available via [TikTok Discover](https://www.tiktok.com/discover/goliath-ac130-game).
- **Instagram**: The developer's primary interaction channel at [@shdgames](https://www.instagram.com/shdgames/) (241K followers). Bug reports, feedback, and community interaction happen in post comments.
- **App Store reviews**: Function as the game's de facto community forum. The developer actively responds to reviews with bug acknowledgments and ETAs.
- **Fan Wiki**: [shdgameswiki.miraheze.org](https://shdgameswiki.miraheze.org/wiki/Main_Page) â€” under construction, covers SHD Games titles but minimal GOLIATH-specific content.
- **No Reddit presence, no Discord server, no dedicated YouTube channels, no editorial reviews** from major outlets (TouchArcade, Pocket Gamer, etc.) were found.

**Common new-player mistakes (community-reported):**
- Expecting high damage output immediately â€” weapons start weak intentionally
- Firing directly at targets without leading for travel time
- Ignoring small insurgent groups that can overwhelm ground forces when clustered
- Spending gems on crates too early instead of saving for efficient bulk purchases (250 gems for 10-pack)

**Advanced optimization tips (community-reported):**
- Direct hits deal significantly more damage than splash â€” always aim for center-mass
- Replay earlier missions at higher Prestige to efficiently farm credits
- Prioritize passive boosts early â€” they persist through Prestige resets
- Alpha weapons and Tacticals carry through Prestige, so invest in these for long-term efficiency
- If store/upgrades become greyed out, complete an uncompleted mission or prestige to restore access

**Known exploits:** A "Daily Reward exploit" was patched in v0.8.407 â€” specific method undocumented. Modded APK/IPA files exist on [iOSGods](https://iosgods.com/topic/195488-goliath-all-versions-10-cheat-admin-commands/) and [HappyMod](https://happymod.com/shd-games-mod/com.shdgames.goliath.ac130.gunship/) offering unlimited gems/gold/1-hit kill, indicating no robust server-side validation for single-player currency values. The Survival mode has exhibited a scoring anomaly where health continuously increases instead of depleting, making the player unkillable (reported on [App Store JO](https://apps.apple.com/jo/app/goliath/id6468119530)).

### 3.12 Comparable games

The AC-130 gunship sub-genre traces directly to **Call of Duty 4: Modern Warfare's "Death From Above" mission (2007)**, where players operated the AC-130H Spectre's thermal camera with three weapon systems (105mm howitzer, 40mm Bofors, 25mm Gatling). Multiple GOLIATH reviewers explicitly cite this as their reference: "I really have been looking for a game that scratches that itch of being all-powerful and in control of the guns from an AC130 gunship, similar to the COD missions."

| Game | Similarity | Depth | Monetization | Status | Key Difference |
|---|---|---|---|---|---|
| **Zombie Gunship** (Limbic, 2011) | 95% | Low | Fair | Legacy | Zombies, not military; single endless mode; 3 weapons only |
| **Modern Gunships** (ForgeGames, 2025) | 90% | High | TBD | Active | Near-clone with jungle ops; named weapons (REAPER, HAMMER, LANCE); far less traction |
| **AC-130** (Triniti, 2011) | 85% | Minimal | None | Dead | 10+ scripted missions; no upgrades; defunct on modern iOS |
| **War Drone: AC-130** (Mobile Gaming Studios) | 80% | High | **Very Aggressive** ($8/week VIP) | Active | Drone + gunship hybrid; clans/leagues; heavy paywall |
| **Zombie Gunship Survival** (Flaregames, 2017) | 75% | Medium-High | Moderate-Aggressive | Active | Base-building metagame; loot box system; heavier grind |
| **Drone: Shadow Strike** (Reliance, 2014) | 70% | Very High | Fair | Active | Drone UCAV perspective; 34+ missions; 8 drone types; praised F2P model |
| **Zombie Gunship Revenant AR** (Limbic, 2017) | 60% | Medium | Aggressive | Legacy | Augmented reality; physical movement required |
| **iBomber** series (Cobra Mobile, 2009) | 40% | Medium | Fair (Premium) | Legacy | WWII bomber, not AC-130; direct plane control |

**GOLIATH's competitive position** is the **most modern, actively maintained military-themed (non-zombie) AC-130 game with deep progression and fair monetization on mobile**. Zombie Gunship pioneered the genre but is dated and shallow. Zombie Gunship Survival added depth at the cost of aggressive monetization. **Modern Gunships** (ForgeGames, April 2025) is the most direct new competitor â€” a near-clone with comparable features â€” but a Google Play reviewer directly stated: "Goliath AC-130 was better. I guess they got their Lamborghini and dipped." Drone: Shadow Strike is the closest analog in fairness and depth but uses drones rather than gunships.

Sources: [Wikipedia - Zombie Gunship](https://en.wikipedia.org/wiki/Zombie_Gunship), [Call of Duty Wiki - Death From Above](https://callofduty.fandom.com/wiki/Death_From_Above), [Google Play - Modern Gunships](https://play.google.com/store/apps/details?id=com.forgegames.moderngunships), [App Store - Zombie Gunship Survival](https://apps.apple.com/us/app/zombie-gunship-survival-ac130/id1019161597), [App Store - Drone Shadow Strike](https://apps.apple.com/us/app/drone-shadow-strike/id824808682), [GamesRadar](https://www.gamesradar.com/modern-warfares-death-from-above-mission-is-still-the-model-for-quiet-unease-in-call-of-duty/)

### 3.13 Engineering reconstruction (clearly labeled as inference)

> âš ï¸ **This entire section is speculative inference** based on observable game behavior, modding community artifacts, and standard Unity development patterns. No internal source code, design documents, or developer technical disclosures were found.

**Core components (inferred Unity architecture):**

- **Camera Controller**: A fixed orbital path around the mission area with FLIR post-processing shader (white-hot color ramp applied to scene depth/temperature buffer). Likely uses Unity's URP or Built-in pipeline with a custom post-processing shader stack.
- **Input System**: Raycasting from screen tap position through camera to ground plane, resolving to world-position target coordinates. Simple `Camera.ScreenPointToRay()` â†’ ground plane intersection â†’ weapon targeting.
- **Weapon System**: ScriptableObject-based weapon definitions with configurable parameters: damage, blast radius, travel time, reload cooldown, AoE falloff curve. Weapons categorized by slot (Alpha, Bravo, LTM, Tactical). Each weapon instantiates a projectile prefab that lerps from aircraft position to target over `travelTime` seconds.
- **AI / Spawning**: Wave-based spawner using predefined spawn points at map edges. Enemy units follow pathfinding (likely NavMesh or simple waypoint systems) toward friendly ground positions. Enemy types defined as prefab variants with health, speed, damage, and range parameters. Wave configuration likely stored as JSON or ScriptableObject arrays defining enemy composition, count, and timing per wave.
- **Combat/Damage**: On projectile impact, `Physics.OverlapSphere` at blast position with weapon-specific radius. Damage applied with falloff from center (direct hit = full damage, edge = reduced). Ragdoll activation on enemy death (swapping from animated character to ragdoll physics body).
- **Ground Team System**: Autonomous friendly units with health pools. Enemies that reach ground team positions deal damage over time. Mission fails when ground team health reaches zero.

**Data model (inferred):**

```
WeaponDefinition {
  id: string
  category: enum (Alpha, Bravo, LTM, Tactical, Ultimate)
  baseDamage: float
  blastRadius: float
  travelTime: float
  reloadCooldown: float
  aoeFalloff: AnimationCurve
  upgradeCostCurve: int[]
  maxLevel: int
  requiredPrestige: int
  requiredCurrency: enum (Credits, Gems, RedDiamonds)
}

MissionDefinition {
  id: string
  name: string
  type: enum (Campaign, SpecOps, Prestige, Trial, LiveOp, Survival)
  requiredGearLevel: int
  requiredPrestige: int
  waves: WaveDefinition[]
  rewards: RewardTable
}

WaveDefinition {
  enemySpawns: SpawnEntry[] // {enemyType, count, spawnPoint, delay}
  completionCondition: enum (AllKilled, TimeSurvived)
}

PlayerProfile {
  prestige: int
  currencies: {credits: int, gems: int, redDiamonds: int, fuel: int}
  weaponLevels: Map<weaponId, int>
  augments: Map<weaponId, augmentId>
  unlockedMissions: string[]
  survivalHighScore: int
  isPremium: bool
}
```

**Balancing knobs (inferred):**

- **Enemy HP scaling**: Likely exponential or polynomial curve per mission index and prestige tier. Formula might resemble `baseHP * (1 + missionIndex * 0.15) * (1 + prestigeLevel * 0.3)`.
- **Credit economy scaling**: Mission rewards likely scale sub-linearly relative to upgrade costs, creating the credit grind observed at Prestige 2+. Prestige reset of Bravo/LTM creates recurring currency sinks.
- **Fuel regeneration**: Approximately 1 fuel unit per 30â€“45 minutes (inferred from "10 automatically with enough time to recharge one more" per session cycle of several hours).
- **Crate drop tables**: Probability weights for augment rarity. The "10% extra damage" legendary augment complaint suggests diluted legendary pools.
- **Red Diamond scarcity**: Deliberately restricted to drive event participation and IAP conversion. The most constrained resource in the economy.

**Analytics and LiveOps hooks (inferred):**

The App Store privacy label confirms collection of Device ID, Advertising Data, Usage Data, and Performance Data for analytics and third-party advertising. The v1.0.193 update explicitly references "new data driven changes to make GOLIATH the best it can be" â€” confirming **server-side data-driven tuning** (likely A/B testing economy parameters, difficulty curves, or offer segmentation). The Live Operations system (Neon Temper) requires server infrastructure for leaderboard syncing and event state management. The "Live Op Booster" IAP ($4.99) suggests **segmented monetization targeting** during event windows. Cloud Saving (v1.1.202) implies a server-side save backend â€” likely a lightweight cloud storage solution (Firebase, PlayFab, or similar). The mod community's discovery that currency values can be modified client-side (HappyMod mods for unlimited gems/gold) suggests **limited server-side validation** for offline play sessions, with sync occurring only for online features.

---

## 4) Media appendix: recommended images to embed

Direct embedding of App Store screenshots is not possible in this format. The following links provide official and community media for reference:

| Media | Source | URL |
|---|---|---|
| App Store screenshots (US) | Apple | [App Store Listing](https://apps.apple.com/us/app/goliath/id6468119530) |
| Google Play screenshots | Google | [Google Play Listing](https://play.google.com/store/apps/details?id=com.shdgames.goliath.ac130.gunship) |
| TikTok gameplay clips (thermal view, MQ-9 Reaper, Neon Temper, Spec Ops) | Community | [TikTok Discover](https://www.tiktok.com/discover/goliath-ac130-game) |
| Developer Instagram (trailers, launch announcement) | Official | [@SHDgames](https://www.instagram.com/shdgames/) |
| iOS launch announcement reel | Official | [Instagram Post](https://www.instagram.com/shdgames/p/C1xAT_Krfox/) |
| Android launch reel | Official | [Instagram Reel](https://www.instagram.com/shdgames/reel/C3s-nAby3kS/) |

**Recommended "mechanic proof" stills:** The TikTok discover page for "goliath-ac130-game" contains multiple short-form videos demonstrating the thermal camera view, MQ-9 Reaper deployment, Neon Temper event UI, and Spec Ops missions. The App Store listing contains 5â€“6 screenshots showing the FLIR view, explosion effects, weapon upgrade screens, and mission briefing UI.

---

## 5) Final QA checklist

| Check | Status |
|---|---|
| **App Store URL confirmed** | âœ… https://apps.apple.com/us/app/goliath/id6468119530 â€” verified as target |
| **All required sections present** | âœ… All 13 subsections + media appendix completed |
| **Citations for factual claims** | âœ… Every major claim includes source URL |
| **Identity disambiguation** | âœ… Other "Goliath" apps explicitly noted in Â§1 |

### What's uncertain or disputed

| Topic | Uncertainty | Sources |
|---|---|---|
| **Exact number of base missions** | One reviewer says "10 current levels" as of May 2024; actual number may be higher post-updates | [App Store Review](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Specific weapon names** | Weapon categories (Alpha, Bravo, LTM) are community labels from reviews; official internal names undocumented | App Store/Google Play reviews |
| **Exact enemy roster** | No wiki or guide lists specific enemy types; "insurgents" and "military vehicles" confirmed but granularity unknown | [App Store Reviews](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Red Diamonds earn rate** | Players report extreme scarcity for F2P; exact drop rates undocumented | [App Store NZ](https://apps.apple.com/nz/app/goliath/id6468119530) |
| **iOS version requirement** | US listing says iOS 14.0+; some regional listings show iOS 12.0 or 13.0; US listing is authoritative | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530), [App Store JO](https://apps.apple.com/jo/app/goliath/id6468119530) |
| **"Bolts/screws" resource** | Mentioned in one mod request as "green things"; purpose and source unconfirmed | Community mod request |
| **Cloud Saving reliability** | Introduced Sep 2025 to fix save-loss; whether it fully resolves the issue is unconfirmed | [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |
| **Prestige reset specifics** | What exactly resets and preserves at each tier is inconsistently described across reviews | Multiple App Store reviews |
| **Team beyond Simon Hason** | "Chris" mentioned on IndieDB as co-programmer but current involvement unclear | [IndieDB](https://www.indiedb.com/company/shd-games) |
| **Android vs iOS feature parity** | Android version appears to lag in updates (v1.0.306 vs iOS v1.1.202); cloud saving status on Android uncertain | [Soft112](https://goliath-ac130-gunship.soft112.com/), [App Store US](https://apps.apple.com/us/app/goliath/id6468119530) |

---

## Conclusion: A niche masterclass hobbled by save-state fragility

GOLIATH represents something rare in mobile gaming: a **deeply passionate solo developer's love letter to a specific military fantasy**, executed with surprising production quality and monetization restraint. Simon Hason's 15+ years of firearms-focused game development culminate here in a title that authentically captures the AC-130 gunship experience better than any current mobile competitor. The **4.7-star iOS rating** and **2M+ Android downloads** prove the market appetite for this niche is real and underserved.

The game's most novel contribution to the sub-genre is its **Prestige loop** â€” borrowing Call of Duty multiplayer's reset-for-rewards mechanic and applying it to wave defense, creating replay depth that Zombie Gunship and its successors never achieved. The "no forced ads" philosophy and one-time Premium purchase are genuinely player-friendly in a market saturated with predatory monetization.

However, the persistent **save-data corruption bug** remains an existential threat to player retention. When a game asks players to invest dozens of hours into Prestige progression, losing that progress to a bug is devastating â€” and it's the single most frequent complaint across both iOS and Android reviews. Cloud Saving (September 2025) represents the developer's acknowledgment of this crisis, but its effectiveness is still unproven. For a game dev studying GOLIATH, the lesson is clear: the progression system is the product, and protecting save integrity must be the engineering priority above all else.

The **competitive moat** is narrow but currently defensible. Modern Gunships (ForgeGames, 2025) is an overt clone, but GOLIATH's 18-month head start, larger community, and sole-developer authenticity give it meaningful brand loyalty. The real risk is not competition â€” it's whether a 1-2 person studio can sustain the update cadence, server infrastructure, and bug resolution velocity that a live-service game demands.