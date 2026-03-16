# WarSignalAir Design Review Swarm — CLAUDE.md

## Overview

This swarm validates **design documents** for WarSignalAir, an iOS cyberpunk gunship game in **Phase 0 (pre-code)**.

**Key Difference**: Unlike other swarms that test/fix code, this swarm:
- ✗ Does NOT build Swift code
- ✗ Does NOT run unit tests
- ✗ Does NOT analyze Xcode projects
- ✓ DOES validate design documents
- ✓ DOES check cross-references
- ✓ DOES assess readiness for Phase 1

## Project Context

| Attribute | Value |
|-----------|-------|
| Project | WarSignalAir |
| Status | Phase 0 (design-only, no code) |
| Engine | SceneKit + SwiftUI |
| Target | iOS 26+, iPhone 17 Pro Max, landscape-only |
| Sister | GridWatchZero (proven patterns) |
| Documents | CLAUDE.md, ARCHITECTURE.md, GAME_DESIGN.md, PROJECT_PLAN.md, ASSET_MANIFEST.md, MILESTONES.md |

## Swarm Architecture

Four agent types run in sequence:

### 1. Doc-Reviewer

**Role**: Analyze document completeness, cross-references, readiness

**Input**: All design documents on disk

**Output**: doc-review.json (structured findings)

**Functions**:
- Run `xb_doc_check` (document presence, line counts, conflict markers)
- Run `xb_arch_readiness` (SceneKit patterns, folder structure, Phase 1 criteria)
- Run `xb_sister_check` (GridWatchZero alignment)
- Assess completeness of each document
- Check cross-references between docs
- Evaluate Phase 1 readiness

**Success**: doc-review.json with findings categorized as:
- missing-doc
- incomplete-section
- inconsistency
- cross-ref-broken
- readiness-gap

### 2. Design-Planner

**Role**: Prioritize issues, plan remediation

**Input**: doc-review.json (doc-reviewer's findings)

**Output**: design-plan.md (actionable checklist)

**Functions**:
- Read doc-review.json
- Prioritize: missing docs > critical sections > cross-refs > consistency > optimization
- Estimate effort for each fix
- Mark which issues block Phase 1
- Create checklist for doc-writer

**Success**: design-plan.md with clear remediation steps

### 3. Doc-Writer

**Role**: Implement improvements

**Input**: design-plan.md (doc-planner's checklist)

**Output**: Modified documents, git commits

**Functions**:
- Create branch: `swarm/design-<SESSION_ID>`
- For each item in design-plan.md:
  - Read document
  - Add/fix section per plan
  - Commit change
- Push branch when complete
- **CRITICAL**: No Swift files, only Markdown

**Success**: All items from design-plan.md implemented, each with a git commit

### 4. Design-Verifier

**Role**: Verify improvements, assess Phase 1 readiness

**Input**: Modified documents, git commits

**Output**: verification.md, session-summary.md

**Functions**:
- Re-run `xb_doc_check`, `xb_arch_readiness`, `xb_sister_check`
- Compare before/after results
- Verify cross-references are consistent
- Produce verification.md with READY_FOR_PHASE_1 recommendation
- Produce session-summary.md with outcomes

**Success**: Clear READY_FOR_PHASE_1 or NOT_READY recommendation

## Validators (xcode-bridge)

Available functions (defined in `swarm/scripts/xcode-bridge.sh`):

### xb_doc_check()

Validates document presence and basic structure:

```bash
# Outputs to: swarm/artifacts/doc-validation.txt
# Checks:
#  - Each required doc exists
#  - Line counts for each doc
#  - No conflict markers (<<<, >>>, ===)
#  - Basic cross-reference counts
```

### xb_arch_readiness()

Checks architecture completeness for Phase 1:

```bash
# Outputs to: swarm/artifacts/arch-readiness.txt
# Checks:
#  - Folder structure defined in ARCHITECTURE.md
#  - SceneKit patterns mentioned
#  - Phase 1 criteria from MILESTONES.md
```

### xb_sister_check()

Verifies GridWatchZero pattern alignment:

```bash
# Outputs to: swarm/artifacts/sister-alignment.txt
# Checks:
#  - GridWatchZero directory exists
#  - Proven patterns available (GameEngine split, @Observable, save/load)
#  - WarSignalAir docs reference these patterns
```

### xb_mark_run()

Marks when the last run occurred:

```bash
# Outputs to: swarm/artifacts/.last-run
# Simple timestamp file
```

## Document Reading Order

Agents always read documents in this order (per CLAUDE.md in project root):

1. **CLAUDE.md** — Operating rules, architecture decisions
2. **ARCHITECTURE.md** — Engine choice, data flow, game loop, folder structure
3. **GAME_DESIGN.md** — Weapons, enemies, missions, progression
4. **PROJECT_PLAN.md** — Phase checklist, current status
5. **ASSET_MANIFEST.md** — Asset inventory and status
6. **MILESTONES.md** — Acceptance criteria for each phase

## Artifact Outputs

All artifacts go to `swarm/artifacts/`:

| File | Source | Purpose |
|------|--------|---------|
| doc-validation.txt | xb_doc_check | Document presence, line counts |
| arch-readiness.txt | xb_arch_readiness | Architecture readiness check |
| sister-alignment.txt | xb_sister_check | Sister project alignment |
| doc-review.json | doc-reviewer agent | Structured findings |
| design-plan.md | design-planner agent | Remediation checklist |
| verification.md | design-verifier agent | Before/after comparison |
| session-summary.md | design-verifier agent | Session overview |
| build-summary.json | xb_doc_check | Quick status |

## Git Workflow

### Branch Strategy

- Branch name: `swarm/design-<SESSION_ID>` (created by doc-writer)
- Each change gets a separate commit
- No force-push, no history rewriting
- Push when complete (optional but recommended)

### Commit Messages

```
docs: <what changed> in <document>

Brief explanation if needed.

Example:
  docs: add folder structure to ARCHITECTURE.md
  
  Defines Engine/, UI/, Models/, Config/ layout.
  Required for Phase 1 file organization.
```

### Example Session

```bash
# doc-writer creates branch
git checkout -b swarm/design-1704067200-1234

# Make changes one at a time
git add ARCHITECTURE.md
git commit -m "docs: add folder structure to ARCHITECTURE.md"

git add PROJECT_PLAN.md
git commit -m "docs: enhance phase 1 checklist"

# Push for review/reference
git push -u origin swarm/design-1704067200-1234
```

## Phase 0 vs Phase 1

### Phase 0 (Current)

- ✓ Design documents only
- ✓ No Xcode project
- ✓ No Swift code
- ✓ This swarm validates design completeness
- **Goal**: Ready for Phase 1

### Phase 1 (Next)

- ✓ Create Xcode project (WarSignal.xcodeproj)
- ✓ Set up folder structure per ARCHITECTURE.md
- ✓ Build basic SceneKit scene
- ✓ Implement OrbitalCamera, Reticle, basic HUD
- ✓ All decisions from ARCHITECTURE.md become code
- ✓ Use MILESTONES.md acceptance criteria to confirm done

## Success Criteria

This swarm succeeds if:

1. **doc-review.json is complete**: All doc issues identified and categorized
2. **design-plan.md is clear**: Every issue has a remediation step
3. **All improvements implemented**: doc-writer completes all items in design-plan.md
4. **verification.md shows progress**: Before/after comparison, issues resolved
5. **READY_FOR_PHASE_1 declared**: design-verifier confirms Phase 1 can start
6. **Git history is clean**: Each change documented with a commit

## Running the Swarm

### From macOS Finder

Double-click: `swarm/SwarmFireOff.command`

### From Command Line

```bash
cd /path/to/WarSignalAir/swarm/scripts
./fire-swarm.sh
```

### Output

```
════════════════════════════════════════════════════════════
    WARSIGNALAIR DESIGN REVIEW SWARM
════════════════════════════════════════════════════════════

Session: 1704067200-5678
Start time: Thu Jan 1 12:34:56 PST 2026

[swarm] Running pre-flight validation...
[swarm] 1. Document check...
[swarm] 2. Architecture readiness check...
[swarm] 3. Sister project alignment check...
[swarm] Pre-flight complete

[swarm] PHASE 1: DOCUMENT REVIEW (doc-reviewer agent)
[doc-reviewer] Analyzing document completeness...
...

[swarm] PHASE 2: DESIGN PLANNING (design-planner agent)
[design-planner] Prioritizing improvements...
...

[swarm] PHASE 3: DOCUMENT WRITING (doc-writer agent)
[doc-writer] Implementing improvements...
...

[swarm] PHASE 4: VERIFICATION (design-verifier agent)
[design-verifier] Verifying improvements...
...

════════════════════════════════════════════════════════════
    DESIGN REVIEW SWARM COMPLETE
════════════════════════════════════════════════════════════

Key artifacts:
  - doc-review.json: Document completeness analysis
  - design-plan.md: Planned document improvements
  - verification.md: Before/after validation results
  - session-summary.md: Session overview
```

## Troubleshooting

### Fire-swarm.sh fails at doc-reviewer

**Symptom**: doc-review.json not created

**Fix**: Check that all 5 required documents exist:
```bash
ls -la ARCHITECTURE.md GAME_DESIGN.md PROJECT_PLAN.md ASSET_MANIFEST.md MILESTONES.md
```

### Design-plan.md not created

**Symptom**: "GATE FAILURE: design-plan.md not found"

**Fix**: Check doc-review.json was valid:
```bash
cat swarm/artifacts/doc-review.json | jq .   # should be valid JSON
```

### Doc-writer gets stuck

**Symptom**: Agent can't apply fixes

**Fix**: Verify design-plan.md items have clear content:
```bash
grep "Content to Add:" swarm/artifacts/design-plan.md
```

## References

- **CLAUDE.md** (project root) — Master architecture document
- **ARCHITECTURE.md** — Engine decisions, folder structure
- **xcode-bridge.sh** — Validator functions
- **GridWatchZero** (sister project) — Proven patterns
