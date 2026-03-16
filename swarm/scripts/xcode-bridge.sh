#!/usr/bin/env bash
# xcode-bridge.sh — Document & Design validation for WarSignalAir swarm agents
# NOTE: WarSignalAir is Phase 0 (pre-code). No xcodeproj exists yet.
# This bridge validates architecture docs, design consistency, and pre-build readiness.
set -uo pipefail

# ── Project Constants ────────────────────────────────────────
SWARM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "$SWARM_ROOT/.." && pwd)"
# No XCODEPROJ — project hasn't been created yet
SCHEME="WarSignal"  # Planned scheme name per CLAUDE.md

# ── Build (stub — no project yet) ───────────────────────────
xb_build() {
  echo "[xcode-bridge] WARNING: WarSignalAir has no Xcode project yet (Phase 0)."
  echo "[xcode-bridge] Running document validation instead..."
  xb_doc_check
}

xb_test() {
  echo "[xcode-bridge] WARNING: WarSignalAir has no test target (Phase 0)."
  xb_doc_check
}

xb_uitest() {
  echo "[xcode-bridge] WARNING: WarSignalAir has no UI test target (Phase 0)."
  return 0
}

xb_analyze() {
  echo "[xcode-bridge] WARNING: WarSignalAir has no code to analyze (Phase 0)."
  xb_doc_check
}

xb_concurrency_check() {
  echo "[xcode-bridge] WARNING: WarSignalAir has no code (Phase 0)."
  return 0
}

# ── Document Validation (primary capability) ─────────────────
xb_doc_check() {
  echo "[xcode-bridge] Validating design documents..."
  local outfile="$SWARM_ROOT/artifacts/doc-validation.txt"
  > "$outfile"

  # Required documents per CLAUDE.md document review order
  local required_docs=("ARCHITECTURE.md" "GAME_DESIGN.md" "PROJECT_PLAN.md" "ASSET_MANIFEST.md" "MILESTONES.md")
  echo "=== Required Document Status ===" >> "$outfile"
  for doc in "${required_docs[@]}"; do
    if [[ -f "$PROJECT_ROOT/$doc" ]]; then
      local lines
      lines=$(wc -l < "$PROJECT_ROOT/$doc" | tr -d ' ')
      echo "PRESENT: $doc ($lines lines)" >> "$outfile"
    else
      echo "MISSING: $doc" >> "$outfile"
    fi
  done

  # Check for conflict markers in docs
  echo "=== Conflict Markers ===" >> "$outfile"
  grep -rn "<<<<<<\|>>>>>>\|======" "$PROJECT_ROOT"/*.md 2>/dev/null >> "$outfile" || echo "None found" >> "$outfile"

  # Check cross-references between docs
  echo "=== Cross-Reference Integrity ===" >> "$outfile"
  # ARCHITECTURE.md should reference GAME_DESIGN.md patterns
  if [[ -f "$PROJECT_ROOT/ARCHITECTURE.md" ]]; then
    local refs
    refs=$(grep -c "GAME_DESIGN\|PROJECT_PLAN\|MILESTONES" "$PROJECT_ROOT/ARCHITECTURE.md" 2>/dev/null || echo 0)
    echo "ARCHITECTURE.md cross-refs: $refs" >> "$outfile"
  fi

  echo "[xcode-bridge] Doc validation complete → $outfile"

  # Write structured summary
  local missing
  missing=$(grep -c "MISSING" "$outfile" 2>/dev/null || echo 0)
  cat > "$SWARM_ROOT/artifacts/build-summary.json" <<BEOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "scheme": "$SCHEME",
  "phase": "0-precode",
  "validation_type": "document",
  "missing_docs": $missing,
  "status": "$([ "$missing" -eq 0 ] && echo "pass" || echo "fail")"
}
BEOF
}

# ── Architecture Readiness Check ─────────────────────────────
xb_arch_readiness() {
  echo "[xcode-bridge] Checking architecture readiness for Phase 1..."
  local outfile="$SWARM_ROOT/artifacts/arch-readiness.txt"
  > "$outfile"

  # Check if folder structure is defined in ARCHITECTURE.md
  if [[ -f "$PROJECT_ROOT/ARCHITECTURE.md" ]]; then
    echo "=== Defined Folder Structure ===" >> "$outfile"
    grep -A 20 "folder\|directory\|structure" "$PROJECT_ROOT/ARCHITECTURE.md" 2>/dev/null | head -30 >> "$outfile"
  fi

  # Check if SceneKit patterns are defined (per CLAUDE.md: SceneKit + SwiftUI)
  echo "=== SceneKit Architecture Patterns ===" >> "$outfile"
  grep -rn "SceneKit\|SCN\|SceneView\|GameState\|GameEngine" "$PROJECT_ROOT"/*.md 2>/dev/null >> "$outfile" || echo "No SceneKit patterns found" >> "$outfile"

  # Check milestones for Phase 1 criteria
  echo "=== Phase 1 Criteria ===" >> "$outfile"
  if [[ -f "$PROJECT_ROOT/MILESTONES.md" ]]; then
    grep -A 10 "Phase 1\|phase 1\|MVP" "$PROJECT_ROOT/MILESTONES.md" 2>/dev/null | head -20 >> "$outfile"
  fi

  echo "[xcode-bridge] Arch readiness check → $outfile"
}

# ── Sister Project Check (GridWatchZero patterns) ────────────
xb_sister_check() {
  echo "[xcode-bridge] Checking sister project (GridWatchZero) pattern alignment..."
  local outfile="$SWARM_ROOT/artifacts/sister-alignment.txt"
  local sister="$PROJECT_ROOT/../GridWatchZero"
  > "$outfile"

  if [[ -d "$sister" ]]; then
    echo "=== GridWatchZero Patterns Available ===" >> "$outfile"
    echo "GameEngine split: $(find "$sister/GridWatchZero" -name "GameEngine+*" 2>/dev/null | wc -l | tr -d ' ') extensions" >> "$outfile"
    echo "CloudSaveManager: $(test -f "$sister/GridWatchZero/Engine/CloudSaveManager.swift" && echo "YES" || echo "NO")" >> "$outfile"
    echo "SaveMigration: $(test -f "$sister/GridWatchZero/Engine/SaveMigration.swift" && echo "YES" || echo "NO")" >> "$outfile"
  else
    echo "Sister project not found at $sister" >> "$outfile"
  fi
  echo "[xcode-bridge] Sister check → $outfile"
}

xb_mark_run() { touch "$SWARM_ROOT/artifacts/.last-run"; }

echo "[xcode-bridge] Loaded for WarSignalAir (Phase 0). Available: xb_doc_check, xb_arch_readiness, xb_sister_check, xb_mark_run"
echo "[xcode-bridge] NOTE: xb_build/test/analyze are stubs — no Xcode project exists yet."
