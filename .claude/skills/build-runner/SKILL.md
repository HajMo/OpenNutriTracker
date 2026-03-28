---
name: build-runner
description: Run build_runner to regenerate Hive adapters, JSON serialization, and env.g.dart.
---

Run code generation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This regenerates all `*.g.dart` files (Hive type adapters, JSON serialization, envied secrets). Must be run after:
- Adding/changing Hive DBO fields
- Modifying `@JsonSerializable` classes
- Changing `.env` values
- Adding new `@Envied` fields

Report success or any errors encountered.
