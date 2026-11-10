# HydraKit API Rename Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove former-brand identifiers from the repository and expose HydraKit-named APIs.

**Architecture:** Apply case-preserving replacements from the former lower-camel and UpperCamel spellings to `hydraKit` and `HydraKit` across source, tests, examples, docs, and project metadata. Rename stale scheme files to match their new scheme names; do not add compatibility aliases or change behavior.

**Tech Stack:** Swift Package Manager, Swift, Xcode schemes, Markdown, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-11-10-hydrakit-api-rename-design.md`

## Global Constraints

- The rename is breaking; no compatibility aliases for the former API remain.
- Only identifiers and project labels change; behavior and dependency/platform requirements stay intact.
- HydraKit is the spelling and casing for the library brand.

## Review Focus

- Public theme modifier/environment key changes together: compile the package and tests that call `hydraKitTheme`.
- Static default helpers and all clients use the new spelling: compile the package and examples.
- Scheme names, scheme contents, and documentation workflow target agree: inspect the renamed scheme files and workflow.
- Repository scan finds no former-brand spellings outside Git metadata/build output.

---

### Task 1: Rename Swift APIs and all references

**Files:**
- Modify: all Swift files under `Sources/`, `Tests/`, and `Examples/` containing former-brand API identifiers
- Modify: `README.md`, `Documentation/`, and target READMEs containing API spellings

**Interfaces:**
- Produces: `hydraKitTheme`, `hydraKitPreview`, `hydraKitDefault`, `hydraKitEphemeral`, and `hydraKitLanguageIdentifier` plus any other direct case-preserving API renames found by the repository scan.

- [ ] Replace former lower-camel API spellings with `hydraKit` and UpperCamel project labels with `HydraKit` in the listed files, including tests and examples.
- [ ] Review the diff to ensure no API implementation or behavior changed beyond names.

### Task 2: Rename stale Xcode schemes and CI references

**Files:**
- Rename: `.swiftpm/xcode/xcshareddata/xcschemes/` scheme files from the former package prefix to corresponding HydraKit names
- Modify: scheme identifiers/buildable names and `.github/workflows/docs.yml`

**Interfaces:**
- Consumes: the HydraKit product/target names already defined in `Package.swift`.

- [ ] Update scheme identifiers to HydraKit identifiers matching actual package targets/products.
- [ ] Set the docs workflow target to `HydraKit`.

### Task 3: Verify complete rename

**Files:**
- Verify: all repository files except `.git` and build output

- [ ] Run a case-insensitive search for the former brand spellings; expected result is no matches.
- [ ] Run `swift test` from the package root; expected result is successful build and test completion.
- [ ] Run `git diff --check`; expected result is no whitespace errors.
