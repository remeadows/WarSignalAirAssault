#!/usr/bin/env bash
# fire-swarm.sh — WarSignalAir Design Review Swarm Orchestrator
# Runs all design review agents in sequence: doc-reviewer → design-planner → doc-writer → design-verifier
set -uo pipefail
unset ANTHROPIC_API_KEY 2>/dev/null || true  # Force Max subscription billing

# ── Colors for output ────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ── Banner ───────────────────────────────────────────────────
echo -e "${CYAN}"
echo "════════════════════════════════════════════════════════════"
echo "    WARSIGNALAIR DESIGN REVIEW SWARM"
echo "════════════════════════════════════════════════════════════"
echo -e "${NC}"

# ── Session Setup ────────────────────────────────────────────
SESSION_ID=$(date +%s)-$$
echo "Session: $SESSION_ID"
echo "Start time: $(date)"

# ── Project Setup ────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SWARM_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$SWARM_ROOT/.." && pwd)"
ARTIFACT_DIR="$SWARM_ROOT/artifacts"
ARCHIVE_DIR="$ARTIFACT_DIR/archive"

mkdir -p "$ARTIFACT_DIR" "$ARCHIVE_DIR"

# ── Archive previous run's artifacts ────────────────────────
if ls "$ARTIFACT_DIR"/*.json "$ARTIFACT_DIR"/*.md 2>/dev/null | head -1 | grep -q .; then
  arch_dest="$ARCHIVE_DIR/$SESSION_ID"
  mkdir -p "$arch_dest"
  cp "$ARTIFACT_DIR"/*.json "$ARTIFACT_DIR"/*.md "$arch_dest/" 2>/dev/null || true
  rm -f "$ARTIFACT_DIR"/*.json "$ARTIFACT_DIR"/*.md 2>/dev/null || true
  echo "[swarm] Previous artifacts archived to $arch_dest"
fi

# ── Source xcode-bridge ──────────────────────────────────────
source "$SCRIPT_DIR/xcode-bridge.sh"

# ── PRE-FLIGHT CHECKS ────────────────────────────────────────
echo -e "${YELLOW}[swarm] Running pre-flight validation...${NC}"

echo "[swarm] 1. Document check..."
xb_doc_check

echo "[swarm] 2. Architecture readiness check..."
xb_arch_readiness

echo "[swarm] 3. Sister project alignment check..."
xb_sister_check

echo -e "${GREEN}[swarm] Pre-flight complete${NC}"

# ── PHASE 1: DOCUMENT REVIEW ────────────────────────────────
echo -e "${YELLOW}[swarm] PHASE 1: DOCUMENT REVIEW (doc-reviewer agent)${NC}"

"$SCRIPT_DIR/run-swarm-agent.sh" "$SESSION_ID" "doc-reviewer"
doc_review_status=$?

if [[ $doc_review_status -ne 0 ]]; then
  echo -e "${RED}[swarm] Document review failed (status: $doc_review_status)${NC}"
  exit 1
fi

# ── GATE CHECK: doc-review.json must exist ───────────────────
if [[ ! -f "$ARTIFACT_DIR/doc-review.json" ]]; then
  echo -e "${RED}[swarm] GATE FAILURE: doc-review.json not found at $ARTIFACT_DIR/doc-review.json${NC}"
  echo "[swarm] Cannot proceed to planning phase without doc review results."
  exit 1
fi

echo -e "${GREEN}[swarm] Document review complete. Results: $ARTIFACT_DIR/doc-review.json${NC}"

# ── PHASE 2: DESIGN PLANNING ────────────────────────────────
echo -e "${YELLOW}[swarm] PHASE 2: DESIGN PLANNING (design-planner agent)${NC}"

"$SCRIPT_DIR/run-swarm-agent.sh" "$SESSION_ID" "design-planner"
design_plan_status=$?

if [[ $design_plan_status -ne 0 ]]; then
  echo -e "${RED}[swarm] Design planning failed (status: $design_plan_status)${NC}"
  exit 1
fi

# ── GATE CHECK: design-plan.md must exist ───────────────────
if [[ ! -f "$ARTIFACT_DIR/design-plan.md" ]]; then
  echo -e "${RED}[swarm] GATE FAILURE: design-plan.md not found at $ARTIFACT_DIR/design-plan.md${NC}"
  echo "[swarm] Cannot proceed to doc writing without design plan."
  exit 1
fi

echo -e "${GREEN}[swarm] Design planning complete. Plan: $ARTIFACT_DIR/design-plan.md${NC}"

# ── PHASE 3: DOCUMENT WRITING ───────────────────────────────
echo -e "${YELLOW}[swarm] PHASE 3: DOCUMENT WRITING (doc-writer agent)${NC}"

"$SCRIPT_DIR/run-swarm-agent.sh" "$SESSION_ID" "doc-writer"
doc_write_status=$?

if [[ $doc_write_status -ne 0 ]]; then
  echo -e "${RED}[swarm] Document writing failed (status: $doc_write_status)${NC}"
  exit 1
fi

echo -e "${GREEN}[swarm] Document writing complete${NC}"

# ── PHASE 4: VERIFICATION ───────────────────────────────────
echo -e "${YELLOW}[swarm] PHASE 4: VERIFICATION (design-verifier agent)${NC}"

"$SCRIPT_DIR/run-swarm-agent.sh" "$SESSION_ID" "design-verifier"
verify_status=$?

if [[ $verify_status -ne 0 ]]; then
  echo -e "${RED}[swarm] Verification failed (status: $verify_status)${NC}"
  exit 1
fi

# ── COMPLETION ──────────────────────────────────────────────
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    DESIGN REVIEW SWARM COMPLETE${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"

echo ""
echo "Key artifacts:"
echo "  - doc-review.json: Document completeness analysis"
echo "  - design-plan.md: Planned document improvements"
echo "  - verification.md: Before/after validation results"
echo "  - session-summary.md: Session overview"
echo ""
echo "End time: $(date)"
echo "Session: $SESSION_ID"

# ── Cleanup ──────────────────────────────────────────────────
xb_mark_run

# ── macOS completion notification ────────────────────────────
osascript -e "display notification \"Session $SESSION_ID complete\" with title \"WarSignalAir Design Review Swarm\"" 2>/dev/null || true

exit 0
