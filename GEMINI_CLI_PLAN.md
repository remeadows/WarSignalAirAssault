# GEMINI CLI - QA & Technical Analysis Plan

**To**: Claude Opus, Project Manager
**From**: Gemini CLI, Technical Analyst & QA Engineer Candidate
**Date**: 2026-02-12
**Subject**: Proposed QA, Testing, and Integration Strategy for WarSignal AirAssault

This document outlines my approach to ensuring technical quality, performance, and architectural integrity for the WarSignal AirAssault project.

---

### 1. Understanding the QA Challenge

A multi-agent, AI-driven development process presents unique QA challenges not found in traditional workflows. The core risk is **integration, not implementation**. While each specialized agent (Claude, GPT, Grok, Gemini, Codex) can produce high-quality individual components, the project's success hinges on these components working together flawlessly.

My role is to act as the central QA hub, focusing on the seams between these components. Structured testing is critical because:
- **No Single Source of Truth**: The project's "intent" is distributed across multiple agent prompts and outputs. A rigorous, documented test plan becomes the canonical source of truth for expected behavior.
- **Implicit Assumptions**: One agent's output is based on an assumption that may be violated by another's. Gemini's economy balance assumes a certain enemy density, which Claude's code must deliver. I will test these assumptions explicitly.
- **Architectural Adherence**: LLM-generated code can be functionally correct but architecturally non-compliant (e.g., creating a convenient but illegal link between the UI and game engine). Automated and manual checks are needed to enforce the project's strict data flow.
- **Emergent Bugs**: The most critical bugs will arise from the interaction of systems (e.g., a physics event, a save operation, and a UI update happening in the same frame). These emergent issues are unlikely to be caught by any single specialist agent.

### 2. Testing Philosophy

My philosophy is to **Trust, but Verify, with Data**. For a game where "feel" is paramount, my approach is one of **structured subjectivity**, backed by objective data.

- **Hybrid Model**: I will blend quantitative, tool-based analysis (Instruments, debug overlays) with qualitative, checklist-driven playtesting.
- **Deconstructing "Feel"**: Subjective criteria will be broken down into measurable components. "Smooth camera" becomes a test case verifying "no visible stutter during 360° orbit at max zoom, maintaining 60fps."
- **Rigorous Gates**: The "Playtest Gate" at the end of each phase is the most critical process. My deliverable will be a clear, data-rich report with a "Go / No-Go" recommendation. A "No-Go" will be accompanied by a precise list of failing test cases, performance regressions, and architectural violations.
- **Automation Where Possible**: I will advocate for and, if necessary, write unit tests for "pure" logic components like Codex's `SaveManager` and `ConfigLoader`. This frees up playtesting time to focus on the visual, interactive core loop.

### 3. Phase 1 Playtest Checklist: Foundation

This checklist covers the core deliverables of Phase 1. Each test will be performed on the target device.

| ID | Category | Test Case Description | Steps | Expected Result |
|---|---|---|---|---|
| **P1-CAM-01** | Camera | Orbit Smoothness | 1. Let the game idle. | The gunship completes a full 360° orbit without any hitches, stutters, or noticeable frame drops. |
| **P1-CAM-02** | Camera | Altitude Consistency | 1. Observe the orbit for 30 seconds. | The camera's altitude and distance from the center point remain constant. The ground plane does not appear to move closer or farther away. |
| **P1-CAM-03** | Camera | Zoom In | 1. Perform a two-finger pinch-out gesture. | The camera smoothly zooms in to the next discrete zoom level. The process takes <250ms. |
| **P1-CAM-04** | Camera | Zoom Out | 1. Perform a two-finger pinch-in gesture. | The camera smoothly zooms out to the previous discrete zoom level. The process takes <250ms. |
| **P1-CAM-05** | Camera | Zoom Level Clamping | 1. Zoom all the way in. 2. Attempt to zoom in further. 3. Zoom all the way out. 4. Attempt to zoom out further. | The camera stops at the maximum (level 3) and minimum (level 1) zoom levels and does not respond to further gestures in that direction. |
| **P1-CAM-06** | Camera | Orbit and Zoom | 1. While the camera is orbiting, perform a zoom-in or zoom-out gesture. | The camera smoothly zooms without interrupting the orbit's path or velocity. |
| **P1-RET-01** | Reticle | Touch-to-World Accuracy (Center) | 1. Tap the exact center of the screen. | The targeting reticle instantly appears at the `(0, 0, 0)` world coordinate on the ground plane. |
| **P1-RET-02** | Reticle | Touch-to-World Accuracy (Edge) | 1. While the camera orbits, tap a static point near the edge of the screen (e.g., a specific mark on the ground texture). | The reticle appears within a 5-pixel radius of the touch point on screen. |
| **P1-RET-03** | Reticle | Reticle Movement | 1. Place a finger on the screen and drag it in a circle. | The reticle follows the finger's position on the ground plane smoothly and without lag (<16ms latency). |
| **P1-RET-04** | Reticle | Visibility | 1. Observe the reticle as the gunship orbits over different ground textures (if any). | The reticle remains clearly visible at all times, with sufficient contrast against the background. |
| **P1-RET-05** | Reticle | Off-screen Drag | 1. Place a finger on the screen. 2. Drag it off the edge of the device screen and back on. | The reticle follows the finger to the edge, stays at the edge, and correctly resumes tracking when the finger re-enters the screen. |
| **P1-GND-01** | Ground | Ground Plane Rendering | 1. Observe the ground plane. | The ground plane renders as a flat, continuous surface with no visible tears, z-fighting, or holes. |
| **P1-HUD-01** | HUD | Shell Integrity | 1. Examine the screen overlay. | All UI elements specified in the Phase 1 HUD shell are present in their correct positions (e.g., placeholders for score, weapon selection, health). |
| **P1-HUD-02** | HUD | Layout on Target Device | 1. Run the app on the primary target iPhone model. | The HUD layout is not clipped, stretched, or overlapping. It respects the safe areas (notch, dynamic island). |
| **P1-HUD-03** | HUD | Landscape Orientation Lock | 1. Attempt to rotate the device to portrait orientation. | The app remains locked in landscape mode. |
| **P1-PERF-01** | Performance | Baseline Frame Rate | 1. Connect to Instruments (Core Animation). 2. Let the game run for 60 seconds without interaction. | The frame rate graph shows a flat line at 60 FPS, with no more than 1-2 dropped frames over the entire duration. |
| **P1-PERF-02** | Performance | Baseline Memory | 1. Connect to Instruments (Allocations). 2. Let the game run for 60 seconds. | Memory allocation remains stable after initial load. There are no signs of a continuously growing memory footprint. |
| **P1-PERF-03** | Performance | Startup Time | 1. Use Instruments (Time Profiler) to measure from app launch to the main menu being interactive. | The total time is less than 3 seconds. |
| **P1-CTRL-01** | Controls | Rapid Taps | 1. Rapidly tap different locations on the screen. | The reticle correctly appears at each new tap location without getting "stuck" or missing inputs. |
| **P1-CTRL-02** | Controls | Input Latency | 1. Tap the screen. | The visual response of the reticle appearing feels instantaneous (<16ms, or one frame). |

### 4. Performance Testing Approach

Performance is not a feature; it's a prerequisite. My approach is to establish baselines early and enforce a performance budget throughout development.

- **Primary Tool**: Xcode Instruments.
- **Methodology**:
    1.  **Establish Baselines (Phase 1)**: Using the `P1-PERF` test cases, I will record the "idle" performance cost of the basic game loop on our primary target device. This includes:
        -   **FPS**: `Core Animation` instrument. The target is a stable 60.
        -   **CPU Usage**: `Time Profiler` instrument. Focus on time spent inside `GameEngine.renderer(_:updateAtTime:)`.
        -   **Memory**: `Allocations` and `Leaks` instruments. Record the persistent memory footprint.
    2.  **Define Stress Scenarios**: For each phase, I will define a specific, repeatable, worst-case scenario to measure the performance impact of new features.
        -   *Example (Phase 3)*: Spawn max enemies (186), have 50% of them be AA turrets firing at the player, while the player fires the most performance-intensive weapon continuously. Thermal shader OFF.
        -   *Example (Phase 6)*: Repeat the Phase 3 stress test with the Thermal shader ON.
    3.  **Enforce Budgets**:
        -   **Frame Budget (16.67ms)**: Using the Time Profiler, I will analyze the cost of each major subsystem (Physics, AI, Rendering, etc.). If a new feature pushes the total frame time over 16ms in a stress test, it fails the gate.
        -   **Memory Budget**: I will define a memory budget per entity type (e.g., a grunt soldier should not exceed 256KB of memory for its node, components, and associated data).
        -   **Regression Thresholds**: A phase will be flagged for review if its stress test shows a >10% performance degradation (e.g., average FPS drops from 60 to 54) compared to the previous phase's test.

### 5. Architecture Violation Detection

I will use a combination of static analysis, code review, and runtime checks to enforce the unidirectional data flow. Here are the specific patterns I will look for:

| Violation | Incorrect Code Example (Anti-Pattern) | Correct Code Example (Pattern) |
|---|---|---|
| **1. SwiftUI Writes to SceneKit** | `// In a SwiftUI View...`<br>`@State var gameScene: SCNScene`<br>`Button("Fire") { gameScene.rootNode.childNode(...) }` | `// In a SwiftUI View...`<br>`@Environment(GameState.self) var state`<br>`Button("Fire") { state.sendCommand(.fireWeapon) }` |
| **2. GameEngine Reads from SwiftUI** | `// In GameEngine.swoft`<br>`var hudView: HUDView?`<br>`if hudView.isShowingDebugMenu { ... }` | `// In GameEngine.swift`<br>`var gameState: GameState`<br>`if gameState.isDebugMenuVisible { ... }` |
| **3. State Mutation off Main Thread** | `// In some async callback`<br>`DispatchQueue.global().async {`<br>  `self.gameState.score += 10`<br>`}` | `// Ensure the calling function is @MainActor`<br>`// or dispatch explicitly...`<br>`DispatchQueue.main.async {`<br>  `self.gameState.score += 10`<br>`}` |
| **4. Bypassing Unidirectional Flow** | `// GameEngine sends a direct notification`<br>`NotificationCenter.default.post(...)`<br><br>`// SwiftUI View listens for it`<br>`.onReceive(NotificationCenter.default.publisher(...))` | `// In GameEngine`<br>`gameState.score = newScore`<br><br>`// In SwiftUI View`<br>`@Environment(GameState.self) var state`<br>`Text("Score: \(state.score)")` |
| **5. Object Allocation in Game Loop** | `// Inside renderer(_:updateAtTime:)...`<br>`let projectile = SCNNode(...)`<br>`scene.rootNode.addChildNode(projectile)` | `// In GameEngine...`<br>`let projectile = projectilePool.get()`<br>`projectile.isHidden = false`<br>`projectile.position = ...` |

### 6. Edge Case Catalog

My testing will prioritize these non-obvious failure modes that specialist agents might overlook.

1.  **Pooling**: What happens if the explosion effect pool is exhausted by a massive chain reaction? (Expected: Oldest explosions are recycled, no crash).
2.  **Pooling**: Firing a weapon fast enough to exhaust the projectile pool. (Expected: Oldest active projectile is immediately reset and fired again, no new allocation).
3.  **Physics**: A high-velocity projectile hitting two enemies in the exact same frame. (Expected: Both register hits, or the first one does and the projectile is consumed).
4.  **Physics**: An enemy being killed by splash damage and a direct hit simultaneously. (Expected: Score is only awarded once, no crashes).
5.  **Physics**: High-speed projectiles "tunneling" through thin enemy colliders. (Will test by firing at fast-moving, thin enemies).
6.  **Save/Load**: Saving the game during a highly dynamic moment (e.g., mid-explosion with multiple projectiles in the air). (Expected: Load completes successfully and restores a stable state).
7.  **Save/Load**: Loading a save file where the player has more currency than `Int.max`. (Expected: Handled gracefully, no overflow crash).
8.  **Save/Load**: Manually editing a save file with invalid data and attempting to load. (Expected: The app detects corruption and either loads defaults or alerts the user).
9.  **Input**: Placing two fingers for a zoom gesture, then lifting one and dragging the other. (Expected: Seamlessly transitions from zoom to reticle drag).
10. **Input**: Tapping the UI (e.g., weapon switch button) and the game world in the same frame. (Expected: Both inputs are respected, or the UI input takes priority).
11. **State**: The app is backgrounded and then resumed. (Expected: Game state is preserved, rendering continues, no crashes).
12. **State**: Receiving a phone call or system alert mid-game. (Expected: Game pauses correctly and resumes without issue).
13. **Performance**: Enabling the thermal shader while 100+ explosions are on screen. (Expected: Frame rate may dip but recovers, does not crash).
14. **Audio**: Firing all weapons simultaneously. (Expected: Audio mixes correctly, no terrible clipping or distortion).
15. **Integration**: Loading a mission with a narrative script that is longer than the UI text box can handle. (Expected: Text truncates gracefully, no layout explosion).

### 7. Integration Validation Approach

I will serve as the integration point for all agent deliverables.

-   **Gemini (Economy)**:
    -   **Schema Validation**: All JSON config files will be parsed by Codex-provided `Codable` structs as part of the build process. A malformed file from Gemini will fail the build.
    -   **Semantic Validation**: I will write simple unit tests to check for logical errors (e.g., `XCTAssert(upgradeCost > baseCost)`).
-   **GPT (Narrative)**:
    -   **Content Rendering Test**: I will create a debug SwiftUI view that iterates through and displays *every* string provided by GPT (briefings, radio chatter). This will be visually scanned for formatting errors, un-replaced placeholders (e.g., `[ENEMY_NAME]`), and overflow.
-   **Grok (Art Director)**:
    -   **Visual Spec Compliance**: I will use a "visual diff" approach. I will take screenshots of the running app and overlay Grok's spec images (e.g., HUD layout) to check for pixel-level alignment, color, and font mismatches.
    -   **Asset Validation**: A checklist will verify that the assets used in the build (e.g., `reticle.png`) match the names and specifications from Grok.
-   **Codex (Utility)**:
    -   **Unit Test Coverage**: I will ensure that utility code like `SaveManager` and `ConfigLoader` has a corresponding suite of unit tests that I can run. I will treat Codex's code as a third-party library that must be verified independently.

### 8. Delivery Plan

My work will be delivered in sync with the project's 8 phases.

-   **Phase 0 (Setup)**: Deliver the initial versions of `QA_STRATEGY.md`, `PERFORMANCE_PLAN.md`, `CODE_REVIEW_STANDARDS.md`, and `INTEGRATION_PLAN.md`.
-   **During Phases 1-8**:
    -   For each new feature, I will add corresponding test cases to `PLAYTEST_CHECKLISTS.md`.
    -   I will perform ongoing regression testing using checklists from prior phases.
    -   I will review Claude Code's submissions against the `CODE_REVIEW_STANDARDS.md`.
-   **End of Each Phase (Gate)**: I will deliver a concise **Phase Sign-Off Report** containing:
    1.  A link to the executed `PLAYTEST_CHECKLISTS.md` with Pass/Fail for every item.
    2.  An Instruments performance report (screenshots and key metrics).
    3.  A list of new bugs found and any regressions.
    4.  A "Go / No-Go" recommendation for proceeding to the next phase.

### 9. Risks and Concerns in a Multi-Agent Workflow

-   **Specification Drift**: Grok's visual spec or Gemini's balance numbers may be updated independently, causing them to fall out of sync with Claude's code. My continuous integration testing is the primary mitigation.
-   **Implicit Knowledge Gaps**: A bug may arise from an interaction that no single agent is aware of. For example, Gemini balances the economy assuming a 5-minute level time, but GPT's mission objectives cause levels to last 10 minutes. My role is to find these cross-domain disconnects.
-   **Debugging Unconventional Code**: LLM-generated code, while functional, may lack human-like structure, making it difficult to debug. My enforcement of strict architectural patterns is the best defense, as it guarantees a predictable structure regardless of the code's origin.

### 10. Questions for the Project Manager

1.  **Tooling & Access**: To be effective, I require read/write access to the project's Git repository to add test targets, debug views, and validation scripts. Is this permissible?
2.  **Test Device Matrix**: Is the "iPhone 12" a representative older device, or is it the absolute minimum spec? Defining the official minimum-spec device is critical for setting performance thresholds.
3.  **Bug Reporting Protocol**: What is the formal process for reporting a failed test case? Should I create a file in `ISSUES.md`, or directly prompt Claude Code with the failure report?
4.  **Gate Authority**: If I issue a "No-Go" on a phase gate due to a critical bug or performance regression, do I have the authority to halt the project's progression to the next phase until the issue is resolved and re-verified?
5.  **Arbiter of "Feel"**: The playtest gates rightly emphasize that the game must "feel" better. Who is the final arbiter of this subjective quality? Is it the PM, a panel, or is my structured report on the matter the deciding factor?

---

I am confident that this structured, data-driven, and integration-focused approach will ensure we ship a high-quality, performant, and architecturally sound game. I look forward to discussing this plan further.