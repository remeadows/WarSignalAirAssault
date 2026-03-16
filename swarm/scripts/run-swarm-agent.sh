#!/usr/bin/env bash
# run-swarm-agent.sh — WarSignalAir Design Review Swarm Agent Runner
# Phase 0 (pre-code): Validates design documents, NOT code
set -uo pipefail
unset ANTHROPIC_API_KEY 2>/dev/null || true  # Force Max subscription billing

# ── Session & Billing ────────────────────────────────────────
SESSION_ID="${1:-unknown}"
BILLING_GUARD="${BILLING_GUARD:-false}"
start_time=$(date +%s)

if [[ "$BILLING_GUARD" == "true" ]]; then
  echo "[swarm] Billing guard enabled. Session: $SESSION_ID"
fi

# ── Project Setup ────────────────────────────────────────────
SWARM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "$SWARM_ROOT/.." && pwd)"
ARTIFACT_DIR="$SWARM_ROOT/artifacts"
LOG_DIR="$SWARM_ROOT/logs"

mkdir -p "$ARTIFACT_DIR" "$LOG_DIR"

# Session logging
SESSION_LOG="$LOG_DIR/session-${SESSION_ID}.log"
exec 1> >(tee -a "$SESSION_LOG")
exec 2>&1

echo "════════════════════════════════════════════════════════════"
echo "WarSignalAir Design Review Swarm Agent"
echo "Session: $SESSION_ID"
echo "Time: $(date)"
echo "════════════════════════════════════════════════════════════"

# ── Source xcode-bridge ──────────────────────────────────────
source "$SWARM_ROOT/scripts/xcode-bridge.sh"

# ── Metrics (Doc-based, not code-based) ──────────────────────
echo "[run-swarm-agent] Computing document metrics..."

# Count documents
DOC_COUNT=$(find "$PROJECT_ROOT" -maxdepth 1 -name "*.md" | wc -l)
echo "[run-swarm-agent] DOC_COUNT: $DOC_COUNT"

# Count total lines in all .md files
DOC_TOTAL_LINES=$(cat "$PROJECT_ROOT"/*.md 2>/dev/null | wc -l)
echo "[run-swarm-agent] DOC_TOTAL_LINES: $DOC_TOTAL_LINES"

# ── Document Reading Order (per CLAUDE.md) ──────────────────
echo "[run-swarm-agent] Loading design documents in order..."
CLAUDE_MD="$PROJECT_ROOT/CLAUDE.md"
ARCHITECTURE_MD="$PROJECT_ROOT/ARCHITECTURE.md"
GAME_DESIGN_MD="$PROJECT_ROOT/GAME_DESIGN.md"
PROJECT_PLAN_MD="$PROJECT_ROOT/PROJECT_PLAN.md"
ASSET_MANIFEST_MD="$PROJECT_ROOT/ASSET_MANIFEST.md"
MILESTONES_MD="$PROJECT_ROOT/MILESTONES.md"

# ── Agent Dispatch ───────────────────────────────────────────
AGENT_NAME="${2:-doc-reviewer}"
echo "[run-swarm-agent] Dispatching agent: $AGENT_NAME"

# Available xcode-bridge functions
echo "[run-swarm-agent] Available validators:"
echo "  - xb_doc_check (document presence & line counts)"
echo "  - xb_arch_readiness (folder structure, SceneKit patterns, Phase 1 criteria)"
echo "  - xb_sister_check (GridWatchZero alignment)"
echo "  - xb_mark_run (timestamp last run)"

# Build/test/analyze are stubs (Phase 0)
echo "[run-swarm-agent] NOTE: xb_build/test/analyze are stubs (Phase 0 — no Xcode project yet)"

# ── Invocation with Claude ───────────────────────────────────
if [[ -n "${AGENT_NAME}" ]]; then
  echo "[run-swarm-agent] Running: $AGENT_NAME"
  
  AGENT_PATH="$SWARM_ROOT/agents/${AGENT_NAME}.md"
  if [[ ! -f "$AGENT_PATH" ]]; then
    echo "[run-swarm-agent] ERROR: Agent file not found: $AGENT_PATH"
    exit 1
  fi

  # Build Claude system prompt incorporating agent role
  SYSTEM_PROMPT="$(cat <<'SYSPROMPT'
You are an intelligent swarm agent for WarSignalAir, an iOS cyberpunk gunship game in Phase 0 (pre-code planning).

Your primary task is DESIGN VALIDATION — reviewing, checking, and improving design documents.

Key facts:
- NO Swift files exist yet (Phase 0)
- NO Xcode project exists yet
- Project uses SceneKit + SwiftUI, iOS 26+, landscape-only
- Sister project: GridWatchZero (proven patterns available)
- All validation is document-based, not code-based

Available validators (xcode-bridge):
- xb_doc_check(): Check document presence, line counts, conflict markers, cross-references
- xb_arch_readiness(): Check folder structure definition, SceneKit patterns, Phase 1 criteria
- xb_sister_check(): Check GridWatchZero pattern alignment
- xb_mark_run(): Mark last run timestamp

ALWAYS read documents in this order:
1. CLAUDE.md (operating rules)
2. ARCHITECTURE.md (technical decisions)
3. GAME_DESIGN.md (gameplay, weapons, enemies, missions)
4. PROJECT_PLAN.md (phase checklists)
5. ASSET_MANIFEST.md (asset status)
6. MILESTONES.md (detailed build plan)

Your role is defined in the agent markdown file loaded for this session.
SYSPROMPT
)"

  # Invoke claude CLI with tools
  claude \
    --print \
    --system-prompt "$SYSTEM_PROMPT" \
    --dangerously-skip-permissions \
    --allowedTools "Read,Write,Edit,Glob,Grep,Bash,WebSearch,WebFetch" \
    --output-format text \
    --context "$(cat "$AGENT_PATH")" \
    --context "CLAUDE.md: $(cat "$CLAUDE_MD")" \
    --context "ARCHITECTURE.md: $(cat "$ARCHITECTURE_MD")" \
    --context "GAME_DESIGN.md: $(cat "$GAME_DESIGN_MD")" \
    --context "PROJECT_PLAN.md: $(cat "$PROJECT_PLAN_MD")" \
    --context "ASSET_MANIFEST.md: $(cat "$ASSET_MANIFEST_MD")" \
    --context "MILESTONES.md: $(cat "$MILESTONES_MD")"
fi

# ── Session Timing ───────────────────────────────────────────
end_time=$(date +%s)
duration=$((end_time - start_time))
echo "[run-swarm-agent] Session complete. Duration: ${duration}s"

# Mark run
xb_mark_run

exit 0
