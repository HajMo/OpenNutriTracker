---
name: verify
description: Run static analysis and all tests to verify the project compiles and passes checks.
---

Run the following commands in sequence. Stop and report if any step fails:

1. `flutter analyze` — check for lint errors and warnings
2. `flutter test` — run all unit and widget tests

Report a summary of results: number of issues found (if any) and test pass/fail counts.
