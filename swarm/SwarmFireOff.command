#!/bin/bash
# SwarmFireOff.command — WarSignalAir Design Review Launcher
# Double-click from macOS Finder to start the full design review swarm

# ── Colors ───────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ── Banner ───────────────────────────────────────────────────
clear
echo -e "${CYAN}"
echo "════════════════════════════════════════════════════════════════"
echo "   ⚡ WARSIGNALAIR DESIGN REVIEW LAUNCHER"
echo "════════════════════════════════════════════════════════════════"
echo -e "${NC}"

# ── Setup ────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SWARM_SCRIPTS="$SCRIPT_DIR/scripts"

echo "Script directory: $SCRIPT_DIR"
echo "Fire-swarm script: $SWARM_SCRIPTS/fire-swarm.sh"

# ── Safety Checks ────────────────────────────────────────────
if [[ ! -f "$SWARM_SCRIPTS/fire-swarm.sh" ]]; then
  echo -e "${RED}ERROR: fire-swarm.sh not found at $SWARM_SCRIPTS${NC}"
  exit 1
fi

if [[ ! -x "$SWARM_SCRIPTS/fire-swarm.sh" ]]; then
  echo -e "${YELLOW}Making fire-swarm.sh executable...${NC}"
  chmod +x "$SWARM_SCRIPTS/fire-swarm.sh"
fi

# ── Launch ───────────────────────────────────────────────────
echo -e "${GREEN}Launching design review swarm...${NC}"
echo ""

# Run fire-swarm.sh
"$SWARM_SCRIPTS/fire-swarm.sh"
swarm_status=$?

# ── Summary ──────────────────────────────────────────────────
echo ""
if [[ $swarm_status -eq 0 ]]; then
  echo -e "${GREEN}✓ Design review swarm complete!${NC}"
  echo ""
  echo "Artifacts:"
  echo "  - doc-review.json (findings)"
  echo "  - design-plan.md (improvements to implement)"
  echo "  - verification.md (before/after comparison)"
  echo "  - session-summary.md (overview)"
  echo ""
  echo "Location: $SCRIPT_DIR/artifacts/"
  echo ""
  read -p "Press Enter to open artifacts folder..."
  open "$SCRIPT_DIR/artifacts"
else
  echo -e "${RED}✗ Design review swarm failed (status: $swarm_status)${NC}"
  read -p "Press Enter to exit..."
fi

exit $swarm_status
