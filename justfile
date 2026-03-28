intl_output_dir := "./lib/generated/intl/"

# Install dependencies
install:
  flutter pub get

# Build OpenNutriTracker
build:
  flutter pub run build_runner build --delete-conflicting-outputs

# Format dart code
format *OPTIONS:
  dart format {{OPTIONS}} ./lib ./test

# Regenerate intl files
run_intl: && format
  dart run intl_translation:generate_from_arb --output-dir {{intl_output_dir}} lib/**/*.dart ./lib/l10n/*.arb

# Check if intl files are correctly generated
check_intl: run_intl 
  git diff  --exit-code {{intl_output_dir}}

# Run tests
test:
  flutter test

# Run CI checks
ci: install (format "--set-exit-if-changed") check_intl build && test
  flutter analyze
