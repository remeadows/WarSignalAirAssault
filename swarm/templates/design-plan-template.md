# Design Plan — WarSignalAir Design Review Swarm

**Session**: <SESSION_ID>
**Date**: <TODAY>
**Review Date**: <TIMESTAMP FROM doc-review.json>

---

## Summary

- **Issues Found**: <TOTAL FROM doc-review.json>
- **Documents to Improve**: <COUNT>
- **Estimated Effort**: <SUM OF ALL EFFORTS>
- **Blocking Phase 1**: <true/false — if ANY critical blocker exists>

**Status**: READY FOR DOC-WRITER (all items have clear remediation steps)

---

## Notes for Doc-Writer

- Work on branch: `swarm/design-<SESSION_ID>`
- Create one commit per item (clear history)
- NO Swift/code files — Markdown only
- Reference design-plan.md items by checkbox (✓/☐)
- Test each change: grep the new content to verify it was added

---

## Priority 1: Critical Missing Docs

These documents don't exist at all. **Must create** before Phase 1.

### ☐ CREATE <DOCUMENT_NAME> (if applicable)

**Reason**: <Why this document blocks Phase 1>

**Scope**: <What should it contain? List expected sections>

**Template Structure**:
```markdown
# <Title>

## Section 1
...

## Section 2
...
```

**Effort**: <30 min | 1 hour | 2 hours>

**Blocker**: YES

**Commit Message**: "docs: create <DOCUMENT_NAME>"

---

## Priority 2: Critical Missing Sections

These sections are missing from existing documents. **Must add** before Phase 1.

### ☐ <DOCUMENT_NAME> → Add "<SECTION_NAME>" Section

**Reason**: <Why this section blocks Phase 1>

**Current State**: <What's in the doc now? What's missing?>

**Content to Add**:
```markdown
## <SECTION_NAME>

<Insert exact content here>

This section should:
- [ ] Explain <what>
- [ ] Define <what>
- [ ] List <what>
```

**Location in Document**: <Where to insert? E.g., "After 'Architecture Rules' section">

**Effort**: <20 min | 30 min | 1 hour>

**Blocker**: <true | false>

**Commit Message**: "docs: add <SECTION_NAME> to <DOCUMENT_NAME>"

---

## Priority 3: Incomplete Sections

These sections exist but lack detail. **Should enhance** before Phase 1.

### ☐ <DOCUMENT_NAME> → Enhance "<SECTION_NAME>" Section

**Current State**: <What's there now?>

**Missing Detail**: <What's vague or incomplete?>

**Changes**:
- [ ] Add <specific detail>
- [ ] Expand <section> with <specific example>
- [ ] Clarify <terminology>

**Effort**: <20 min | 30 min>

**Blocker**: <true | false>

**Commit Message**: "docs: enhance <SECTION_NAME> in <DOCUMENT_NAME>"

---

## Priority 4: Cross-Reference Issues

These are broken or weak references between docs. **Should fix** for consistency.

### ☐ <DOCUMENT_NAME> → Add Cross-Reference to <TARGET_DOCUMENT>

**Current**: <Current text>

**Fix**: <Change to>

**Reason**: <Why this connection is important>

**Effort**: <10 min | 15 min>

**Blocker**: false

**Commit Message**: "docs: fix cross-reference in <DOCUMENT_NAME>"

---

## Priority 5: Consistency Issues

These are terminology, format, or data conflicts between docs. **Should fix** for clarity.

### ☐ Fix Terminology: "<TERM_A>" vs "<TERM_B>"

**Where It Appears**:
- ARCHITECTURE.md uses <TERM_A>
- GAME_DESIGN.md uses <TERM_B>
- PROJECT_PLAN.md uses <TERM_A>

**Decision**: Use <TERM> everywhere because <reason>

**Changes**:
- [ ] Update ARCHITECTURE.md: <term> → <standard_term>
- [ ] Update GAME_DESIGN.md: <term> → <standard_term>
- [ ] Confirm PROJECT_PLAN.md uses <standard_term>

**Effort**: <15 min | 20 min>

**Blocker**: false

**Commit Message**: "docs: standardize <term> terminology"

---

## Priority 6: Readiness Gaps

These are optimizations (not blockers). **Nice to have** before Phase 1.

### ☐ <DOCUMENT_NAME> → Add Performance Targets

**Current**: <Vague acceptance criteria>

**Add**: <Specific metrics>

**Effort**: <20 min>

**Blocker**: false

**Commit Message**: "docs: add performance targets to <DOCUMENT_NAME>"

---

## Validation Gates

Before doc-writer starts, confirm:

- [ ] All issues have clear remediation steps (not vague)
- [ ] Each item lists what document to edit
- [ ] Each item specifies exact content to add/change
- [ ] Effort is estimated
- [ ] Blocker status is marked
- [ ] No items ask for code files (only Markdown)

**Gate Status**: ☐ PASS (all items clear and actionable)

---

## Execution Order

Doc-writer will execute in this order:

1. Priority 1: Create missing documents
2. Priority 2: Add critical sections
3. Priority 3: Enhance incomplete sections
4. Priority 4: Fix cross-references
5. Priority 5: Fix terminology/consistency
6. Priority 6: Optimize readiness

After each change:
```bash
git add <file>
git commit -m "<message>"
```

---

## Expected Outcome

After doc-writer completes:

- ✓ All Priority 1 & 2 items are complete
- ✓ Each change has a git commit
- ✓ Documents are consistent and complete
- ✓ Branch: swarm/design-<SESSION_ID>
- ✓ Ready for design-verifier to verify

---

**Prepared by**: Design Planner Agent
**Template Version**: 1.0
