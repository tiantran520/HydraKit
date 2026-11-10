# HydraKit API Rename Design

## Intent
Make the library consistently identify as HydraKit after it was added to the project with leftover former-brand names.

## Goals
- Rename every public Swift API identifier using the former brand prefix to the corresponding `hydraKit` identifier.
- Update all internal references, tests, examples, documentation, CI references, and Xcode scheme identifiers and filenames.
- Remove former-brand identifiers and labels from repository files.

## Non-goals and constraints
- This is a breaking API rename; no compatibility aliases for the former API will remain.
- Do not change behavior beyond identifier and project-label renames.
- Preserve existing HydraKit module, package, and product names unless a stale label remains.

## Approaches
- Keep prior API names as deprecated aliases: preserves source compatibility but leaves former-brand identifiers in the library. Not selected because the request is to rename all API names.
- Rename all occurrences to HydraKit: consistent public API and project naming, with source compatibility intentionally broken. Selected because the user explicitly requested a complete rename.

## Implementation calls
Use `hydraKitTheme`, `hydraKitDefault`, `hydraKitEphemeral`, `hydraKitPreview`, and `hydraKitLanguageIdentifier` as the direct camel-case replacements. Rename scheme files to match their HydraKit identifiers and update workflow references.

## Verification
Search the full repository for former-brand spellings and run the package build/tests if available.
