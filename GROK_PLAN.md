# GROK_PLAN.md

## 1. Understanding of the Project's Visual Identity Challenge

The central challenge is to create a visual system that feels like peering through a real AC-130 targeting pod while infusing a gritty, oppressive cyberpunk noir atmosphere that Goliath lacks entirely. Goliath succeeds with authentic FLIR thermal imaging—monochromatic, high-contrast, scan-line artifacts—but remains purely military-sim without personality. WarSignal must match that thermal authenticity as table stakes, then layer a "Sin City meets Ghost in the Shell" identity: urban decay, moral ambiguity, selective neon bleeding through darkness, and a constant sense of rain-slick concrete and flickering corporate signage. The thermal view must dominate 95% of gameplay time, with color reserved for emotional punctuation (menus, briefings, rare enhanced-view moments). Everything must read clearly on grayscale while allowing controlled bursts of cyan, magenta, and acid green to evoke dystopian menace without breaking immersion. SceneKit + SwiftUI + Liquid Glass gives us a unique opportunity to make the HUD feel like physical glass etched with targeting data, not floating mobile UI.

## 2. Color Palette Proposal

### Thermal Ramp (6 Stops for finer control)
- Stop 1 (Coldest/Deep Background): #000000 (pure black for shadows and voids)
- Stop 2 (Cool Terrain): #121212 (near-black for asphalt and concrete)
- Stop 3 (Neutral Structures): #2E2E2E (dark gray for buildings and debris)
- Stop 4 (Warm Objects): #5A5A5A (mid gray for vehicles and low-heat elements)
- Stop 5 (Hot Sources): #A8A8A8 (bright gray for fires and active machinery)
- Stop 6 (Hottest/Enemies & Muzzle Flash): #FFFFFF (pure white with strong bloom)

### HUD Accent Colors
- Primary Cyan (default reticle, text, borders): #00D0FF (bright, electric targeting-pod cyan)
- Active/Selected State: #00FFFF (full-intensity cyan)
- Alert Red (enemy lock, damage): #FF0033 (aggressive red with slight magenta bias)
- Warning Yellow (friendly lock, danger-close): #FFFF00 (harsh military yellow)
- Disabled/Inactive: #004455 (deep desaturated teal)

### Marker Colors
- Friendly (GridWatch team): #00D0FF outlines + subtle blue glow in enhanced view
- Hostile (enemies): Pure white-hot in thermal; #FF0033 in enhanced view
- Objective: #FFD700 (gold, high visibility)
- Neutral/Civilian: #808080 (neutral gray, low contrast to discourage targeting)

### Menu/UI Colors
- Background Base: #0A0A0A (near-black with subtle noise texture)
- Panel Glass: Liquid Glass with #000000 at 40% opacity + blur 12
- Primary Text: #E0E0E0 (light gray)
- Secondary Text: #808080
- Accent/Interactive: #00D0FF
- Confirmation/Success: #00FF9D (acid mint)
- Error/Danger: #FF0033

### Neon Accent Palette (Enhanced View & Menus Only)
- Corporate Magenta: #FF00AA
- Electric Cyan: #00D0FF (shared with HUD primary)
- Acid Green: #00FF9D
- Toxic Purple: #9D00FF
- Warning Orange: #FF5500

Usage Rule: In thermal mode, no neon may appear except as subtle bleed-through on hottest sources (e.g., flickering sign at 10% opacity).

## 3. Typography Proposal

All fonts must be system-available or easily bundled; prioritizing legibility at small sizes on grayscale.

- **HUD Data Readouts** (ammo counts, coordinates, timers): **OCR-A (bundled) or SF Mono Bold** — Monospaced, mechanical, evokes 1970s military terminals and targeting computers. High x-height, open counters for instant readability during motion.
- **HUD Labels** (weapon names, system status): **DIN Condensed Bold** — Condensed industrial sans-serif, angular, feels stamped on metal. Perfect weight for hierarchy without overwhelming the screen.
- **Menu Headers** (mission titles, hangar sections): **Rajdhani Bold** — Geometric, slightly futuristic sans with sharp terminals. Gives a corporate-military propaganda feel without being overly sci-fi.
- **Briefing Body Text** (mission descriptions, lore): **Courier New Bold** — Classic monospaced typewriter font processed with subtle glitch distortion. Reinforces hacked transmission aesthetic and cyberpunk authenticity.

Hierarchy enforced via size + weight + subtle scan-line overlay shader on HUD text.

## 4. HUD Design Approach

The HUD must feel like a physical layer of aircraft glass between player and world—never like a mobile game overlay.

- **Reticle**: Four corner L-brackets (#00D0FF, 3px stroke, 60% opacity) forming a 180×180px framing square. Central crosshair with 12px gap, thin lines. Pulsing center dot (0.6s cycle, 30–100% opacity). Compass markers at bracket midpoints (N/E/S/W in OCR-A 14pt). State changes: default cyan → red pulse on hostile → flashing yellow + "DANGER CLOSE" warning on friendly. Subtle vignette + scan-line distortion applied via SCNTechnique.
- **Health Bar**: Bottom-left horizontal bar, segmented into 10 blocks. Hull (#00D0FF fill on #121212 bg with etched borders). Shield overlay (4 blocks, darker cyan). Damage causes brief red flash + distortion ripple. Liquid Glass panel with 0.4 thickness.
- **Weapon Selector**: Right-side vertical stack of three rectangular glass panels (110×60px each). Icon centered, ammo count below in OCR-A. Selected panel brighter cyan border + subtle glow. Inactive panels 40% opacity. Tap animation: brief scale + glass refraction shift.
- **Mission Info Panel**: Top-left glass panel (240×120px) with etched border. Hierarchical text: 28pt Rajdhani objective title, 18pt SF Mono details, timer in OCR-A. Background blur reveals underlying thermal scene for immersion.

All panels use .glassEffect(thickness: 0.6, blur: 14) with dark tint to feel like cockpit instrumentation.

## 5. Asset Prompt Strategy

Standardized template: "[Perspective/Resolution] + [Subject] + [Environment/Details] + [Style References] + [Lighting/Mood] + [Technical Constraints] + [Consistency Tags]".

Batch by category, reference existing three levels for continuity. Generate variants and iterate.

**Example Prompt — Level Background (Level 4: Iron Gate)**:
"Top-down aerial orthographic view, 4096x4096 PNG, cyberpunk industrial perimeter zone at night, sprawling warehouses with corrugated metal roofs, chain-link fences with razor wire, loading docks with stacked cargo containers, scattered industrial vehicles and debris, urban decay with rust stains and graffiti, subtle flickering neon signage in magenta and cyan, high-contrast noir atmosphere blending real AC-130 FLIR footage with Sin City and Ghost in the Shell, dark grayscale palette optimized for thermal vision gameplay with white-hot heat sources, dramatic long shadows from security lights, atmospheric haze and smoke, ultra-detailed textures, realistic scale --ar 1:1 --v 6 --q 2 --stylize 250"

**Example Prompt — Enemy Silhouette (RPG Trooper)**:
"Top-down orthographic silhouette, 512x512 PNG with transparent background, cyberpunk mercenary with tactical gear, ballistic helmet, body armor, holding RPG launcher aimed upward, dynamic crouched firing pose, high-contrast pure white fill with sharp black outlines, angular military-noir style optimized for white-hot FLIR thermal imaging, no internal details or color, vector-clean edges for scalability, menacing posture --ar 1:1 --v 6 --stylize 100"

## 6. Music/Audio Direction

Overall vision: Oppressive industrial synthwave with slow builds and sudden chaotic releases, evoking isolation in the cockpit above a dying city.

- **Menu/Hangar**: BPM 70–85, minor key ambient pads, distant rain and city hum, sparse melodic arpeggios in cyan-tinted synths, melancholic and reflective.
- **Mission Start/Ambient**: BPM 90–110, low drone with subtle heartbeat kick, layered with environmental ambience (wind, distant sirens, power hum per level).
- **Combat Low Intensity**: BPM 110–130, introduce metallic percussion and rising tension leads, weapon impacts sync to rhythm.
- **Combat High Intensity**: BPM 140–160, distorted bass, aggressive sawtooth leads, chaotic glitch elements, volume swells with enemy waves.
- **Victory**: BPM 100 slowdown, resolving major chord swell, heroic but bittersweet synth melody.
- **Defeat**: BPM 60 decrescendo to silence, echoing drone fade with distorted radio chatter.

**Weapon Sounds**:
- Vulcan: Mechanical spin-up + rapid metallic buzzing impacts
- Havoc: Sharp whoosh launch + mid-range explosion with debris scatter
- Reaper: Deep bass-heavy thunk + delayed massive crater boom with reverb

## 7. Delivery Plan

- **Phase 1**: Full Visual Identity Guide v1 (colors, typography, HUD specs, Liquid Glass guide)
- **Phase 2**: Asset prompt templates + first batch generation (remaining 7 level backgrounds + Wraith concepts)
- **Phase 3**: Enemy silhouettes (11) + friendly markers
- **Phase 4**: Character portraits (12) + icons
- **Phase 5**: UI icons, backgrounds, logo/branding
- **Phase 6**: Effect style guide + explosion/tracer specs
- **Phase 7**: Audio direction brief refinement + mood board tracks
- **Phase 8**: Final asset polish + full guide v2 with integration notes

Guide delivered first to lock team alignment.

## 8. Risks and Concerns

- Thermal shader conflicts with subtle neon bleed-through (risk of washing out cyberpunk identity)
- Liquid Glass performance on older devices (potential FPS impact in dense scenes)
- AI image generation consistency across 75 assets (style drift without rigorous templating)
- Over-use of color breaking thermal immersion
- Audio escalation feeling generic without strong per-level variation

## 9. Questions for the PM

1. Exact character names and visual descriptions for the 12 portraits?
2. Preferred AI image generation tool (Midjourney, Flux, Ideogram, etc.)?
3. Any existing SCNTechnique thermal shader code to reference for color ramp integration?
4. Target device range for Liquid Glass performance testing?
5. Plans for dynamic radio chatter visualizers (waveforms, etc.) in HUD?